local clone_fn = require 'cnull.core.lib.clone'
local M = {}

-- Store the function to the relevant global store and return the lua string to execute it
-- @param string key
-- @param string source
-- @param function fnreef
-- @return string
function M.storefn(key, source, fnref)
  table.insert(_G.CNull[key], { source = source, callback = clone_fn(fnref) })
  local pos = vim.tbl_count(_G.CNull[key])
  return string.format([[lua _G.CNull[%q][%d].callback()]], key, pos)
end

return M.storefn
