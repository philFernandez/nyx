local path = require("eden.core.path")
local execute = vim.api.nvim_command
local err = vim.api.nvim_err_writeln
local fmt = string.format

local packer = nil
local ensured = {}

local M = {
  modlist = {},
  modname = "eden.modules",
  init = {
    package_root = path.packroot,
    compile_path = path.packer_compiled,
    git = { clone_timeout = 120 },
    max_jobs = 10,
  },
  local_plugins = path.join(path.home, "dev", "plugins"),
  lockfile_path = path.join(path.confighome, "packlist.lock"),
  apply_lockfile = false,
  locklist = {},
  pluglist = {},
}

-- Read the contents of the lockfile and return it as a table
-- @return table
local function load_lockfile()
  local file = assert(io.open(M.lockfile_path, "r"))
  local contents = file:read("*a")
  file:close()
  return vim.json.decode(contents)
end

-- Write the contents of the internal lockfile list to the lockfile
local function write_lockfile()
  local contents = vim.json.encode(M.locklist):gsub("{", "{\n  "):gsub("}", "\n}"):gsub(":", ": "):gsub(",", ",\n  ")
  local file = assert(io.open(M.lockfile_path, "w"))
  file:write(contents)
  file:close()
end

-- Searches though all installed packer plugins and collects the current
-- git hash for each plugin. Returns the list in a table.
-- @return table
local function cache_commit_hashes()
  local result = {}

  for name, value in pairs(packer_plugins) do
    if value.path then -- TODO: Not sure why this is sometimes not defined
      local root = path.join(value.path, ".git")
      local cmd = fmt([[git --git-dir="%s" rev-parse HEAD]], root)
      local process = assert(io.popen(cmd, "r"))
      local commit = process:read("l")
      process:close()
      result[name] = commit
    end
  end

  return result
end

local function process_plugin_table(value)
  if type(value) == "table" then
    if type(value[1]) ~= "string" then
      -- We have not hit a leaf node need to
      local result = {}
      for _, v in ipairs(value) do
        table.insert(result, process_plugin_table(v))
      end
      return result
    end

    -- We are a list of strings. This might be in a required block for example.
    -- Example:
    -- requires = { "williamboman/nvim-lsp-installer", "ray-x/lsp_signature.nvim", "nvim-lua/lsp-status.nvim", },
    if #value > 1 then
      local result = {}
      for _, str in ipairs(value) do
        table.insert(result, process_plugin_table({ str }))
      end
      return result
    end

    local name = value.as and value.as or value[1]:match("/(.*)$")
    if M.locklist[name] then
      local commit = value.commit or M.locklist[name]
      value.commit = commit
    end

    if value.requires then
      value.requires = process_plugin_table(value.requires)
    end

    return value
  end

  return value
end

local function apply_lockfile(plugins)
  local results = {}
  for _, plugin in ipairs(plugins) do
    table.insert(results, process_plugin_table(plugin))
  end
  return results
end

-- Ensure that a plugin is installed and execute a callback.
-- Returns if the plugin was cloned.
-- @param user string
-- @param repo string
-- @param cb function
-- @return bool
M.ensure = function(user, repo, cb)
  local install_path = path.join(path.packroot, "packer", "opt", repo)
  local installed = false
  if not path.exists(install_path) then
    execute(fmt("!git clone --depth=1 https://github.com/%s/%s %s", user, repo, install_path))
    installed = true
  end

  execute(fmt("packadd %s", repo))
  table.insert(ensured, fmt("%s/%s", user, repo))

  if cb ~= nil then
    cb()
  end

  return installed
end

-- Execute `PackerCompile` if file exists in `path.module_path`
M.auto_compile = function()
  M.clean()
  M.compile()
end

-- Check local development plugin location (pack.local_plugins)
-- if plugin exists. Returns abs path to local file if it exists.
-- @param slug string
-- @return string
M.dev = function(slug, as)
  local name = as and as or string.match(slug, ".*/(.*)")
  local abs = path.join(M.local_plugins, name)
  local exists = path.exists(abs)
  return exists and abs or slug
end

-- Load plugins from pack.modulename
M.load_plugins = function()
  if not packer then
    packer = require("packer")

    -- Pass some packer commands to the pack module
    local commands = { "install", "sync", "clean", "update", "use", "compile" }
    for _, cmd in ipairs(commands) do
      M[cmd] = packer[cmd]
    end
  end

  if M.modlist == nil then
    M.modlist = path.modlist(M.modname)
  end

  local list = {}
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.plugins then
      for _, plugin in ipairs(mod.plugins) do
        table.insert(list, plugin)
      end
    else
      err(fmt("plugin module: %s is required to return `plugins` property", modname))
    end
  end

  -- Add ensured plugins to packer
  for _, en in ipairs(ensured) do
    table.insert(list, { en, opt = true })
  end

  M.pluglist = M.apply_lockfile and apply_lockfile(list) or list

  packer.init(M.init)
  packer.startup(function(use)
    for _, plugin in ipairs(M.pluglist) do
      use(plugin)
    end
  end)
end

local function testing()
  local modlist = path.modlist(M.modname)

  M.locklist = cache_commit_hashes()
  local list = {}
  for _, modname in ipairs(modlist) do
    local mod = require(modname)
    if mod.plugins then
      for _, plugin in ipairs(mod.plugins) do
        table.insert(list, plugin)
      end
    else
      err(fmt("plugin module: %s is required to return `plugins` property", modname))
    end
  end

  return apply_lockfile(list)
end
-- testing()

local function asdf()
  M.locklist = cache_commit_hashes()
  write_lockfile()
end
-- asdf()

-- Trigger all plugin modules that contian an before() function
M.trigger_before = function()
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.before and type(mod.before) == "function" then
      mod.before()
    end
  end
end

-- Trigger all plugin modules that contian an after() function
M.trigger_after = function()
  for _, modname in ipairs(M.modlist) do
    local mod = require(modname)
    if mod.after and type(mod.after) == "function" then
      mod.after()
    end
  end
end

-- Bootstraping plugins.
-- Takes callback function that takes if packer was installed.
-- @param cb function(bool)
M.bootstrap = function(cb)
  -- Ensuring that impatient is installed and required before any plugins have been required
  -- Only required until pr is merged https://github.com/neovim/neovim/pull/15436
  M.ensure("lewis6991", "impatient.nvim", function()
    require("impatient")
  end)

  -- Fill in modlist before the `before` trigger is well... triggered
  M.modlist = path.modlist(M.modname)

  local installed = M.ensure("wbthomason", "packer.nvim", function()
    M.trigger_before()
    M.load_plugins()
  end)

  if cb then
    cb(installed)
  end
end

return M
