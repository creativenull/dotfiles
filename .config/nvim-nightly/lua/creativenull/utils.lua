local M = {}

local function map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs)
end

local function noremap(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

local function buf_noremap(mode, lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true, silent = true })
end

function M.nmap(lhs, rhs) map('n', lhs, rhs) end
function M.imap(lhs, rhs) map('i', lhs, rhs) end
function M.vmap(lhs, rhs) map('v', lhs, rhs) end
function M.tmap(lhs, rhs) map('t', lhs, rhs) end

function M.nnoremap(lhs, rhs) noremap('n', lhs, rhs) end
function M.inoremap(lhs, rhs) noremap('i', lhs, rhs) end
function M.vnoremap(lhs, rhs) noremap('v', lhs, rhs) end
function M.tnoremap(lhs, rhs) noremap('t', lhs, rhs) end

function M.buf_nnoremap(lhs, rhs) buf_noremap('n', lhs, rhs) end
function M.buf_inoremap(lhs, rhs) buf_noremap('i', lhs, rhs) end
function M.buf_vnoremap(lhs, rhs) buf_noremap('v', lhs, rhs) end
function M.buf_tnoremap(lhs, rhs) buf_noremap('t', lhs, rhs) end

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

return M
