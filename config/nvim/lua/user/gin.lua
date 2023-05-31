local M = {}

function M.setup()
  local gin = {}

  -- Push from git repo, notify user since this is async
  gin.push_origin = function()
    -- local branch = vim.call('gitbranch#name')
    local branch = vim.g.gitsigns_head
    local cmd = string.format('Gin push origin %s', branch)
    print(cmd)
    vim.cmd(cmd)
  end

  -- Pull from git repo, notify user since this is async
  gin.pull_origin = function()
    -- local branch = vim.call('gitbranch#name')
    local branch = vim.g.gitsigns_head
    local cmd = string.format('Gin pull origin %s', branch)
    print(cmd)
    vim.cmd(cmd)
  end

  vim.keymap.set('n', '<Leader>gs', '<Cmd>GinStatus<CR>')
  vim.keymap.set('n', '<Leader>gp', gin.push_origin, { desc = 'Git push to origin from default branch' })
  vim.keymap.set('n', '<Leader>gpp', ':Gin push origin ')
  vim.keymap.set('n', '<Leader>gl', gin.pull_origin, { desc = 'Git pull from origin from default branch' })
  vim.keymap.set('n', '<Leader>gll', ':Gin pull origin ')
  vim.keymap.set('n', '<Leader>gb', '<Cmd>GinBranch<CR>')
end

return M
