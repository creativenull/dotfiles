-- Ref: https://github.com/jvirtanen/vim-cocoapods
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.podspec',
  command = 'set filetype=ruby',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'Podfile',
  command = 'set filetype=ruby',
})
