local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local DEFAULT_KEYMAP_OPTS = { silent = true, noremap = true }

local function buf_mapper(...)
  vim.api.nvim_buf_set_keymap(...)
end

local function nmap(bufnr, lhs, rhs, opts)
  opts = opts and vim.tbl_extend('force', DEFAULT_KEYMAP_OPTS, opts) or DEFAULT_KEYMAP_OPTS
  buf_mapper(bufnr, 'n', lhs, rhs, opts)
end

local function on_attach(_, buf)
  local diag_opts = '{ width = 80, focusable = false, border = "single" }'

  -- Keymaps
  nmap(buf, '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  nmap(buf, '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  nmap(buf, '<Leader>le', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  nmap(buf, '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  nmap(buf, '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  nmap(buf, '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  nmap(buf, '<Leader>lw', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics('.. diag_opts ..')<CR>')
end

-- Initial LSP Settings
-- --
-- Show diagnostics only as underline
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

-- Add border to hover documentation
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = 80,
  border = 'single',
})

-- Add border to signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = 'single' })

-- Let lsputil handle code actions
local success, codeAction = pcall(require, 'lsputil.codeAction')
if success then
  vim.lsp.handlers['textDocument/codeAction'] = codeAction.code_action_handler
end

-- Add support to get snippets from lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Log debug
-- vim.lsp.set_log_level('debug')

vim.api.nvim_set_keymap('n', '<Leader>li', '<Cmd>LspInfo<CR>', { noremap = true, silent = true })

-- Lua LSP Server
-- --
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {'luals'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = lua_rtp,
      },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false },
    },
  },
  root_dir = root_pattern('.git'),
})

-- Vim LSP Server
-- ---
lspconfig.vimls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = root_pattern('.git'),
})

-- PHP LSP Server
-- ---
lspconfig.intelephense.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Nodejs LSP Server
-- ---
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = root_pattern('package.json'),
})

-- Deno LSP Server
-- ---
lspconfig.denols.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = root_pattern('deno.json', 'deno.jsonc'),
})

-- DiagnosticLS Server
-- ---
local dlsconfig = require('diagnosticls-configs')
dlsconfig.init({
  on_attach = on_attach,
  capabilities = capabilities,
})
