local api = vim.api
local fn = vim.fn
local getmodlist = require('cnull.core.lib.autorequire').getmodlist

local M = {
  config = {
    modname = 'cnull.plugins',
    git = 'https://github.com/savq/paq-nvim.git',
    pack = 'paq-nvim',
    selfcare = 'savq/paq-nvim',
    installpath = fn.stdpath('data') .. '/site/pack/paqs/opt/paq-nvim',
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

function M.loadplugins()
  local paq = require('paq')
  local plugin_names = {}

  -- Get plugin names from each file
  for _,modname in pairs(M.modlist) do
    local mod = require(modname)
    if mod.plugins then
      for _,plugin in pairs(mod.plugins) do
        table.insert(plugin_names, plugin)
      end
    else
      api.nvim_err_writeln('plugin: "M.plugins" is required to properly load plugins')
      return
    end
  end

  -- Load the plugins w/ packer
  if M.config.selfcare then
    table.insert(plugin_names, {M.config.selfcare, opt = true})
  end

  -- Initilize packer options
  if M.config.init then
    paq:setup(M.config.init)(plugin_names)
  else
    paq(plugin_names)
  end
end

function M.setup(config)
  M.config = vim.tbl_extend('force', M.config, config.plugins_config)
  M.modlist = getmodlist(M.config.modname, { runtimepath = config.runtimepath })
  local installing = false

  -- Trigger the before() functions in each plugin file
  M.trigger_before(config)

  -- Bootstraping
  local pconfig = M.config
  if fn.isdirectory(pconfig.installpath) == 0 then
    api.nvim_command(string.format('!git clone %s %s', pconfig.git, pconfig.installpath))

    api.nvim_command('packadd ' .. pconfig.pack)
    M.loadplugins()

    -- Install plugins
    installing = true
    api.nvim_command('PaqInstall')
  else
    api.nvim_command('packadd ' .. pconfig.pack)
    M.loadplugins()
  end

  -- Trigger the after() functions in each plugin file
  if not installing then
    M.trigger_after(config)
  end

  -- TODO: Register plugin template
  api.nvim_command([[iabbrev cnpl local M = {<CR>plugins = {<CR>{'plugin/name'},<CR>},<CR>}<CR><CR> function M.before()<CR>end<CR><CR> function M.after()<CR>end<CR><CR> return M]])
end

return M
