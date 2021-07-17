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
_G.rc_namespace = 'nvim-nightly'
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

vim.cmd(string.format('set runtimepath+=~/.config/%s/after', _G.rc_namespace))
vim.cmd(string.format('set runtimepath^=~/.config/%s', _G.rc_namespace))
vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', _G.rc_namespace))
vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', _G.rc_namespace))

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

vim.cmd(string.format('set packpath^=~/.config/%s', _G.rc_namespace))
vim.cmd(string.format('set packpath+=~/.config/%s/after', _G.rc_namespace))
vim.cmd(string.format('set packpath^=~/.local/share/%s/site', _G.rc_namespace))
vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', _G.rc_namespace))

-- Initialize
local core    = require 'cnull.core'
local command = core.command
local autocmd = core.autocmd
local undodir = vim.fn.expand('~/.cache/nvim/undo')

core.setup {
  ns = _G.rc_namespace,
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
    install_path = string.format('%s/.local/share/%s/site/pack/packager/opt/vim-packager', vim.env.HOME, _G.rc_namespace),
    config_dir = string.format('%s/.config/%s', vim.env.HOME, _G.rc_namespace),
    init = {
      dir = string.format('%s/.local/share/%s/site/pack/packager', vim.env.HOME, _G.rc_namespace),
    },
  },

  -- Events
  on_before_setup = function()
    require 'cnull.statusline'

    -- Highlight text yank
    autocmd {
      clear = true,
      event = 'TextYankPost',
      exec = function()
        vim.highlight.on_yank {
          higroup = 'Search',
          timeout = 500,
        }
      end,
    }
  end,

  on_after_setup = function()
    require 'colorizer'.setup()
    require 'bufferline'.setup {}
    require 'cnull.keymaps'
    require 'cnull.conceal'
    require 'cnull.codeshot'
  end,
}

-- =============================================================================
-- = Functions =
-- =============================================================================

local function options_init()
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
  end
end

-- =============================================================================
-- = Options =
-- =============================================================================

-- Init Bootstrap
options_init()

-- Completion options
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.shortmess:append('c')

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Editor
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.showmatch = true
vim.opt.wrap = false
vim.opt.colorcolumn = '120'
vim.opt.scrolloff = 5
vim.opt.lazyredraw = true
vim.opt.spell = false

-- System
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.undolevels = 10000
vim.opt.history = 10000
vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ttimeoutlen = 50
vim.opt.mouse = ''

-- UI
vim.opt.hidden = true
vim.opt.signcolumn = 'yes'
vim.opt.cmdheight = 2
vim.opt.showtabline = 2
vim.opt.laststatus = 2

-- =============================================================================
-- = Commands =
-- =============================================================================

command('ConfigPlugins', [[execute "edit ]] .. vim.env.HOME .. [[/.config/nvim-nightly/lua/cnull/plugins/plugins.lua"]])

-- I can't release my shift key fast enough :')
command('W',  [[w]],  {'-bang'})
command('Wq', [[wq]], {'-bang'})
command('WQ', [[wq]], {'-bang'})
command('Q',  [[q]],  {'-bang'})
command('Qa', [[qa]], {'-bang'})
command('QA', [[qa]], {'-bang'})
