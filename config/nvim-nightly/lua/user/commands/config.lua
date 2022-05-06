-- Open/reload config
vim.api.nvim_create_user_command('Config', string.format('edit ~/.config/%s/init.lua', vim.g.userspace), {})
vim.api.nvim_create_user_command(
  'ConfigReload',
  string.format('so ~/.config/%s/init.lua | nohlsearch', vim.g.userspace),
  {}
)
