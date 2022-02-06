local keymap = require('cnull.shared.keymap').keymap
local buf_keymap = require('cnull.shared.keymap').buf_keymap
local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local BORDER_STYLE = 'rounded'
local BORDER_WIDTH = 80

local function on_attach(_, buf)
  local diag_opts = string.format('{ width = %d, border = %q }', BORDER_WIDTH, BORDER_STYLE)

  -- Omnifunc backup
  vim.api.nvim_buf_set_option(buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  buf_keymap.set(buf, 'n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_keymap.set(buf, 'n', '<Leader>le', '<Cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_keymap.set(
    buf,
    'n',
    '<Leader>lw',
    string.format('<Cmd>lua vim.diagnostic.open_float(%d, %s)<CR>', buf, diag_opts)
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

local function register_lsp(server, opts)
  local user_config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if opts == nil then
    opts = user_config
  else
    opts = vim.tbl_extend('force', user_config, opts)
  end

  lspconfig[server].setup(opts)
end

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

-- Lua Language Server
-- --
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')
register_lsp('sumneko_lua', {
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

-- Vim Language Server
-- ---
register_lsp('vimls')
