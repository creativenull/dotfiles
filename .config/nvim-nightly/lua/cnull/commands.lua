local command = require 'cnull.core.command'

command('ConfigPlugins', [[execute "edit ]] .. vim.env.HOME .. [[/.config/nvim-nightly/lua/cnull/plugins/plugins.lua"]])

-- I can't release my shift key fast enough :')
command('W',  [[w]],  {'-bang'})
command('Wq', [[wq]], {'-bang'})
command('WQ', [[wq]], {'-bang'})
command('Q',  [[q]],  {'-bang'})
command('Qa', [[qa]], {'-bang'})
command('QA', [[qa]], {'-bang'})
