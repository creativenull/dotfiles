---Print error to nvim
---@param msg string
---@return nil
return function(msg)
  vim.api.nvim_err_writeln(msg)
end
