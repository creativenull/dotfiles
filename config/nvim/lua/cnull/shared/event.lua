local err = require('cnull.shared.handlers.err')
local M = {
  augroup = {},
  autocmd = {},
}

---@param event string|table
---@param pattern string|table
---@param command string|function
---@param opts table
---@return nil
local validate_autocmd = function(event, pattern, command, opts)
  vim.validate({
    event = {event, {'string', 'table'}},
    pattern = {pattern, {'string', 'table'}},
    command = {command, {'string', 'function'}},
    opts = {opts, {'table'}},
  })
end

---Create an auto command, for example:
---
---    autocmd.set('FileType', 'setlocal expandtab', { pattern = 'python' })
---    autocmd.set('BufEnter', 'setlocal colorcolumns', { pattern = '*.js' })
---
---@param event string|table
---@param pattern string|table
---@param command string|function
---@param opts table
---@return nil
M.autocmd.set = function(event, pattern, command, opts)
  opts = opts or { once = false, nested = false }

  local ok, errmsg = pcall(validate_autocmd, event, pattern, command, opts)
  if not ok then
    err(string.format('Not a valid autocmd: %s', errmsg))
    return
  end

  local callback = nil
  if type(command) == 'function' then
    callback = command
    command = nil
  end

  local autocmd_opts = vim.tbl_extend('force', opts, {
    command = command,
    pattern = pattern,
    callback = callback,
  })

  vim.api.nvim_create_autocmd(event, autocmd_opts)
end

---@param name string
---@param autocmd_tbl table
---@return nil
local validate_augroup = function(name, autocmd_tbl)
  vim.validate({
    name = {name, 'string'},
    autocmd_tbl = {autocmd_tbl, {'table'}},
  })
end

---Create an auto group command that takes autocmd table, for example:
---
---    augroup.set('custom_events', {
---        { 'ColorScheme', '*', 'highlight! Normal guibg=NONE' },
---        { 'FileType', 'javascript', 'setlocal colorcolumn=120' },
---    })
---
---@param name string
---@param autocmd_tbl table
---@return nil
M.augroup.set = function(name, autocmd_tbl)
  local ok, errmsg = pcall(validate_augroup, name, autocmd_tbl)
  if not ok then
    err(string.format('Not a valid augroup: %s', errmsg))
    return
  end

  local group = vim.api.nvim_create_augroup(name, { clear = true })

  for _, autocmd in pairs(autocmd_tbl) do
    local event = autocmd[1]
    local pattern = autocmd[2]
    local command = autocmd[3]
    local opts = vim.tbl_extend('force', autocmd[4] or {}, { group = group })

    M.autocmd.set(event, pattern, command, opts)
  end
end

return M
