-- Powered by projectlocal-vim
-- https://github.com/creativenull/projectlocal-vim
local ok, efm = pcall(require, 'efmls-configs')
if ok then
  local luacheck = require('efmls-configs.linters.luacheck')
  local stylua = require('efmls-configs.formatters.stylua')
  efm.setup({
    lua = {
      formatter = stylua,
      linter = luacheck,
    },
  })
end
