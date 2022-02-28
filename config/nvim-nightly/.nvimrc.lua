-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local pl = require('projectlocal.lsp')

local lspok, lspconfig = pcall(require, 'lspconfig')
if lspok then
  -- Lua LSP Server
  -- ---
  local lua_rtp = vim.split(package.path, ';')
  table.insert(lua_rtp, 'lua/?.lua')
  table.insert(lua_rtp, 'lua/?/init.lua')
  local luals_config = vim.tbl_extend('force', pl.get_config(), {
    root_dir = lspconfig.util.root_pattern('.git'),
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
  lspconfig.sumneko_lua.setup(luals_config)
end

local ok, efm = pcall(require, 'efmls-configs')
if ok then
  -- EFM LSP Server - for linters and formatters
  -- ---
  local efmls = require('efmls-configs')
  efmls.init({
    init_options = {
      documentFormatting = true,
    },
  })

  local luacheck = require('efmls-configs.linters.luacheck')
  local stylua = require('efmls-configs.formatters.stylua')
  efm.setup({
    lua = {
      formatter = stylua,
      linter = luacheck,
    },
  })
end
