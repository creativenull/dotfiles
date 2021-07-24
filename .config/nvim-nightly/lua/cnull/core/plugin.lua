local stdpath = vim.fn.stdpath
local getmodlist = require 'cnull.core.lib.autorequire'.getmodlist

local M = {
  config = {
    modname = 'cnull.plugins',
    git = 'https://github.com/wbthomason/packer.nvim.git',
    pack = 'packer.nvim',
    selfcare = 'wbthomason/packer.nvim',
    installpath = stdpath('data') .. '/site/packer/pack/packer/opt/packer.nvim',
    init = nil,
  },
  modlist = {},
}

-- Trigger any before() function in a plugin file
-- @param table config
-- @return nil
function M.trigger_before(config)
  for _,modname in pairs(M.modlist) do
    local mod = require(modname)
    if mod.before and type(mod.before) == 'function' then
      mod.before(config)
    end
  end
end

-- Trigger any before
function M.trigger_after(config)
  for _,modname in pairs(M.modlist) do
    local mod = require(modname)
    if mod.after and type(mod.after) == 'function' then
      mod.after(config)
    end
  end
end

function M.loadplugins(config)
  local packer = require 'packer'
  local plugin_names = {}

  -- Get plugin names from each file
  for _,modname in pairs(M.modlist) do
    local mod = require(modname)
    if mod.plugins then
      for _,plugin in pairs(mod.plugins) do
        table.insert(plugin_names, plugin)
      end
    else
      vim.api.nvim_err_writeln('plugin: "M.plugins" is required to properly load plugins')
      return
    end
  end

  -- Initilize packer options
  if M.config.init then
    packer.init(M.config.init)
  end

  -- Load the plugins w/ packer
  packer.startup(function(use)
    if M.config.selfcare then
      use { M.config.selfcare, opt = true }
    end

    for _,name in pairs(plugin_names) do
      use(name)
    end
  end)
end

function M.setup(config)
  M.config = vim.tbl_extend('force', M.config, config.plugins_config)
  M.modlist = getmodlist(M.config.modname, { runtimepath = config.runtimepath })
  local installing = false

  -- Trigger the before() functions in each plugin file
  M.trigger_before(config)

  -- Bootstraping
  local pconfig = M.config
  if vim.fn.isdirectory(pconfig.installpath) == 0 then
    vim.api.nvim_command(string.format('!git clone %s %s', pconfig.git, pconfig.installpath))

    vim.api.nvim_command('packadd ' .. pconfig.pack)
    M.loadplugins(config)

    -- Install plugins
    installing = true
    vim.api.nvim_command('PackerInstall')
  else
    vim.api.nvim_command('packadd ' .. pconfig.pack)
    M.loadplugins(config)
  end

  -- Trigger the after() functions in each plugin file
  if not installing then
    M.trigger_after(config)
  end

  -- TODO: Register plugin template
  vim.api.nvim_command([[iabbrev cnpl local M = {<CR>plugins = {<CR>{'plugin/name'},<CR>},<CR>}<CR><CR> function M.before()<CR>end<CR><CR> function M.after()<CR>end<CR><CR> return M]])
end

return M
