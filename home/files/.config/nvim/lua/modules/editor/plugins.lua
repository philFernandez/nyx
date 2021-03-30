local editor = {}
local conf = require('modules.editor.config')

-- TODO: Look into
-- editor['windwp/nvim-autopairs'] = {}
editor['tmsvg/pear-tree'] = {
  config = conf.peartree,
}

editor['norcalli/nvim-colorizer.lua'] = {
  ft = { 'html','css','sass','vim','typescript','typescriptreact','lua'},
  config = conf.nvim_colorizer,
}

editor['thirtythreeforty/lessspace.vim'] = {
  config = conf.lessspace,
}

editor['editorconfig/editorconfig-vim'] = {
  config = conf.editorconfig,
}

editor['glacambre/firenvim'] = {
  cond = 'vim.g.started_by_firenvim',
  run = function() vim.fn['firenvim#install'](0) end,
  config = conf.firenvim,
}

editor['airblade/vim-rooter'] = {
  config = conf.rooter,
}

editor['nvim-telescope/telescope.nvim'] = {
  config = conf.telescope,
  requires = {
    {'nvim-lua/popup.nvim', opt=true},
    {'nvim-lua/plenary.nvim', opt=true},
    {'nvim-telescope/telescope-fzy-native.nvim'},
  }
}

return editor
