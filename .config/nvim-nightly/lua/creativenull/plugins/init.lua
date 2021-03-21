local current_path = (...):gsub('%.init$', '')
local install_path = os.getenv('HOME') .. '/.local/share/nvim-nightly/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd 'packadd packer.nvim'
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
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'tpope/vim-surround'
  use 'SirVer/ultisnips'
  use 'Shougo/context_filetype.vim'
  use 'tyru/caw.vim'
  use 'editorconfig/editorconfig-vim'
  use 'creativenull/projectcmd.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'mattn/emmet-vim'
  use 'nvim-telescope/telescope.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'hrsh7th/nvim-compe'
  use 'creativenull/diagnosticls-nvim'
  use 'glepnir/lspsaga.nvim'

  -- Themes and Syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'sheerun/vim-polyglot'
  use 'srcery-colors/srcery-vim'
end)

require(current_path .. '.config.compe')
require(current_path .. '.config.emmet')
require(current_path .. '.config.gitsigns')
require(current_path .. '.config.projectcmd')
require(current_path .. '.config.telescope')
require(current_path .. '.config.treesitter')
require(current_path .. '.config.lsp')
