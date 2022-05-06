---Toggle conceal level of local buffer
---which is enabled by some syntax plugin
---@return nil
local function toggle_conceal()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].conceallevel == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

vim.api.nvim_create_user_command('ToggleConcealLevel', toggle_conceal, {})
