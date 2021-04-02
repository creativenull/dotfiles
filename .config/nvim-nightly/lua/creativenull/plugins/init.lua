local install_path = os.getenv('HOME') .. '/.local/share/nvim-nightly/site/pack/packer/opt/packer.nvim'

-- Packer.nvim bootstraping strategy
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local plugin_repo = 'https://github.com/wbthomason/packer.nvim'
  local cli = string.format('!git clone %s %s', plugin_repo, install_path)
  vim.cmd(cli)
end

vim.cmd 'packadd packer.nvim'
local packer = require 'packer'

-- Why do this? https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- A little more context, if you have a different location for your init.lua outside ~/.config/nvim
-- in my case, this is ~/.config/nvim-nightly - you may want to set a custom location for packer
packer.init {
  package_root = os.getenv('HOME') .. '/.local/share/nvim-nightly/site/pack',
  compile_path = os.getenv('HOME') .. '/.config/nvim-nightly/plugin/packer_compiled.vim'
}

-- For plugins that use g: vars for plugin config
require('creativenull.plugins.config')

-- Load plugins
packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -- Deps
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Editor
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'Shougo/context_filetype.vim'
  use 'tyru/caw.vim'
  use 'editorconfig/editorconfig-vim'
  use 'creativenull/projectcmd.nvim'
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'mattn/emmet-vim'
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'hrsh7th/nvim-compe'
  use 'creativenull/diagnosticls-nvim'
  use 'glepnir/lspsaga.nvim'

  -- Themes and Syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'evanleck/vim-svelte'
  use 'srcery-colors/srcery-vim'
end)

-- For plugins that load settings using setup()
require('creativenull.plugins.config.setup')
