local on_attach = nil
local capabilities = nil
local M = {}

-- Set default on_attach function
--
-- @param function fn
-- @return void
function M.set_on_attach(fn)
  on_attach = fn
end

-- Initialize nvim-lsp settings
--
-- @return void
function M.init()
  local pub_diagnostics = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = true,
    }
  )
  vim.lsp.handlers["textDocument/publishDiagnostics"] = pub_diagnostics

  capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
end

-- Setup lsp server, given name and nvim-lsp configuration
--
-- @param string lspname
-- @param table lspopts
-- @return void
function M.setup(lspname, lspopts)
  local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  lspopts = vim.tbl_extend('force', default_opts, lspopts or {})

  local success, lspconfig = pcall(require, 'lspconfig')
  if not success then
    vim.api.nvim_err_writeln('lspconfig: not installed')
    return
  end

  lspconfig[lspname].setup(lspopts)
end

return M
