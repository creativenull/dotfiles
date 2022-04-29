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
    event = { event, { 'string', 'table' } },
    pattern = { pattern, { 'string', 'table' } },
    command = { command, { 'string', 'function' } },
    opts = { opts, { 'table' } },
  })
end

---Create an autocmd, take the same pattern as :autocmd except for the extra args
---which are moved into the 4th arg in this function. Example:
---
---    autocmd.set('FileType', 'python', 'setlocal expandtab')
---    autocmd.set('BufEnter', '*', 'setlocal colorcolumn=100', { buffer = 0 })
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
---@param cb function
---@return nil
local validate_augroup = function(name, cb)
  vim.validate({
    name = { name, 'string' },
    cb = { cb, { 'function' } },
  })
end

---Create an auto group command that executes a function that calls autocmd.set()
---
---    augroup.set('custom_events', function(autocmd)
---        autocmd.set('ColorScheme', '*', 'highlight! Normal guibg=NONE')
---        autocmd.set('Filetype', 'javascript', function()
---            vim.opt.colorcolumn = '120'
---        end)
---    end)
---
---@param name string
---@param cb function
---@return nil
M.augroup.set = function(name, cb)
  local ok, errmsg = pcall(validate_augroup, name, cb)

  if not ok then
    err(string.format('Not a valid augroup: %s', errmsg))

    return
  end

  local group = vim.api.nvim_create_augroup(name, { clear = true })

  cb({
    ---@param event string|table
    ---@param pattern string|table
    ---@param command string|function
    ---@param autocmd_opts table
    set = function(event, pattern, command, autocmd_opts)
      M.autocmd.set(event, pattern, command, vim.tbl_extend('force', autocmd_opts or {}, { group = group }))
    end
  })
end

return M
