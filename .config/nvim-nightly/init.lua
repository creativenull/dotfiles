-- Name: Arnold Chand
-- Github: https://github.com/creativenull
-- My vimrc, pre-requisites:
-- + python3
-- + nnn
-- + ripgrep
-- + Environment variables:
--   + $PYTHON3_HOST_PROG
--
-- Currently, tested on a Linux machine (maybe macOS, Windows is a bit of a stretch)
-- =============================================================================
-- DO NOT DO THIS, check the link
-- https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- Runtime Path
local rc_namespace = 'nvim-nightly'
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

vim.cmd(string.format('set runtimepath+=~/.config/%s/after', rc_namespace))
vim.cmd(string.format('set runtimepath^=~/.config/%s', rc_namespace))
vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', rc_namespace))
vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', rc_namespace))

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

vim.cmd(string.format('set packpath^=~/.config/%s', rc_namespace))
vim.cmd(string.format('set packpath+=~/.config/%s/after', rc_namespace))
vim.cmd(string.format('set packpath^=~/.local/share/%s/site', rc_namespace))
vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', rc_namespace))

-- Initialize
local core    = require 'cnull.core'
local command = core.command
local autocmd = core.autocmd
local undodir = vim.fn.expand('~/.cache/nvim/undo')

core.setup {
  leader = ' ',

  theme = {
    name = 'tokyonight',
    transparent = false,
    setup = function()
      vim.g.tokyonight_style = 'night'
    end,
  },

  plugins = require 'cnull.plugins'.init {
    install_path = string.format('%s/.local/share/%s/site/pack/packager/opt/vim-packager', vim.env.HOME, rc_namespace),
    config_dir = string.format('%s/.config/%s', vim.env.HOME, rc_namespace),
    init = {
      dir = string.format('%s/.local/share/%s/site/pack/packager', vim.env.HOME, rc_namespace),
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
        vim.highlight.on_yank { higroup = 'Search', timeout = 500 }
      end,
    }
  end,

  on_after_setup = function()
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
vim.opt.updatetime = 250

-- Search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indent options
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Line options
vim.opt.showmatch = true
vim.opt.wrap = false
vim.opt.colorcolumn = '120'
vim.opt.scrolloff = 5

-- No backups and swapfiles but undo tree
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.undolevels = 10000
vim.opt.history = 10000

-- Performance gainzzz
vim.opt.lazyredraw = true

-- Hide a buffer when abandoned using :bd
vim.opt.hidden = true

-- Spelling only for markdown
vim.opt.spell = false

-- For git signs
vim.opt.signcolumn = 'yes'

-- Show 2 lines of command output on the command line below
vim.opt.cmdheight = 2

-- Always show the tabline on top
vim.opt.showtabline = 2

-- Use system/OS clipboard by default
vim.opt.clipboard = 'unnamedplus'

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
