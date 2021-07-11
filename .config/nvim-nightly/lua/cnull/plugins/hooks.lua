local uv = vim.loop
local M = {}

local function get_fp(modpath, manager)
  local filepath = vim.split(modpath, '.', true)
  filepath = table.concat(filepath, '/')
  filepath = manager.config_dir .. '/lua/' .. filepath
  return filepath
end

-- Load plugin configurations/setups
-- module path must be within the config directory
-- outputted from stdpath('config')
--
-- @param string modpath
-- @return void
local function require_plugins_from(modpath, manager)
  local filepath = get_fp(modpath, manager)

  local fs, fail = uv.fs_scandir(filepath)
  if fail then
    vim.api.nvim_err_writeln(fail)
    return
  end

  -- Load modules in the modpath, found in the filesystem
  local name, fstype = uv.fs_scandir_next(fs)
  while name ~= nil do
    if fstype == 'file' then
      local filename = vim.split(name, '.', true)[1]
      local pluginmod = string.format('%s.%s', modpath, filename)

      local success, errmsg = pcall(require, pluginmod)
      if not success then
        vim.api.nvim_err_writeln(errmsg)
      end
    end

    name, fstype = uv.fs_scandir_next(fs)
  end
end

function M.on_before_plugins(manager) require_plugins_from('cnull.plugins.before', manager) end
function M.on_after_plugins(manager) require_plugins_from('cnull.plugins.after', manager) end

return M
