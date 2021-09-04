local M = {
  plugins = {
    {'lewis6991/gitsigns.nvim'},
    {'tpope/vim-fugitive'},
  },
}

function M.after()
  require('gitsigns').setup()
end

return M
