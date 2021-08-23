local M = {}

local function set_defaults(cfg)
  vim.g.loaded_python_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0

  -- Python3 plugins support
  if vim.env.PYTHON3_HOST_PROG ~= nil then
    vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG
  end

  -- Leader mappings
  vim.g.mapleader = cfg.leader
  vim.g.maplocalleader = cfg.localleader
end

-- Core setup
-- @param table cfg
-- @return nil
function M.setup(opts)
  local colorscheme = require('cnull.core.colorscheme')
  local command = require('cnull.core.command')
  local config = require('cnull.core.config')
  local plugin = require('cnull.core.plugin')
  local reload = require('cnull.core.reload')

  -- Default config
  local cfg = config.init(opts.config)

  -- Set defaults
  set_defaults(cfg)

  -- Before core setup
  if opts.on_before then
    opts.on_before(cfg)
  else
    error('core: before() is required!')
  end

  -- Plugins
  if cfg.plugins_config then
    plugin.setup(cfg)
  end

  -- Color Scheme
  colorscheme.setup(cfg)

  -- Reload command
  command('Config', [[edit $MYVIMRC]])
  command('ConfigReload', reload)

  -- After core setup
  if opts.on_after then
    opts.on_after(cfg)
  else
    error('core: after() is required!')
  end
end

return M
