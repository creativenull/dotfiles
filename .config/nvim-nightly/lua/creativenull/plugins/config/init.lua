local modconfig = (...)
local M = {}

local function add(modname)
  local modulepath = string.format('%s.%s', modconfig, modname)
  require(modulepath)
end

M.init = function()
  add 'emmet'
end

M.setup = function()
  add 'gitsigns'
  add 'lsp'
  add 'projectcmd'
  add 'compe'
  add 'telescope'
  add 'autopairs'
  add 'lspsaga'
  add 'galaxyline'

  -- treesitter and co
  add 'treesitter'
  add 'biscuits'
end

return M
