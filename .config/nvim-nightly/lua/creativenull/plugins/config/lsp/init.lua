local modlsp = (...)
local on_attach = require(modlsp .. '.hooks').on_attach
local setup_lsp = require(modlsp .. '.setup').setup_lsp

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

-- Global lsp setup function, to be used with projectcmd.nvim
_G.SetupLsp = setup_lsp

-- Init of diagnosticls-nvim plugin
require 'diagnosticls-nvim'.init { on_attach = on_attach }

-- For debugging
-- vim.lsp.set_log_level('debug')
