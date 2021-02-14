vim.cmd 'command! Config edit $MYVIMRC'
vim.cmd [[command! ConfigReload lua require'creativenull.utils'.reload_config()]]

-- I can't release my shift key fast enough :')
vim.cmd 'command! -nargs=* W w'
vim.cmd 'command! -nargs=* Wq wq'
vim.cmd 'command! -nargs=* Q q'
vim.cmd 'command! -nargs=* Qa qa'
vim.cmd 'command! -nargs=* QA qa'

-- Toggle MD/Json quotes
vim.cmd [[command! ToggleConceal lua require'creativenull.utils'.toggle_conceal()]]
