local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern
local keymapopts = { silent = true, noremap = true }

local function on_attach(_, bufnr)
  local diag_opts = '{ width = 80, focusable = false, border = "single" }'

  -- Keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>le', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', keymapopts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lw', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics('.. diag_opts ..')<CR>', keymapopts)
end

-- Initial LSP Settings
-- --
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = 80,
  border = 'single',
  focusable = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

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
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = lua_rtp,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'coq'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Vim LSP Server
-- ---
lspconfig.vimls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = root_pattern('.vimls'),
})
