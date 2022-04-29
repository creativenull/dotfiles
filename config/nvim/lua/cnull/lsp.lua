local augroup = require('cnull.shared.event').augroup
local keymap = require('cnull.shared.keymap').keymap
local buf_keymap = require('cnull.shared.keymap').buf_keymap
local border = 'rounded'
local width = 80

augroup.set('lsp_user_events', function(autocmd)
  autocmd.set('CursorHold', '*', function()
    vim.diagnostic.open_float(nil, {
      width = width,
      border = border,
    })
  end, { desc = 'Show LSP Line Diagnostic' })
end)

---Statusline component to check if the LSP server connected to the buffer
---@return string
function _G.LspInfoStatusline()
  local bufnr = vim.api.nvim_get_current_buf()
  local results = vim.lsp.buf_get_clients(bufnr)

  if #results > 0 then
    return 'LSP '
  else
    return ''
  end
end

---@param client table
---@param bufnr number
local function on_attach(client, bufnr)
  -- Omnifunc backup
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  buf_keymap.set(bufnr, 'n', '<Leader>la', vim.lsp.buf.code_action, { desc = 'LSP Code Actions' })
  buf_keymap.set(bufnr, 'n', '<Leader>ld', vim.lsp.buf.definition, { desc = 'LSP Go-to Definition' })
  buf_keymap.set(bufnr, 'n', '<Leader>lh', vim.lsp.buf.hover, { desc = 'LSP Hover Information' })
  buf_keymap.set(bufnr, 'n', '<Leader>lr', vim.lsp.buf.rename, { desc = 'LSP Rename' })
  buf_keymap.set(bufnr, 'n', '<Leader>ls', vim.lsp.buf.signature_help, { desc = 'LSP Signature Help' })
  buf_keymap.set(bufnr, 'n', '<Leader>le', vim.diagnostic.setloclist, { desc = 'LSP Show All Diagnostics' })
  buf_keymap.set(bufnr, 'n', '<Leader>lw', function()
    vim.diagnostic.open_float({
      bufnr = bufnr,
      width = width,
      border = border,
    })
  end, { desc = 'Show LSP Line Diagnostic' })

  -- LSP Formatting keymap only from the following
  -- linter/formatter servers
  local utility_servers = { 'diagnosticls', 'efm', 'null-ls' }

  if vim.tbl_contains(utility_servers, client.name) then
    buf_keymap.set(bufnr, 'n', '<Leader>lf', function()
      client.request('textDocument/formatting', vim.lsp.util.make_formatting_params({}), nil, bufnr)
    end, { desc = 'LSP Formatting' })
  end
end

-- Add support to get snippets from lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Gloabally change diagnostic behavior
-- turn them off so that ALE can handle diagnostics
-- exclusively
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = false,
  update_in_insert = false,
})

-- Add border to hover documentation
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    width = width,
    border = border,
  }
)

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = border }
)

-- Check registered LSP info
keymap.set('n', '<Leader>li', '<Cmd>LspInfo<CR>')

-- Log debug
-- vim.lsp.set_log_level('debug')

-- projectlocal-vim Config
-- ---
local projectlocal = require('projectlocal.lsp')
projectlocal.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
