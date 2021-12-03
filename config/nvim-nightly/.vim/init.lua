-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local ok, dls = pcall(require, 'diagnosticls-configs')
if ok then
  local luacheck = require('diagnosticls-configs.linters.luacheck')
  local stylua = require('diagnosticls-configs.formatters.stylua')
  dls.setup({
    lua = {
      formatter = stylua,
      linter = luacheck,
    },
  })
end
