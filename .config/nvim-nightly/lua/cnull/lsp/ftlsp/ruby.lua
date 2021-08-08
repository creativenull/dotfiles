local lsp_executable = 'solargraph'
if vim.fn.executable(lsp_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', lsp_executable))
  return
end

require('cnull.core.lsp').setup('solargraph', {
  settings = {
    solargraph = {
      diagnostics = true
    }
  },
  flags = {
    debounce_text_changes = 500,
  },
})
