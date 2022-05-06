local lazy_load_autopairs = vim.api.nvim_create_augroup('lazy_load_autopairs_user_events', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  desc = 'Lazy load autopairs',
  group = lazy_load_autopairs,
  once = true,

  callback = function()
    vim.cmd([[
      packadd nvim-autopairs
      lua require('nvim-autopairs').setup()
    ]])
  end,
})
