local M = {
  plugins = {
    {'SirVer/ultisnips', requires = {'honza/vim-snippets'}},
  },
}

function M.before()
  vim.g.UltiSnipsExpandTrigger = '<C-q>.'
  vim.g.UltiSnipsJumpForwardTrigger = '<C-j>'
  vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
end

return M
