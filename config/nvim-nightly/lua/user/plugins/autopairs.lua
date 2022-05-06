local lazyLoadAutopairsPluginGroup = vim.api.nvim_create_augroup('lazyLoadAutopairsPluginGroup', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  desc = 'Lazy load autopairs',
  group = lazyLoadAutopairsPluginGroup,
  once = true,

  callback = function()
    vim.cmd([[
      packadd nvim-autopairs
      lua require('nvim-autopairs').setup()
    ]])
  end,
})
