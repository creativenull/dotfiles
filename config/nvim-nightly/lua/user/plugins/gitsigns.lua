local lazy_load_gitsigns = vim.api.nvim_create_augroup('lazy_load_gitsigns_user_events', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  desc = 'Lazy load gitsigns',
  group = lazy_load_gitsigns,
  once = true,

  callback = function()
    vim.cmd([[
      packadd gitsigns.nvim
      lua require('gitsigns').setup()
    ]])
  end,
})
