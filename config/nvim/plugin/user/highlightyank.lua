if vim.g.loaded_user_highlightyank ~= nil then
  return
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.g.user.event,
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 })
  end,
  desc = 'Highlight words when a yank (y) is performed',
})

vim.g.loaded_user_highlightyank = true
