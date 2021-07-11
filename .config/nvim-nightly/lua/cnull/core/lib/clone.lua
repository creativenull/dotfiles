-- https://leafo.net/guides/function-cloning-in-lua.html
local M = {}

function M.clone_fn(fn)
  local dumped = string.dump(fn)
  local cloned = loadstring(dumped)
  local i = 1
  while true do
    local name = debug.getupvalue(fn, i)
    if not name then
      break
    end
    debug.upvaluejoin(cloned, i, fn, i)
    i = i + 1
  end
  return cloned
end

setmetatable(M, {
  __call = function(_, fn)
    return M.clone_fn(fn)
  end,
})

return M
