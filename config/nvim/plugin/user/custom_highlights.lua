if vim.g.loaded_user_highlights ~= nil then
  return
end

vim.api.nvim_create_augroup('UserHighlightEvents', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'UserHighlightEvents',
  pattern = '*',
  callback = function()
    -- Don't want any bold or underlines on the tabline
    vim.cmd('highlight Tabline gui=NONE')

    -- Show different color in substitution mode aka `:substitute` / `:s`
    vim.cmd('highlight IncSearch gui=NONE guibg=#103da5 guifg=#eeeeee')
  end,
  desc = 'Custom user highlights',
})

vim.g.loaded_user_highlights = true
