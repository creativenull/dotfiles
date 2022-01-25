local keymap = require('cnull.shared.keymap').keymap
local buf_keymap = require('cnull.shared.keymap').buf_keymap
local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local DEFAULT_BORDER_STYLE = 'rounded'
local DEFAULT_BORDER_WIDTH = 80

local function on_attach(_, buf)
  local diag_opts = string.format('{ width = %d, border = %q }', DEFAULT_BORDER_WIDTH, DEFAULT_BORDER_STYLE)

  vim.api.nvim_buf_set_option(buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  buf_keymap.set(buf, 'n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>le', '<Cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lw', string.format('<Cmd>lua vim.diagnostic.open_float(%s)<CR>', diag_opts))
end

-- Generic LSP check
keymap.set('n', '<Leader>li', '<Cmd>LspInfo<CR>')

-- ALE integration
require('nvim-ale-diagnostic')

-- Initial LSP Settings
-- --
-- Gloabally change diagnostic behavior
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

-- Add border to hover documentation
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = DEFAULT_BORDER_WIDTH,
  border = DEFAULT_BORDER_STYLE,
})

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
  border = DEFAULT_BORDER_WIDTH,
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

local projectlocal = require('projectlocal.lsp')
projectlocal.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Log debug
-- vim.lsp.set_log_level('debug')

-- Lua LSP Server
-- --
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 'luals' },
  root_dir = root_pattern('.git'),
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = lua_rtp,
      },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false },
    },
  },
})

-- PHP LSP Server
-- ---
-- lspconfig.intelephense.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

-- Nodejs LSP Server
-- ---
-- lspconfig.tsserver.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = root_pattern('package.json'),
-- })

-- Deno LSP Server
-- ---
-- lspconfig.denols.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = root_pattern('deno.json', 'deno.jsonc'),
-- })

-- Pyright LSP Server
-- ---
-- lspconfig.pyright.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

-- Vue LSP Server
-- ---
-- lspconfig.vuels.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

-- DiagnosticLS Server - for linters and formatters
-- ---
-- local dls = require('diagnosticls-configs')
-- dls.init({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   default_config = true,
-- })
-- dls.setup()

-- EFM LSP Server - for linters and formatters
-- ---
-- local efmls = require('efmls-configs')
-- efmls.init({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   init_options = {
--     documentFormatting = true,
--   },
-- })
