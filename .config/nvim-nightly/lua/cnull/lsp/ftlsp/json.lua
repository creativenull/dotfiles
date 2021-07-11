local lsp_executable = 'vscode-json-language-server'
if vim.fn.executable(lsp_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', lsp_executable))
  return
end

require 'cnull.core.lsp'.setup('jsonls', {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
      end,
    },
  },
})
