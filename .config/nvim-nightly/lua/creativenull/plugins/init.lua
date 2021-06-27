local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

-- Packer.nvim bootstraping strategy
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local plugin_repo = 'https://github.com/wbthomason/packer.nvim'
  vim.cmd(string.format('!git clone %s %s', plugin_repo, install_path))
end

vim.cmd 'packadd packer.nvim'
local packer = require 'packer'

-- For plugins that use g: as config
require 'creativenull.plugins.config'.init()

-- Load plugins
packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -- Deps
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'Shougo/context_filetype.vim'

  -- Editor
  use 'creativenull/projectcmd.nvim'
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'editorconfig/editorconfig-vim'
  use 'mattn/emmet-vim'
  use 'kevinhwang91/nvim-bqf'
  use 'tyru/caw.vim'
  use 'lewis6991/gitsigns.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'cohama/lexima.vim'
  use 'tpope/vim-fugitive'
  use 'mcchrish/nnn.vim'
  use 'tpope/vim-abolish'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'hrsh7th/nvim-compe'
  use 'glepnir/lspsaga.nvim'
  use 'creativenull/diagnosticls-nvim'

  -- Themes and Syntax
  use 'norcalli/nvim-colorizer.lua'
  use 'kyazdani42/nvim-web-devicons'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'code-biscuits/nvim-biscuits'
  use { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
  use 'evanleck/vim-svelte'
  use 'akinsho/nvim-bufferline.lua'
  use 'glepnir/galaxyline.nvim'
  use 'folke/todo-comments.nvim'
  use 'glepnir/zephyr-nvim'
  use 'srcery-colors/srcery-vim'
end)

-- For plugins that use setup() as config
require 'creativenull.plugins.config'.setup()
