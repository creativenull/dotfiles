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
local userspace = 'nvim-nightly'

-- Runtime Path
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

vim.cmd(string.format('set runtimepath+=~/.config/%s/after', userspace))
vim.cmd(string.format('set runtimepath^=~/.config/%s', userspace))
vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', userspace))
vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', userspace))

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

vim.cmd(string.format('set packpath^=~/.config/%s', userspace))
vim.cmd(string.format('set packpath+=~/.config/%s/after', userspace))
vim.cmd(string.format('set packpath^=~/.local/share/%s/site', userspace))
vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', userspace))

-- Initialize
local core = require 'cnull.core'
core.setup {
  config = {
    userspace = userspace,
    runtimepath = string.format('%s/.config/%s/lua', vim.env.HOME, userspace),
    leader = ' ',

    theme = {
      name = 'zephyr',
      transparent = true,
      setup = function()
        -- vim.g.tokyonight_style = 'night'
        -- vim.g.tokyonight_transparent = true
      end,
    },

    plugins_config = {
      modname = 'cnull.plugins',
      installpath = string.format('%s/.local/share/%s/site/pack/packer/opt/packer.nvim', vim.env.HOME, userspace),
      init = {
        package_root = string.format('%s/.local/share/%s/site/pack', vim.env.HOME, userspace),
        compile_path = string.format('%s/.local/share/%s/packer_compiled.lua', vim.env.HOME, userspace),
      },
    },
  },

  -- Events
  before = function()
    -- Highlight text yank
    core.autocmd {
      clear = true,
      event = 'TextYankPost',
      exec = function()
        vim.highlight.on_yank { higroup = 'Search', timeout = 500 }
      end,
    }
  end,

  after = function()
    require 'colorizer'.setup()
    require 'cnull.user.keymaps'
    require 'cnull.user.conceal'
    require 'cnull.user.codeshot'
    require 'cnull.user.options'
    require 'cnull.user.commands'
  end,
}
