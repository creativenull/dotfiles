local storefn = require 'cnull.core.lib.store'
local M = {}

-- Create an :autocmd event, see :help :autocmd for information
-- opts = {
--   event (string|table) = (required)
--   exec (string|function) = (required)
--   pattren (string) = '*'
--   once (boolean) = false
--   nested (boolean) = false
--   clear (boolean) = false (if true then use :autocmd! instead)
-- }
--
-- @param table opts
-- @return nil
function M.autocmd(opts)
  if opts.event == nil then
    error(debug.traceback('autocmd: `event` cannot be empty'))
  end

  -- If event is table list, then join
  if vim.tbl_islist(opts.event) and vim.tbl_count(opts.event) > 1 then
    opts.event = table.concat(opts.event, ',')
  end

  -- If pattern is table list, then join
  if vim.tbl_islist(opts.pattern) and vim.tbl_count(opts.pattern) > 1 then
    opts.pattern = table.concat(opts.pattern, ',')
  end

  local execfn = nil
  if type(opts.exec) == 'function' then
    execfn = storefn('events', opts.event, opts.exec)
  end

  local au = string.format(
    'autocmd%s %s %s %s %s %s',
    opts.clear and '!' or '',
    opts.event,
    opts.pattern or '*',
    opts.once and '++once' or '',
    opts.nested and '++nested' or '',
    execfn or opts.exec
  )

  local success, errmsg = pcall(vim.api.nvim_command, au)
  if not success then
    vim.api.nvim_err_writeln(errmsg)
  end
end

-- Create an :augroup, see :help :augroup for information
-- @param string name
-- @param table autocmds - check M.autocmd() above
-- @return nil
function M.augroup(name, autocmds)
  if autocmds == nil or vim.tbl_isempty(autocmds) then
    error(debug.traceback('augroup: `autocmds` cannot be empty'))
  end

  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _,exec in pairs(autocmds) do
    M.autocmd(exec)
  end
  vim.cmd('augroup end')
end

return M
