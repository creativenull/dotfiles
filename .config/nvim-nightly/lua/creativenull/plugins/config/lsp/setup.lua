local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'
local on_attach = require 'creativenull.plugins.config.lsp.hooks'.on_attach
local tsserver_opts = require 'creativenull.plugins.config.lsp.tsserver'
local sumneko_opts = require 'creativenull.plugins.config.lsp.sumneko'
local M = {}

-- LSP server wrapper to register based on name
-- and the lsp options
function M.setup_lsp(name, opts)
  if lspconfig[name] == nil then
    local msg = ' "' .. name .. '" does not exist in nvim-lspconfig'
    vim.api.nvim_err_writeln(msg)
    return
  end

  -- Managed by creativenull/diagnosticls-nvim plugin
  if name == 'diagnosticls' then
    return
  end

  local default_opts = {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
  }

  -- Extra LSP options not available in lspconfig
  -- =======
  if name == 'tsserver' then
    default_opts.commands = tsserver_opts.organize_cmd
  elseif name == 'sumneko_lua' then
    default_opts = vim.tbl_extend('force', default_opts, sumneko_opts)
  end

  -- =======
  if opts ~= nil and not vim.tbl_isempty(opts) then
    -- Merge 'opts' w/ 'default_opts'. If keys are the same, then override key from 'opts'
    -- no need to deep copy
    local merged_opts = vim.tbl_extend('force', default_opts, opts)
    lspconfig[name].setup(merged_opts)
  else
    lspconfig[name].setup(default_opts)
  end
end

return M
