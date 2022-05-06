-- Only adjust highlight colors when transparent is enabled by the user
-- these are customs changes irrelevant to themes
if _G.User.transparent then
  local transparent_user_events = vim.api.nvim_create_augroup('transparent_user_events', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = transparent_user_events,

    callback = function()
      vim.api.nvim_command('highlight! Normal guibg=NONE')
      vim.api.nvim_command('highlight! SignColumn guibg=NONE')
      vim.api.nvim_command('highlight! LineNr guibg=NONE')
      vim.api.nvim_command('highlight! CursorLineNr guibg=NONE')
      vim.api.nvim_command('highlight! EndOfBuffer guibg=NONE')
      vim.api.nvim_command('highlight! ColorColumn guibg=#444444')

      -- Transparent LSP Float Windows
      vim.api.nvim_command('highlight! NormalFloat guibg=NONE')
      vim.api.nvim_command('highlight! ErrorFloat guibg=NONE')
      vim.api.nvim_command('highlight! WarningFloat guibg=NONE')
      vim.api.nvim_command('highlight! InfoFloat guibg=NONE')
      vim.api.nvim_command('highlight! HintFloat guibg=NONE')
      vim.api.nvim_command('highlight! FloatBorder guifg=#aaaaaa guibg=NONE')

      -- Transparent Comments
      vim.api.nvim_command('highlight! Comment guifg=#888888 guibg=NONE')
    end,

    desc = 'Adjust highlight colors for transparency',
  })
end
