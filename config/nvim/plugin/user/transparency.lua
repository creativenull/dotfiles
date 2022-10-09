if vim.g.loaded_user_transparency ~= nil then
  return
end

if vim.g.user.transparent then
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.g.user.event,
    command = 'echomsg "WIP"',
    desc = 'Set transparent highlights when enabled',
  })
end

vim.g.loaded_user_transparency = true
