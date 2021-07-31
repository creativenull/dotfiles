local colorscheme = require('cnull.core.colorscheme')
local command = require('cnull.core.command')
local config = require('cnull.core.config')
local event = require('cnull.core.event')
local keymap = require('cnull.core.keymap')
local lsp = require('cnull.core.lsp')
local reload = require('cnull.core.reload')
local plugin = require('cnull.core.plugin')

local M = {
  augroup = event.augroup,
  autocmd = event.autocmd,
  command = command,
  keymap = keymap,
  lsp = lsp,
  reload = reload,
}

-- Core setup
-- @param table cfg
-- @return nil
function M.setup(opts)
  local cfg = config.init(opts.config)

  -- Before core setup
  if opts.before then
    opts.before(cfg)
  else
    error('core: before() is required!')
  end

  -- Leader mappings
  vim.g.mapleader = cfg.leader
  vim.g.maplocalleader = cfg.localleader

  -- Python3 plugins support
  if vim.env.PYTHON3_HOST_PROG ~= nil then
    vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG
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
  if opts.after then
    opts.after(cfg)
  else
    error('core: after() is required!')
  end
end

return M
