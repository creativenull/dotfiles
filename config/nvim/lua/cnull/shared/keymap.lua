local err = require('cnull.shared.handlers.err')
local DEFAULT_KEYMAP_OPTS = { silent = true, noremap = true }
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
    rhs = {rhs, 'string'}
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
    rhs = {rhs, 'string'}
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
    opts = vim.tbl_extend('force', DEFAULT_KEYMAP_OPTS, opts)
  else
    opts = DEFAULT_KEYMAP_OPTS
  end

  local ok, errmsg = pcall(validate_keymap, mode, lhs, rhs)
  if not ok then
    err(string.format('Not a valid keymap: %s', errmsg))
    return
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
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
    opts = vim.tbl_extend('force', DEFAULT_KEYMAP_OPTS, opts)
  else
    opts = DEFAULT_KEYMAP_OPTS
  end

  local ok, errmsg = pcall(validate_buf_keymap, bufnr, mode, lhs, rhs)
  if not ok then
    err(string.format('Not a valid keymap: %s', errmsg))
    return
  end

  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

return M
