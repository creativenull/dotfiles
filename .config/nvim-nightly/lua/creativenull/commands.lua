vim.cmd('command! Config edit $MYVIMRC')

-- TODO
-- Seems like this doesn't reload all the modules
-- find another alternative
vim.cmd('command! ConfigReload luafile $MYVIMRC')

-- I can't release my shift key fast enough :')
vim.cmd('command! -nargs=* W w')
vim.cmd('command! -nargs=* Wq wq')
vim.cmd('command! -nargs=* Q q')
vim.cmd('command! -nargs=* Qa qa')
vim.cmd('command! -nargs=* QA qa')
