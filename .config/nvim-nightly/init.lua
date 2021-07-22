-- Name: Arnold Chand
-- Github: https://github.com/creativenull
-- My vimrc, pre-requisites:
-- + python3
-- + nnn
-- + ripgrep
-- + bat
-- + Environment variables:
--   + $PYTHON3_HOST_PROG
--
-- Currently, tested on a Linux machine (maybe macOS, Windows is a bit of a stretch)
-- =============================================================================
-- DO NOT DO THIS, check the link
-- https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- Runtime Path
_G.init_ns = 'nvim-nightly'
vim.cmd('set runtimepath-=~/.config/nvim')
vim.cmd('set runtimepath-=~/.config/nvim/after')
vim.cmd('set runtimepath-=~/.local/share/nvim/site')
vim.cmd('set runtimepath-=~/.local/share/nvim/site/after')
vim.cmd('set runtimepath-=/etc/xdg/nvim')
vim.cmd('set runtimepath-=/etc/xdg/nvim/after')
vim.cmd('set runtimepath-=/usr/share/nvim/site')
vim.cmd('set runtimepath-=/usr/share/nvim/site/after')
vim.cmd('set runtimepath-=/usr/local/share/nvim/site')
vim.cmd('set runtimepath-=/usr/local/share/nvim/site/after')

vim.cmd(string.format('set runtimepath+=~/.config/%s/after', _G.init_ns))
vim.cmd(string.format('set runtimepath^=~/.config/%s', _G.init_ns))
vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', _G.init_ns))
vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', _G.init_ns))

-- Pack Path
vim.cmd('set packpath-=~/.config/nvim')
vim.cmd('set packpath-=~/.config/nvim/after')
vim.cmd('set packpath-=~/.local/share/nvim/site')
vim.cmd('set packpath-=~/.local/share/nvim/site/after')
vim.cmd('set packpath-=/etc/xdg/nvim')
vim.cmd('set packpath-=/etc/xdg/nvim/after')
vim.cmd('set packpath-=/usr/local/share/nvim/site')
vim.cmd('set packpath-=/usr/local/share/nvim/site/after')
vim.cmd('set packpath-=/usr/share/nvim/site')
vim.cmd('set packpath-=/usr/share/nvim/site/after')

vim.cmd(string.format('set packpath^=~/.config/%s', _G.init_ns))
vim.cmd(string.format('set packpath+=~/.config/%s/after', _G.init_ns))
vim.cmd(string.format('set packpath^=~/.local/share/%s/site', _G.init_ns))
vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', _G.init_ns))

-- Initialize
local core    = require 'cnull.core'
local autocmd = core.autocmd

core.setup {
  ns = _G.init_ns,
  leader = ' ',

  theme = {
    name = 'tokyonight',
    transparent = true,
    setup = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_transparent = true
    end,
  },

  plugins = require 'cnull.plugins'.init {
    install_path = string.format('%s/.local/share/%s/site/pack/packager/opt/vim-packager', vim.env.HOME, _G.init_ns),
    config_dir = string.format('%s/.config/%s', vim.env.HOME, _G.init_ns),
    init = {
      dir = string.format('%s/.local/share/%s/site/pack/packager', vim.env.HOME, _G.init_ns),
    },
  },

  -- Events
  on_before_setup = function()
    -- Highlight text yank
    autocmd {
      clear = true,
      event = 'TextYankPost',
      exec = function()
        vim.highlight.on_yank { higroup = 'Search', timeout = 500 }
      end,
    }
  end,

  on_after_setup = function()
    require 'colorizer'.setup()
    require 'cnull.keymaps'
    require 'cnull.conceal'
    require 'cnull.codeshot'
    require 'cnull.options'
    require 'cnull.commands'
  end,
}
