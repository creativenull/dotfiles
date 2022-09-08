local M = {}

-- Toggle conceal level of local buffer
-- which is enabled by some syntax plugin
function M.ToggleConcealLevel()
  local win = vim.api.nvim_get_current_win()
  local cl = vim.api.nvim_win_get_option(win, 'conceallevel')

  if cl == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

-- Toggle the view of the editor, for taking screenshots
-- or for copying code from the editor w/o using "+ register
-- when not accessible, eg from a remote ssh or WSL
function M.ToggleCodeshot()
  local win = vim.api.nvim_get_current_win()
  local num = vim.api.nvim_win_get_option(win, 'number')

  if num then
    vim.opt.number = false
    vim.opt.signcolumn = 'no'
    vim.cmd('IndentLinesDisable')
  else
    vim.opt.number = true
    vim.opt.signcolumn = 'yes'
    vim.cmd('IndentLinesEnable')
  end
end

-- Indent rules given to a filetype, use spaces if needed
function M.IndentSize(size, use_spaces)
  local buf = vim.api.nvim_get_current_buf()

  vim.bo[buf].tabstop = size
  vim.bo[buf].softtabstop = size
  vim.bo[buf].shiftwidth = 0

  if use_spaces ~= nil then
    vim.bo[buf].expandtab = true
  else
    vim.bo[buf].expandtab = false
  end
end

return M
