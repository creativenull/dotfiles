local M = {}
local DEFAULT_OPTS = { noremap = true, silent = true }

-- Global key map
-- @param mode
M.keymap = function(mode, lhs, rhs, opts)
  local has_opts = opts ~= nil and not vim.tbl_isempty(opts)
  if has_opts then
    vim.api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend('force', DEFAULT_OPTS, opts))
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, DEFAULT_OPTS)
  end
end

-- Buffer key map
M.buf_keymap = function(bufnr, mode, lhs, rhs, opts)
  local has_opts = opts ~= nil and not vim.tbl_isempty(opts)
  if has_opts then
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, vim.tbl_extend('force', DEFAULT_OPTS, opts))
  else
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, DEFAULT_OPTS)
  end
end

-- Reload the all modules that reside
-- in config lua/ dir
function M.reload_config()
  for k, v in pairs(package.loaded) do
    if string.match(k, "^creativenull") then
      package.loaded[k] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

-- Toggle Conceal for markdown, json, etc
function M.toggle_conceal()
  if vim.wo.conceallevel == 2 then
    vim.wo.conceallevel = 0
  else
    vim.wo.conceallevel = 2
  end
end

-- Dumb way to set an autocmd group
function M.set_augroup(group, autocmds)
  local cmd = vim.api.nvim_command
  cmd('augroup ' .. group)
  cmd('au!')
  for _, autocmd in pairs(autocmds) do cmd(autocmd) end
  cmd('augroup end')
end

return M
