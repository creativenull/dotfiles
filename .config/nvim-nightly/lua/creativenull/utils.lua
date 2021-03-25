local M = {}

-- Set global or buffer key map
local function key_mapper(mode, lhs, rhs, opts, is_buf)
  local has_opts = opts ~= nil and not vim.tbl_isempty(opts)
  local default_opts = {
    noremap = true,
    silent = true,
  }

  if is_buf ~= nil and is_buf == true then
    if has_opts then
      vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, vim.tbl_extend('force', default_opts, opts))
    else
      vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, default_opts)
    end
  else
    if has_opts then
      vim.api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend('force', default_opts, opts))
    else
      vim.api.nvim_set_keymap(mode, lhs, rhs, default_opts)
    end
  end
end

function M.keymap(mode, lhs, rhs, opts)
  key_mapper(mode, lhs, rhs, opts, false)
end

function M.buf_keymap(mode, lhs, rhs, opts)
  key_mapper(mode, lhs, rhs, opts, true)
end

-- Reload the all modules that reside
-- in config lua/ dir
function M.reload_config()
  for k, v in pairs(package.loaded) do
    if string.match(k, "^creativenull") then
      package.loaded[k] = nil
    end
  end

  dofile(os.getenv('MYVIMRC'))
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
