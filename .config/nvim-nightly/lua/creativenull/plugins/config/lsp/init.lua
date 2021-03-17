local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local utils = require 'creativenull.utils'
local current_path = (...):gsub('%.init$', '')
local M = {}

-- LSP Buffer Keymaps
local function register_buf_keymaps()
  utils.buf_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
  utils.buf_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  utils.buf_keymap('n', '<leader>lw', '<cmd>Lspsaga show_line_diagnostics<CR>')
  utils.buf_keymap('n', '<leader>lh', '<cmd>Lspsaga hover_doc<CR>')
  utils.buf_keymap('n', '<leader>la', '<cmd>Lspsaga code_action<CR>')
  utils.buf_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  utils.buf_keymap('n', '<F2>',       '<cmd>Lspsaga rename<CR>')
  utils.buf_keymap('i', '<C-y>',      'compe#confirm("<CR>")', { expr = true })
end

-- LSP on attach event
local function on_attach(client, bufnr)
  lsp_status.on_attach(client)
  register_buf_keymaps()
  print('Attached to ' .. client.name)
end

-- TSServer LSP organize imports
-- https://www.reddit.com/r/neovim/comments/lwz8l7/how_to_use_tsservers_organize_imports_with_nvim/gpkueno?utm_source=share&utm_medium=web2x&context=3
local function ts_organize_imports()
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) }
  })
end

-- Register LSP client
local function register_lsp(lsp_name, opts)
  local default_opts = {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
  }

  if lsp[lsp_name] == nil then
    vim.api.nvim_err_writeln(' "' .. lsp_name .. '" does not exist in nvim-lspconfig')
    return
  end

  if lsp_name == 'tsserver' then
    default_opts.commands = {
      TsserverOrganizeImports = {
        ts_organize_imports,
        description = 'Organize imports'
      }
    }
  end

  if lsp_name == 'diagnosticls' then
    return
  end

  if opts ~= nil and not vim.tbl_isempty(opts) then
    -- Merge 'opts' w/ 'default_opts'. If keys are the same, then override key from 'opts'
    lsp[lsp_name].setup(vim.tbl_extend('force', default_opts, opts))
  else
    lsp[lsp_name].setup(default_opts)
  end
end

-- Before loading plugin
M.setup = function()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  })
end

-- After loading plugin
M.config = function()
  _G.RegisterLsp = register_lsp

  require 'diagnosticls-nvim'.init {
    on_attach = on_attach,
    root_dir = require 'lspconfig'.util.root_pattern('.git')
  }

  -- vim.lsp.set_log_level("debug")
end

return M
