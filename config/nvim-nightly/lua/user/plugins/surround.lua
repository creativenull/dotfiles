local lazyLoadSurroundPluginGroup = vim.api.nvim_create_augroup('lazyLoadSurroundPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Lazy load surround',
  group = lazyLoadSurroundPluginGroup,
  once = true,

  command = 'packadd vim-surround',
})
