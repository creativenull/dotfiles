local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local KEYMAP_OPTS = { silent = true, noremap = true }
local BORDER_STYLE = 'rounded'
local BORDER_WIDTH = 80

local function on_attach(_, buf)
  -- Ominfunc backup
  vim.api.nvim_buf_set_option(buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>la', [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], KEYMAP_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>ld', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], KEYMAP_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lf', [[<Cmd>lua vim.lsp.buf.formatting()<CR>]], KEYMAP_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lh', [[<Cmd>lua vim.lsp.buf.hover()<CR>]], KEYMAP_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>lr', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], KEYMAP_OPTS)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Leader>le', [[<Cmd>lua vim.diagnostic.setloclist()<CR>]], KEYMAP_OPTS)

  local diag_opts = string.format('{ bufnr = %d, width = %d, border = %q }', buf, BORDER_WIDTH, BORDER_STYLE)
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    '<Leader>lw',
    string.format([[<Cmd>lua vim.diagnostic.open_float(%s)<CR>]], diag_opts),
    KEYMAP_OPTS
  )
end

-- Initial LSP Settings
-- --
-- Gloabally change diagnostic behavior
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
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

-- Log debug
-- vim.lsp.set_log_level('debug')

-- projectlocal-vim Config
-- ---
local projectlocal = require('projectlocal.lsp')
projectlocal.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- EFM LSP Server - for linters and formatters
-- ---
local efmls = require('efmls-configs')
efmls.init({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    documentFormatting = true,
  },
})

-- Lua LSP Server
-- --
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')
lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
