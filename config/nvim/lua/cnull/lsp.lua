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
  end)
end)

---@param client table
---@param bufnr number
local function on_attach(client, bufnr)
  -- Omnifunc backup
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  buf_keymap.set(bufnr, 'n', '<Leader>la', vim.lsp.buf.code_action)
  buf_keymap.set(bufnr, 'n', '<Leader>ld', vim.lsp.buf.definition)
  buf_keymap.set(bufnr, 'n', '<Leader>lf', vim.lsp.buf.formatting)
  buf_keymap.set(bufnr, 'n', '<Leader>lh', vim.lsp.buf.hover)
  buf_keymap.set(bufnr, 'n', '<Leader>lr', vim.lsp.buf.rename)
  buf_keymap.set(bufnr, 'n', '<Leader>ls', vim.lsp.buf.signature_help)
  buf_keymap.set(bufnr, 'n', '<Leader>le', vim.diagnostic.setloclist)
  buf_keymap.set(bufnr, 'n', '<Leader>lw', function()
    vim.diagnostic.open_float({
      bufnr = bufnr,
      width = width,
      border = border,
    })
  end)
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
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = false,
  update_in_insert = false,
})

-- Add border to hover documentation
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = width,
  border = border,
})

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

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
