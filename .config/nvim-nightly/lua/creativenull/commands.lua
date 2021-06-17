-- Toggle MD/Json quotes
vim.cmd [[command! ToggleConceal lua require'creativenull.utils'.toggle_conceal()]]

-- Reload config
vim.cmd [[command! ConfigReload lua require'creativenull.utils'.reload_config()]]

-- Codeshot
vim.cmd 'command! CodeshotEnable call creativenull#codeshot#enable()'
vim.cmd 'command! CodeshotDisable call creativenull#codeshot#disable()'

-- I can't release my shift key fast enough :')
vim.cmd 'command! W w'
vim.cmd 'command! Wq wq'
vim.cmd 'command! Q q'
vim.cmd 'command! Qa qa'
vim.cmd 'command! QA qa'
