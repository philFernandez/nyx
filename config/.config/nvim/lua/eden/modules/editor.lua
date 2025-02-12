local M = {}

M.plugins = {

  -- Completion ---------------------------------------------------------------

  {
    "windwp/nvim-autopairs",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-autopairs", 70)
    end,
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        enable_check_bracket_line = true,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    after = "nvim-autopairs",
    conf = "editor.cmp",
  },

  {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = function()
      -- require("eden.modules.editor.snips")
      require("luasnip").config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
    end,
  },

  -- Sources

  { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
  { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
  { "hrsh7th/cmp-path", after = "nvim-cmp" },
  { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
  { "f3fora/cmp-spell", after = "nvim-cmp" },
  { "ray-x/cmp-treesitter", after = "nvim-cmp" },

  -- --------------------------------------------------------------------------

  { "editorconfig/editorconfig-vim" },
  { "christoomey/vim-tmux-navigator" },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", ".hg", ".root" },
        ignore_lsp = { "efm" },
        -- TODO: Not working
        -- datapath = path.cachehome,
      })
    end,
  },

  {
    "akinsho/nvim-toggleterm.lua",
    conf = "editor.toggleterm",
    cmd = { "ToggleTerm" },
    keys = { "<c-space>" },
  },

  {
    "ojroques/nvim-bufdel",
    opt = true,
    startup = function()
      require("eden.lib.defer").add("nvim-bufdel", 40)
    end,
    config = function()
      require("bufdel").setup({
        next = "alternate",
        quit = false,
      })

      nmap("<leader>bq", [[<cmd>BufDel<cr>]], { desc = "Delete buffer" })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown", "vimwiki" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
    config = function()
      nmap("<leader>tp", ":MarkdownPreviewToggle<cr>", { desc = "Markdown preview" })
    end,
  },

  {
    "anuvyklack/hydra.nvim",
    opt = true,
    startup = function()
      require("eden.lib.defer").add("hydra.nvim", 40)
    end,
    conf = "editor.hydra",
  },

  -- Profiling
  {
    "dstein64/vim-startuptime",
    -- "tweekmonster/startuptime.vim",
    cmd = { "StartupTime" },
  },
}

M.before = function()
  -- Editorconfig
  vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

  -- Markdown preview
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_echo_preview_url = 1
end

return M
