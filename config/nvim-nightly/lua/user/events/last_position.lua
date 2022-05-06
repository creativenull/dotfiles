-- Move cursor to the last known position in the file
local last_position_user_events = vim.api.nvim_create_augroup('last_position_user_events', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = last_position_user_events,

  callback = function()
    local prev_line_pos = vim.fn.line([['"]])
    local last_line = vim.fn.line('$')

    if prev_line_pos > 1 and prev_line_pos <= last_line then
      vim.api.nvim_command([[normal! g'"]])
    end
  end,

  desc = 'Move cursor to the last known position in the buffer',
})
