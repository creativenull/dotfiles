local executable = vim.fn.executable
local nvim_err_writeln = vim.fn.nvim_err_writeln

local gopls_exec = 'gopls'
if executable(gopls_exec) == 0 then
  nvim_err_writeln(string.format('lsp: %q is not installed', gopls_exec))
  return
end

require('cnull.core.lsp').setup(gopls_exec, { flags = { debounce_text_changes = 500 } })
