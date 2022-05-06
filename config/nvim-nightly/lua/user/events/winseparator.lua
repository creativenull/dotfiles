-- Only show fg color for WinSeparator highlight so it looks like a line
local hl_user_events = vim.api.nvim_create_augroup('hl_user_events', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = hl_user_events,

  callback = function()
    vim.api.nvim_command('highlight! WinSeparator guibg=NONE')
  end,

  desc = 'Only show fg color for WinSeparator',
})
