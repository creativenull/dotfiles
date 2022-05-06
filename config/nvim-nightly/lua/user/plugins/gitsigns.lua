local lazyLoadGitsignsPluginGroup = vim.api.nvim_create_augroup('lazyLoadGitsignsPluginGroup', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  desc = 'Lazy load gitsigns',
  group = lazyLoadGitsignsPluginGroup,
  once = true,

  callback = function()
    vim.cmd([[
      packadd gitsigns.nvim
      lua require('gitsigns').setup()
    ]])
  end,
})
