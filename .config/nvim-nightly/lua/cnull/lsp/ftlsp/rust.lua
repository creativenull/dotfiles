local lsp_executable = 'rust-analyzer'
if vim.fn.executable(lsp_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', lsp_executable))
  return
end

require 'cnull.core.lsp'.setup('rust_analyzer', {
  flags = {
    debounce_text_changes = 500,
  },
})
