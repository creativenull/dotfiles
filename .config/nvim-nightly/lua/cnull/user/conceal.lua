local command = require('cnull.core.command')

local function conceal_toggle()
  local cl = vim.opt.cole:get()
  if cl == 2 then
    vim.opt.conceallevel = 0
  else
    vim.opt.conceallevel = 2
  end
end

command('ToggleConcealLevel', conceal_toggle)
