local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local DEFAULT_OPTS = { silent = true, noremap = true }
local DEFAULT_BORDER_STYLE = 'rounded'
local DEFAULT_BORDER_WIDTH = 80

local function on_attach(_, buf)
  local diag_opts = string.format('{ width = %d, border = %q }', DEFAULT_BORDER_WIDTH, DEFAULT_BORDER_STYLE)

  -- Keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>le', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', DEFAULT_OPTS)
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    '<Leader>lw',
    string.format('<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics(%s)<CR>', diag_opts),
    DEFAULT_OPTS
  )
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
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

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

-- Pyright LSP Server
-- ---
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Vue LSP Server
-- ---
lspconfig.vuels.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- DiagnosticLS Server - for linters and formatters
-- ---
local dls = require('diagnosticls-configs')
dls.init({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- EFM LSP Server - for linters and formatters
-- ---
--[[ local efmls = require('efmls-configs')
efmls.init({
  on_attach = on_attach,
  capabilities = capabilities,
})

efmls.setup({
  lua = {
    linter = require('efmls-configs.linters.luacheck'),
    formatter = require('efmls-configs.formatters.stylua'),
  },
}) ]]
