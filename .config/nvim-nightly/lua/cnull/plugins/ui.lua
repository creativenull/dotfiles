local M = {
  plugins = {
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    {'nvim-treesitter/nvim-treesitter-refactor'},
    {'code-biscuits/nvim-biscuits'},
    {'lukas-reineke/indent-blankline.nvim', opt = true},
    {'kyazdani42/nvim-web-devicons'},
    {'akinsho/nvim-bufferline.lua'},
    {'folke/todo-comments.nvim', opt = true},
    {'glepnir/galaxyline.nvim'},
    {'plasticboy/vim-markdown', opt = true},
  },
}

function M.after()
  require('cnull.plugins.ui.treesitter')
  require('cnull.plugins.ui.biscuits')
  require('cnull.plugins.ui.bufferline')
  require('cnull.plugins.ui.galaxyline')
end

return M
