local fn = vim.fn
local api = vim.api

local exec = 'intelephense'
if fn.executable(exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed', exec))
  return
end

require('cnull.core.lsp').setup(exec)
