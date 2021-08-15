local fn = vim.fn
local api = vim.api

local exec = 'vscode-json-language-server'
if fn.executable(exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed', exec))
  return
end

require('cnull.core.lsp').setup('jsonls', {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { fn.line('$'), 0 })
      end,
    },
  },
})
