vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

-- Global lsp register function
_G.RegisterLsp = require 'creativenull.plugins.config.lsp.register'.register_lsp

require 'diagnosticls-nvim'.init {
  on_attach = require 'creativenull.plugins.config.lsp.register'.on_attach
}

-- For debug
-- vim.lsp.set_log_level('debug')
