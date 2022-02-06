-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local projectlocal = require('projectlocal.lsp')
local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern

local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')

-- Lua LSP
lspconfig.sumneko_lua.setup(projectlocal.get_config({
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
}))

-- Vim LSP
lspconfig.vimls.setup(projectlocal.get_config())
