if vim.g.loaded_user_highlights ~= nil then
  return
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.g.user.event,
  callback = function()
    -- Don't want any bold or underlines on the tabline
    -- vim.cmd('highlight Tabline gui=NONE')
    vim.api.nvim_set_hl(0, 'Tabline', { bold = false, underline = false, undercurl = false, italic = false })

    -- Show different color in substitution mode aka `:substitute` / `:s`
    -- vim.cmd('highlight IncSearch gui=NONE guibg=#103da5 guifg=#eeeeee')
    vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#103da5', fg = '#eeeeee' })
  end,
  desc = 'Custom user highlights',
})

vim.g.loaded_user_highlights = true
