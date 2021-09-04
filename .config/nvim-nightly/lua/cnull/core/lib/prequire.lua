-- Require a module safely
-- @param string modname
return function(modname)
  local success, mod_or_err = pcall(require, modname)
  if not success then
    vim.api.nvim_err_writeln(mod_or_err)
    return
  end

  return mod_or_err
end
