-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local pl = require('projectlocal.lsp')
local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern

local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup(pl.get_server_config({
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

lspconfig.vimls.setup(pl.get_server_config())
