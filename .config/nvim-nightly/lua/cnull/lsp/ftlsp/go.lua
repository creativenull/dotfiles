local gopls_exec = 'gopls'
if vim.fn.executable(gopls_exec) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', gopls_exec))
  return
end

require('cnull.core.lsp').setup(gopls_exec, {
  flags = {
    debounce_text_changes = 500,
  },
})
