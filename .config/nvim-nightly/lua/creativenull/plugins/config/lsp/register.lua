local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local tsserver_opts = require 'creativenull.plugins.config.lsp.tsserver'
local buf_keymap = require 'creativenull.utils'.buf_keymap
local M = {}

-- LSP Buffer Keymaps
local function register_lsp_keymaps()
  buf_keymap('n', '<F2>', '<cmd>Lspsaga rename<CR>')
  buf_keymap('i', '<C-y>', 'compe#confirm("<CR>")', { expr = true })
  buf_keymap('n', '<leader>la', '<cmd>Lspsaga code_action<CR>')
  buf_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  buf_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  buf_keymap('n', '<leader>lh', '<cmd>Lspsaga hover_doc<CR>')
  buf_keymap('n', '<leader>lw', '<cmd>Lspsaga show_line_diagnostics<CR>')
end

-- LSP on attach event
local function on_attach(client, bufnr)
  lsp_status.on_attach(client)
  register_lsp_keymaps()
  print('Attached to ' .. client.name)
end

-- Register LSP client
local function register_lsp(lsp_name, opts)
  if lsp[lsp_name] == nil then
    local msg = ' "' .. lsp_name .. '" does not exist in nvim-lspconfig'
    vim.api.nvim_err_writeln(msg)
    return
  end

  -- Managed by creativenull/diagnosticls-nvim plugin
  if lsp_name == 'diagnosticls' then
    return
  end

  local default_opts = {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
  }

  if lsp_name == 'tsserver' then
    default_opts.commands = tsserver_opts.organize_cmd
  end

  if opts ~= nil and not vim.tbl_isempty(opts) then
    -- Merge 'opts' w/ 'default_opts'. If keys are the same, then override key from 'opts'
    -- no need to deep copy
    local merged_opts = vim.tbl_extend('force', default_opts, opts)
    lsp[lsp_name].setup(merged_opts)
  else
    lsp[lsp_name].setup(default_opts)
  end
end

M.on_attach = on_attach
M.register_lsp = register_lsp

return M
