local set_augroup = require 'creativenull.utils'.set_augroup

-- Background transparency
set_augroup('transparent_bg_group', {
  'autocmd ColorScheme * highlight Normal guibg=NONE',
  'autocmd ColorScheme * highlight SignColumn guibg=NONE',
  'autocmd ColorScheme * highlight LineNr guibg=NONE guifg=#aaaaaa',
  'autocmd ColorScheme * highlight CursorLineNr guibg=NONE',
})

-- Lua and Vim tab options
set_augroup('lua_ft', {
  'autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=0 expandtab',
  'autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=0 expandtab'
})

-- Nvim biscuits
vim.cmd 'autocmd! ColorScheme * hi BiscuitColor guifg=#999999 gui=italic'

-- Trim whitespace on all files
vim.cmd [[autocmd! BufWritePre * %s/\s\+$//e]]

-- Yank highlight
vim.cmd [[autocmd! TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'Search', timeout = 500 })]]
