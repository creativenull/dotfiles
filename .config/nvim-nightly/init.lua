-- Why do this? https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
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

vim.cmd('set runtimepath+=~/.config/nvim-nightly/after')
vim.cmd('set runtimepath^=~/.config/nvim-nightly')
vim.cmd('set runtimepath+=~/.local/share/nvim-nightly/site/after')
vim.cmd('set runtimepath^=~/.local/share/nvim-nightly/site')

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

vim.cmd('set packpath^=~/.config/nvim-nightly')
vim.cmd('set packpath+=~/.config/nvim-nightly/after')
vim.cmd('set packpath^=~/.local/share/nvim-nightly/site')
vim.cmd('set packpath+=~/.local/share/nvim-nightly/site/after')

-- =============================================================================
-- = Plugins =
-- =============================================================================
require 'creativenull.plugins'

-- =============================================================================
-- = Autocmds =
-- =============================================================================
require 'creativenull.autocmds'

-- =============================================================================
-- = Theming and Looks =
-- =============================================================================
require 'creativenull.colorscheme'

-- =============================================================================
-- = Options =
-- =============================================================================
require 'creativenull.options'

-- =============================================================================
-- = Keybindings =
-- =============================================================================
require 'creativenull.keybindings'

-- =============================================================================
-- = Commands =
-- =============================================================================
require 'creativenull.commands'
