-- Yank highlight
vim.cmd 'augroup yank_hl'
vim.cmd 'au!'
vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "Search", timeout = 500 })'
vim.cmd 'augroup end'

-- Statusline/Tabline highlights
vim.cmd 'augroup statusline_tabline_hl'
vim.cmd 'au!'
vim.cmd 'au ColorScheme * lua require"creativenull.statusline".set_highlights()'
vim.cmd 'au ColorScheme * lua require"creativenull.tabline".set_highlights()'
vim.cmd 'augroup end'

-- Statusline
vim.cmd 'augroup statusline_local'
vim.cmd 'au!'
vim.cmd 'au WinEnter * lua require"creativenull.statusline".setlocal_active_statusline()'
vim.cmd 'au WinLeave * lua require"creativenull.statusline".setlocal_inactive_statusline()'
vim.cmd 'augroup end'

 -- Enable invisible chars
vim.cmd 'augroup disable_char_list'
vim.cmd 'au!'
vim.cmd 'au FileType help setlocal nolist'
vim.cmd 'au FileType TelescopePrompt setlocal nolist'
vim.cmd 'augroup end'

-- lua 2 space indent
vim.cmd 'au! FileType lua setlocal tabstop=2'
