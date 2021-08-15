local fn = vim.fn
local api = vim.api

local exec = 'rust-analyzer'
if fn.executable(exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed', exec))
  return
end

require('cnull.core.lsp').setup('rust_analyzer', {
  flags = {
    debounce_text_changes = 500,
  },
})
