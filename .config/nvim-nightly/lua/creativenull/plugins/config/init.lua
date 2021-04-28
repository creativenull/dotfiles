local modconfig = (...)
local M = {}

function M.init()
  require(modconfig .. '.emmet')
end

function M.setup()
  require(modconfig .. '.gitsigns')
  require(modconfig .. '.lsp')
  require(modconfig .. '.projectcmd')
  require(modconfig .. '.compe')
  require(modconfig .. '.telescope')
  require(modconfig .. '.autopairs')
  require(modconfig .. '.lspsaga')
  require(modconfig .. '.neoscroll')

  -- treesitter and co
  require(modconfig .. '.treesitter')
  require(modconfig .. '.biscuits')
end

return M
