vim.cmd 'packadd packer.nvim'
local packer = require 'packer'

-- Why do this? https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- A little more context, if you have a different location for your init.lua outside ~/.config/nvim
-- in my case, this is ~/.config/nvim-nightly - you may want to set a custom location for packer
packer.init {
  package_root = '~/.local/share/nvim-nightly/site/pack',
  compile_path = '~/.config/nvim-nightly/plugin/packer_compiled.vim'
}

packer.startup(function()
  use { 'wbthomason/packer.nvim', opt = true }

  -- Editor
  use 'creativenull/projectcmd.nvim'
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'Shougo/context_filetype.vim'
  use 'tyru/caw.vim'
  use { 'lewis6991/gitsigns.nvim', requires = {
    { 'nvim-lua/plenary.nvim' }
  }}
  use 'editorconfig/editorconfig-vim'
  use 'mattn/emmet-vim'
  use { 'nvim-telescope/telescope.nvim', requires = {
    { 'nvim-lua/popup.nvim' },
    { 'nvim-lua/plenary.nvim' }
  }}

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  -- use 'nvim-lua/completion-nvim'
  use 'nvim-lua/lsp-status.nvim'

  -- Themes and Syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neoclide/jsonc.vim'
  use 'iloginow/vim-stylus'
  use 'srcery-colors/srcery-vim'
end)

-- Plugin Configs
local current_path = (...):gsub('%.init$', '')
require(current_path .. '.config.lsp')
require(current_path .. '.config.treesitter')
require(current_path .. '.config.telescope')
require(current_path .. '.config.gitsigns')
require(current_path .. '.config.emmet')
require(current_path .. '.config.projectcmd')
require(current_path .. '.config.compe')
