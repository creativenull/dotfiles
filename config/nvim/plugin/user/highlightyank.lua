if vim.g.loaded_user_highlightyank ~= nil then
  return
end

vim.api.nvim_create_augroup('UserHighlightYankEvents', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'UserHighlightYankEvents',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
  end,
  desc = 'Highlight words when a yank (y) is performed',
})

vim.g.loaded_user_highlightyank = true
