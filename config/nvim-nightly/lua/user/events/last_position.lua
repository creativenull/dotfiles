-- Move cursor to the last known position in the file
local lastPositionUserGroup = vim.api.nvim_create_augroup('lastPositionUserGroup', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = lastPositionUserGroup,

  callback = function()
    local prev_line_pos = vim.fn.line([['"]])
    local last_line = vim.fn.line('$')

    if prev_line_pos > 1 and prev_line_pos <= last_line then
      vim.api.nvim_command([[normal! g'"]])
    end
  end,

  desc = 'Move cursor to the last known position in the buffer',
})
