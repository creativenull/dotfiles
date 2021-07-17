local storefn = require 'cnull.core.lib.store'
local M = {}

local function validate(cmd, exec)
  local tableorstring = type(exec) == 'function' or type(exec) == 'string'
  vim.validate {
    cmd = { cmd, 'string' },
    exec = { exec, function() return tableorstring end },
  }
end

local function merge_attrs(attrs)
  attrs = attrs or ''
  if vim.tbl_islist(attrs) then
    attrs = table.concat(attrs, ' ')
  end

  return attrs
end

local function get_exec(cmd, exec)
  local execfn = nil
  if type(exec) == 'function' then
    execfn = storefn('commands', cmd, exec)
  end

  exec = execfn or exec
  return exec
end

-- Create a :command! given a `cmd` and `exec` with optional `attrs`
-- check :help E174.
--
-- opts table:
-- {
--   cmd (string) = (required)
--   exec (string|function) = (required)
--   attrs (string|table) = '' (default)
-- }
--
-- @param table opts
-- @return void
function M.command(cmd, exec, attrs)
  validate(cmd, exec)
  attrs = merge_attrs(attrs)
  exec = get_exec(cmd, exec)
  local success, errmsg = pcall(vim.api.nvim_command, string.format('command! %s %s %s', attrs, cmd, exec))
  if not success then
    vim.api.nvim_err_writeln(errmsg)
  end
end

return M.command
