local lazyLoadAbolishPluginGroup = vim.api.nvim_create_augroup('lazyLoadAbolishPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Lazy load abolish',
  group = lazyLoadAbolishPluginGroup,
  once = true,

  command = 'packadd vim-abolish',
})
