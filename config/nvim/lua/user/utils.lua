local M = {}

---Toggle conceal level of local buffer
---which is enabled by some syntax plugin
---@return nil
function M.toggle_conceal_level()
  local win = vim.api.nvim_get_current_win()
  local cl = vim.api.nvim_win_get_option(win, 'conceallevel')

  if cl == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

---Toggle the view of the editor, for taking screenshots
---or for copying code from the editor w/o using "+ register
---when not accessible, eg from a remote ssh or WSL
---@return nil
function M.toggle_codeshot()
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

---Indent rules given to a filetype, use spaces if needed
---@return nil
function M.indent_size(size, use_spaces)
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

---Reload the config and lua scope
---@return nil
function M.reload_config(ns)
  ns = ns or 'user'

  for name, _ in pairs(package.loaded) do
    if name:match('^' .. ns) then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

---Horizontally resize window, if there are more than one window
---@param amount number
---@return nil
function M.resize_win_hor(amount)
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd(string.format('resize %s%d', amount > 0 and '+' or '', amount))
  end
end

---Vertically resize window, if there are more than one window
---@param amount number
---@return nil
function M.resize_win_vert(amount)
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd(string.format('vertical resize %s%d', amount > 0 and '+' or '', amount))
  end
end

return M
