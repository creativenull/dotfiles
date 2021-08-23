local exec = 'graphql-lsp'
if vim.fn.executable(exec) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', exec))
  return
end

local root_pattern = require('lspconfig').util.root_pattern
require('cnull.core.lsp').setup('graphql', {
  root_dir = root_pattern('package.json', '.graphql.config.*', '.graphqlrc*'),
})
