-- Yank highlight
vim.cmd 'augroup yank_hl'
vim.cmd 'au!'
vim.cmd [[au TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'Search', timeout = 500 }]]
vim.cmd 'augroup END'

-- Statusline/Tabline highlights
vim.cmd 'augroup statusline_tabline_hi'
vim.cmd 'au!'
vim.cmd [[au ColorScheme * lua require'creativenull.statusline'.set_highlights()]]
vim.cmd [[au ColorScheme * lua require'creativenull.tabline'.set_highlights()]]
vim.cmd 'augroup END'
