vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

_G.RegisterLsp = require 'creativenull.plugins.config.lsp.register'.register_lsp

require 'diagnosticls-nvim'.init {
  on_attach = on_attach,
  root_dir = require 'lspconfig'.util.root_pattern('.git')
}

-- For debug
-- vim.lsp.set_log_level('debug')
