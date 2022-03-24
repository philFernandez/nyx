# Platform and path

Before starting it is a good idea to collect information about the current system and store that information.

```lua
-- lua/eden/core/platform.lua
local M = {}

local uname = vim.loop.os_uname()

M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_windows = uname.sysname == "Windows_NT"
M.is_wsl = not (string.find(uname.release, "microsoft") == nil)

return M
```

> Note: You will see this pattern where a local table `M` is defined and then returned at the end of the file. This
> `M` stands for `module` and is a lua convention. Anything that is added to `M` is returned when requiring this
> module.

This script provides a convient way of checking what platform we are on. `vim.loop` references nvim's event loop and
we are getting

This script provides a convient way of checking what platform we are on. This is done by calling into neovim's event
loop with `vim.loop` (`:help vim.loop` for more info). Here is an example of the result:

```
{
  machine = "x86_64",
  release = "4.19.104-microsoft-standard",
  sysname = "Linux",
  version = "#1 SMP Wed Feb 19 06:37:35 UTC 2020"
}
```

You can see from this that the terminal I am writing this in is in `wsl`.

## Path utility

Now that we know some information about the platform we are on this information will come in handy when we define some
information about the paths we will be using.

```lua
-- lua/eden/core/path.lua
local platform = require("eden.core.platform")
local home = os.getenv("HOME")
local uv = vim.loop
local fmt = string.format

local M = {}

M.sep = platform.is_windows and [[\]] or "/"

-- Join a list of paths together
-- @param ... string list
-- @return string
M.join = function(...)
  return table.concat({ ... }, M.sep)
end

-- Define default values for important path locations
M.home = home
M.confighome = M.join(home, ".config", "nvim")
M.datahome = M.join(home, ".local", "share", "nvim")
M.cachehome = M.join(home, ".cache", "nvim")

return M
```

