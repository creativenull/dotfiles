-- Only show fg color for WinSeparator highlight so it looks like a line
local winseparatorUserGroup = vim.api.nvim_create_augroup('winseparatorUserGroup', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = winseparatorUserGroup,

  callback = function()
    vim.api.nvim_command('highlight! WinSeparator guibg=NONE')
  end,

  desc = 'Only show fg color for WinSeparator',
})
