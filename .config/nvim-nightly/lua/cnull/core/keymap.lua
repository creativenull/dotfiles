local storefn = require('cnull.core.lib.storefn')
local DEFAULT_OPTS = { noremap = true, silent = true }
local M = {}

-- Validate args for mapper()
-- @param string input
-- @param string|function exec
-- @return nil
local function validate(input, exec)
  local valid_strfn = type(exec) == 'string' or type(exec) == 'function'
  vim.validate({
    input = {input, 'string'},
    exec = {
      exec,
      function()
        return valid_strfn
      end,
    },
  })
end

-- Merge opts with default keymap options
-- @param table opts
-- @return table
local function merge_opts(opts)
  if opts and type(opts) == 'table' then
    opts = vim.tbl_extend('force', DEFAULT_OPTS, opts)
  else
    opts = DEFAULT_OPTS
  end

  return opts
end

-- Set the right-hand-side as string or function
-- @param string input
-- @param string|function exec
-- @return string
local function set_exec(input, exec)
  local execfn = nil
  if type(exec) == 'function' then
    execfn = string.format('<Cmd>%s<CR>', storefn('keymaps', input, exec))
  end
  exec = execfn or exec
  return exec
end

-- Generic key mapper to map keys globally or in buffer
-- @param string mode
-- @param string input
-- @param string|function exec
-- @param table|nil opts
-- @return nil
local function mapper(mode, input, exec, opts)
  validate(input, exec)
  opts = merge_opts(opts)
  exec = set_exec(input, exec)

  if opts.bufnr then
    local bufnr = opts.bufnr
    opts.bufnr = nil
    local success, errmsg = pcall(vim.api.nvim_buf_set_keymap, bufnr, mode, input, exec, opts)
    if not success then
      vim.api.nvim_err_writeln(errmsg)
    end
  else
    local success, errmsg = pcall(vim.api.nvim_set_keymap, mode, input, exec, opts)
    if not success then
      vim.api.nvim_err_writeln(errmsg)
    end
  end
end

function M.nmap(input, exec, opts)
  mapper('n', input, exec, opts)
end

function M.imap(input, exec, opts)
  mapper('i', input, exec, opts)
end

function M.vmap(input, exec, opts)
  mapper('v', input, exec, opts)
end

function M.tmap(input, exec, opts)
  mapper('t', input, exec, opts)
end

function M.cmap(input, exec, opts)
  mapper('c', input, exec, opts)
end

function M.xmap(input, exec, opts)
  mapper('x', input, exec, opts)
end

function M.omap(input, exec, opts)
  mapper('o', input, exec, opts)
end

function M.smap(input, exec, opts)
  mapper('s', input, exec, opts)
end

return M
