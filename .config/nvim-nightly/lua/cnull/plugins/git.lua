local M = {
  plugins = {
    {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}},
    {'tpope/vim-fugitive'},
  },
}

function M.after()
  require 'gitsigns'.setup()
end

return M
