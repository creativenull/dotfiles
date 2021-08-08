local executable = vim.fn.executable
local nvim_err_writeln = vim.fn.nvim_err_writeln

local phpls_exec = 'intelephense'
if executable(phpls_exec) == 0 then
  nvim_err_writeln(string.format('lsp: %q is not installed', phpls_exec))
  return
end

require('cnull.core.lsp').setup(phpls_exec)
