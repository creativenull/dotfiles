local keymap = require('cnull.shared.keymap').keymap
local buf_keymap = require('cnull.shared.keymap').buf_keymap
local BORDER_STYLE = 'rounded'
local BORDER_WIDTH = 80

local function on_attach(_, bufnr)
  local diag_opts = string.format('{ width = %d, border = %q }', BORDER_WIDTH, BORDER_STYLE)

  -- Omnifunc backup
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  buf_keymap.set(bufnr, 'n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_keymap.set(bufnr, 'n', '<Leader>le', '<Cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_keymap.set(
    bufnr,
    'n',
    '<Leader>lw',
    string.format('<Cmd>lua vim.diagnostic.open_float(%d, %s)<CR>', bufnr, diag_opts)
  )
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
  width = BORDER_WIDTH,
  border = BORDER_STYLE,
})

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = BORDER_STYLE,
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
