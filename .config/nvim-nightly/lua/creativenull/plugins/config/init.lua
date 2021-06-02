local currentmod = (...)
local M = {}

local function add(modname)
  local modulepath = string.format('%s.%s', currentmod, modname)
  local success, results = pcall(require, modulepath)
  if not success then
    vim.api.nvim_err_writeln(results)
    return
  end

  return results
end

M.init = function()
  add 'emmet'
  add 'indent-blankline'
  add 'nnn'
end

M.setup = function()
  add 'projectcmd'
  add 'lsp'
  add 'lspsaga'
  add 'gitsigns'
  add 'compe'

  add 'telescope'
  add 'galaxyline'

  add 'treesitter'
  add 'biscuits'

  add 'bufferline'
  add 'todocomments'
end

return M
