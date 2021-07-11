local lsp_executable = 'gopls'
if vim.fn.executable(lsp_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', lsp_executable))
  return
end

require 'cnull.core.lsp'.setup(lsp_executable, {
  flags = {
    debounce_text_changes = 500,
  },
})
