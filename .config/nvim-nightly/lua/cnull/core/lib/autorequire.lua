local uv = vim.loop
local M = {}

local function get_filepath(modpath, runtimepath)
  local partialpath = vim.split(modpath, '.', true)
  partialpath = table.concat(partialpath, '/')
  local filepath = runtimepath .. '/' .. partialpath
  return filepath
end

function M.autorequire(modpath, opts)
  local runtimepath = vim.fn.stdpath('config') .. '/lua'
  if opts.runtimepath then
    runtimepath = opts.runtimepath
  end

  local filepath = get_filepath(modpath, runtimepath)

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

function M.getmodlist(modpath, opts)
  local runtimepath = vim.fn.stdpath('config') .. '/lua'
  if opts.runtimepath then
    runtimepath = opts.runtimepath
  end

  local filepath = get_filepath(modpath, runtimepath)
  local fs, fail = uv.fs_scandir(filepath)
  if fail then
    vim.api.nvim_err_writeln(fail)
    return
  end

  -- Load modules in the modpath, found in the filesystem
  local list = {}
  local name, fstype = uv.fs_scandir_next(fs)
  while name ~= nil do
    if fstype == 'file' then
      local filename = vim.split(name, '.', true)[1]
      local pluginmod = string.format('%s.%s', modpath, filename)
      table.insert(list, pluginmod)
    end

    name, fstype = uv.fs_scandir_next(fs)
  end

  return list
end

return M
