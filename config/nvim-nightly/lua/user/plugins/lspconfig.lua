local BORDER_STYLE = 'rounded'
local BORDER_WIDTH = 80

local function on_attach(_, bufnr)
  -- Set omnifunc in case there are not auto completion
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP keymaps to be used only when LS server is attached
  vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP Code Action' })
  vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = bufnr, desc = 'LSP Go-to Definition' })
  vim.keymap.set('n', '<Leader>lf', vim.lsp.buf.formatting, { buffer = bufnr, desc = 'LSP Formatting' })
  vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP Hover Information' })
  vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP Rename Feature' })
  vim.keymap.set(
    'n',
    '<Leader>le',
    vim.diagnostic.setloclist,
    { buffer = bufnr, desc = 'Diagnostics in Location List' }
  )

  -- Show diagnostic float window, customized
  local function show_diagnostics()
    vim.diagnostic.open_float({
      bufnr = bufnr,
      width = BORDER_WIDTH,
      border = BORDER_STYLE,
    })
  end

  vim.keymap.set('n', '<Leader>lw', show_diagnostics, { buffer = bufnr, desc = 'Show Diagnostic in Float Window' })
end

-- Initial LSP Settings
-- --
-- Global settings for diagnostic behaviour
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

-- Add border to hover documentation
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = BORDER_WIDTH,
  border = BORDER_STYLE,
})

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
  border = BORDER_STYLE,
})

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

-- nvim-cmp LSP setup
-- ---
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- Log debug
-- vim.lsp.set_log_level('debug')

-- projectlocal-vim Config
-- ---
local projectlocal = require('projectlocal.lsp')
projectlocal.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
