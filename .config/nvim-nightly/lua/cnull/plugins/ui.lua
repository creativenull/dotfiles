local M = {
  plugins = {
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    {'lukas-reineke/indent-blankline.nvim'},
    {'akinsho/nvim-bufferline.lua', requires = {'kyazdani42/nvim-web-devicons'}},
    {'folke/todo-comments.nvim', requires = {'nvim-lua/plenary.nvim'}},
    {'glepnir/galaxyline.nvim', branch = 'main', requires = {'kyazdani42/nvim-web-devicons'}},
    {'code-biscuits/nvim-biscuits', requires = {'nvim-treesitter/nvim-treesitter'}},
  },
}

function M.before()
  require 'cnull.plugins.ui.indent_blankline'
end

function M.after()
  require 'cnull.plugins.ui.treesitter'
  require 'cnull.plugins.ui.biscuits'
  require 'cnull.plugins.ui.bufferline'
  require 'cnull.plugins.ui.galaxyline'
  require 'todo-comments'.setup {}
end

return M
