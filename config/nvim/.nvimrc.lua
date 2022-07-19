-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local projectlocal = require('projectlocal.lsp')
local lspconfig = require('lspconfig')
local root_pattern = require('lspconfig').util.root_pattern

-- ALE Config
vim.api.nvim_create_augroup('ALEUserEvents', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.b[buf].ale_linters = { 'luacheck' }
    vim.b[buf].ale_fixers = { 'stylua' }
  end
})

-- Lua LSP
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')
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
