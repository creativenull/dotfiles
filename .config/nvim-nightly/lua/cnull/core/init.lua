local command = require 'cnull.core.command'
local event = require 'cnull.core.event'
local keymap = require 'cnull.core.keymap'
local lsp = require 'cnull.core.lsp'
local config = require 'cnull.core.config'
local colorscheme = require 'cnull.core.colorscheme'

local M = {
  augroup = event.augroup,
  autocmd = event.autocmd,
  command = command,
  keymap = keymap,
  lsp = lsp,
}

function M.setup(cfg)
  cfg = config.init(cfg)

  -- Before core setup
  if cfg.on_before_setup then
    cfg.on_before_setup()
  else
    error('core: on_before_setup() is required')
  end

  vim.g.mapleader = cfg.leader
  vim.g.maplocalleader = cfg.localleader
  vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG

  -- Plugins
  if cfg.plugins then
    cfg.plugins.setup()
  end

  -- Color Scheme
  colorscheme.setup(cfg)

  -- Reload command
  local reloader = require 'cnull.core.reload'
  command('Config', [[edit $MYVIMRC]])
  command('ConfigReload', reloader)

  -- After core setup
  if cfg.on_after_setup then
    cfg.on_after_setup()
  else
    error('core: on_after_setup() is required')
  end
end

return M
