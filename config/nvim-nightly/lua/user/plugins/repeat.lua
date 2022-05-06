local lazyLoadRepeatPluginGroup = vim.api.nvim_create_augroup('lazyLoadRepeatPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Lazy load repeat',
  group = lazyLoadRepeatPluginGroup,
  once = true,

  command = 'packadd vim-repeat',
})
