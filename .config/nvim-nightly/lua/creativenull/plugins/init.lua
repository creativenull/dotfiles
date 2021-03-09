vim.cmd 'packadd packer.nvim'
local current_path = (...):gsub('%.init$', '')
local packer = require 'packer'

-- Why do this? https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- A little more context, if you have a different location for your init.lua outside ~/.config/nvim
-- in my case, this is ~/.config/nvim-nightly - you may want to set a custom location for packer
packer.init {
  package_root = '~/.local/share/nvim-nightly/site/pack',
  compile_path = '~/.config/nvim-nightly/plugin/packer_compiled.vim'
}

packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -- Editor
  use {
    'creativenull/projectcmd.nvim',
    config = require(current_path .. '.config.projectcmd').config()
  }

  use 'tpope/vim-surround'

  use 'SirVer/ultisnips'

  use 'Shougo/context_filetype.vim'

  use 'tyru/caw.vim'

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = require(current_path .. '.config.gitsigns').config()
  }

  use 'editorconfig/editorconfig-vim'

  use {
    'mattn/emmet-vim',
    config = require(current_path .. '.config.emmet').config()
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = require(current_path .. '.config.telescope').config()
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    setup = require(current_path .. '.config.lsp').setup(),
    config = require(current_path .. '.config.lsp').config()
  }

  use {
    'creativenull/diagnosticls-nvim',
    requires = { 'neovim/nvim-lspconfig' }
  }

  use {
    'hrsh7th/nvim-compe',
    config = require(current_path .. '.config.compe').config()
  }

  use 'nvim-lua/lsp-status.nvim'

  -- Themes and Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require(current_path .. '.config.treesitter').config()
  }

  use 'neoclide/jsonc.vim'

  use 'iloginow/vim-stylus'

  use 'srcery-colors/srcery-vim'
end)
