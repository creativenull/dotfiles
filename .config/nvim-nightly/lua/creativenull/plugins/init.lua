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
  use 'windwp/nvim-autopairs'
  use 'kevinhwang91/nvim-bqf'
  use { 'tyru/caw.vim', requires = { 'Shougo/context_filetype.vim' } }
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'hrsh7th/nvim-compe'
  use 'glepnir/lspsaga.nvim'
  use 'creativenull/diagnosticls-nvim'

  -- Themes and Syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'code-biscuits/nvim-biscuits', requires = 'nvim-treesitter/nvim-treesitter' }
  use 'evanleck/vim-svelte'
  use 'karb94/neoscroll.nvim'
  use 'srcery-colors/srcery-vim'

  -- For Development
  -- use '~/projects/github.com/creativenull/projectcmd.nvim'
  -- use '~/projects/github.com/creativenull/diagnosticls-nvim'
end)

-- For plugins that use setup() as config
require 'creativenull.plugins.config'.setup()
