---Toggle the view of the editor, for taking screenshots
---or for copying code from the editor w/o using "+ register
---when not accessible, eg from a remote ssh
---@return nil
local function toggle_codeshot()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].number then
    vim.wo[win].number = false
    vim.wo[win].signcolumn = 'no'
  else
    vim.wo[win].number = true
    vim.wo[win].signcolumn = 'yes'
  end
end

vim.api.nvim_create_user_command('ToggleCodeshot', toggle_codeshot, {})
