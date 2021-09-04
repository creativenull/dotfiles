local command = require('cnull.core.command')

local function codeshot_toggle()
  local nu = vim.opt.nu:get()
  if nu then
    vim.opt.number = false
    vim.opt.signcolumn = 'no'
  else
    vim.opt.number = true
    vim.opt.signcolumn = 'yes'
  end
end

command('ToggleCodeshot', codeshot_toggle)
