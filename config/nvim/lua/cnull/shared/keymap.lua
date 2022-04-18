local err = require('cnull.shared.handlers.err')
local default_options = { silent = true, noremap = true }
local M = {
  keymap = {},
  buf_keymap = {},
}

---Validate keymap args
---@param mode string
---@param lhs string
---@param rhs string
local function validate_keymap(mode, lhs, rhs)
  vim.validate({
    mode = {mode, 'string'},
    lhs = {lhs, 'string'},
    rhs = {rhs, {'string', 'function'}}
  })
end

---Validate buf keymap args
---@param bufnr number
---@param mode string
---@param lhs string
---@param rhs string
local function validate_buf_keymap(bufnr, mode, lhs, rhs)
  vim.validate({
    bufnr = {bufnr, 'number'},
    mode = {mode, 'string'},
    lhs = {lhs, 'string'},
    rhs = {rhs, {'string', 'function'}}
  })
end

---Set a global keymap, for example:
---
---    keymap.set('n', '<leader>ai', '<Cmd>ALEInfo<CR>')
---
---@param mode string
---@param lhs string
---@param rhs string
---@param opts table
M.keymap.set = function(mode, lhs, rhs, opts)
  if opts ~= nil then
    opts = vim.tbl_extend('force', default_options, opts)
  else
    opts = default_options
  end

  local ok, errmsg = pcall(validate_keymap, mode, lhs, rhs)
  if not ok then
    err(string.format('Not a valid keymap: %s', errmsg))
    return
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

---Set a buffer-local keymap, for example:
---
---    buf_keymap.set(0, 'n', '<leader>c', '<Cmd>echom "here"<CR>')
---
---@param bufnr number
---@param mode string
---@param lhs string
---@param rhs string
---@param opts table
M.buf_keymap.set = function(bufnr, mode, lhs, rhs, opts)
  if opts ~= nil then
    opts = vim.tbl_extend('force', default_options, opts)
    opts = vim.tbl_extend('force', opts, { buffer = bufnr })
  else
    opts = default_options
  end

  local ok, errmsg = pcall(validate_buf_keymap, bufnr, mode, lhs, rhs)
  if not ok then
    err(string.format('Not a valid keymap: %s', errmsg))
    return
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
