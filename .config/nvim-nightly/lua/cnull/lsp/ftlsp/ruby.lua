local fn = vim.fn
local api = vim.api

local exec = 'solargraph'
if fn.executable(exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed', exec))
  return
end

require('cnull.core.lsp').setup('solargraph', {
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
  flags = {
    debounce_text_changes = 500,
  },
})
