vim.cmd 'packadd packer.nvim'
local packer = require 'packer'

packer.init {
  package_root = '~/.local/share/nvim-nightly/site/pack',
  compile_path = '~/.config/nvim-nightly/plugin/packer_compiled.vim'
}

packer.startup(function()
  use { 'wbthomason/packer.nvim', opt = true }

  -- Editor
  use '~/projects/github.com/creativenull/projectcmd.nvim'
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'Shougo/context_filetype.vim'
  use 'tyru/caw.vim'
  use { 'lewis6991/gitsigns.nvim', requires = {
    { 'nvim-lua/plenary.nvim' }
  } }
  use 'editorconfig/editorconfig-vim'
  use 'mattn/emmet-vim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'nvim-lua/lsp-status.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = {
    { 'nvim-lua/popup.nvim' },
    { 'nvim-lua/plenary.nvim' }
  }}

  -- Themes and Syntax
  use 'gruvbox-community/gruvbox'
  use 'srcery-colors/srcery-vim'
  use 'neoclide/jsonc.vim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)

-- Plugin Configs
local current_path = (...):gsub('%.init$', '')
require(current_path .. '.config.lsp')
require(current_path .. '.config.treesitter')
require(current_path .. '.config.telescope')
require(current_path .. '.config.gitsigns')
require(current_path .. '.config.emmet')
require(current_path .. '.config.projectcmd')
