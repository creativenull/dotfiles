local mod = (...):gsub('%.init$', '')
local M = {}

-- @param table lspname
-- @return void
function M.setup(filetypes)
  if not filetypes or vim.tbl_isempty(filetypes) then
    return
  end

  for _,ft in pairs(filetypes) do
    local ftmod = string.format('%s.ftlsp.%s', mod, ft)
    pcall(require , ftmod)
  end
end

return M
