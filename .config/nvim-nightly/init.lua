-- Pack Path
vim.cmd 'set packpath-=~/.config/nvim'
vim.cmd 'set packpath-=~/.config/nvim/after'
vim.cmd 'set packpath-=~/.local/share/nvim/site'
vim.cmd 'set packpath-=~/.local/share/nvim/site/after'
vim.cmd 'set packpath-=/etc/xdg/nvim'
vim.cmd 'set packpath-=/etc/xdg/nvim/after'
vim.cmd 'set packpath-=/usr/local/share/nvim/site'
vim.cmd 'set packpath-=/usr/local/share/nvim/site/after'
vim.cmd 'set packpath-=/usr/share/nvim/site'
vim.cmd 'set packpath-=/usr/share/nvim/site/after'
vim.cmd 'set packpath^=~/.config/nvim-nightly'
vim.cmd 'set packpath+=~/.config/nvim-nightly/after'
vim.cmd 'set packpath^=~/.local/share/nvim-nightly/site'
vim.cmd 'set packpath+=~/.local/share/nvim-nightly/site/after'

-- Runtime Path
vim.cmd 'set runtimepath-=~/.config/nvim'
vim.cmd 'set runtimepath-=~/.config/nvim/after'
vim.cmd 'set runtimepath-=~/.local/share/nvim/site'
vim.cmd 'set runtimepath-=~/.local/share/nvim/site/after'
vim.cmd 'set runtimepath-=/etc/xdg/nvim'
vim.cmd 'set runtimepath-=/etc/xdg/nvim/after'
vim.cmd 'set runtimepath-=/usr/share/nvim/site'
vim.cmd 'set runtimepath-=/usr/share/nvim/site/after'
vim.cmd 'set runtimepath-=/usr/local/share/nvim/site'
vim.cmd 'set runtimepath-=/usr/local/share/nvim/site/after'
vim.cmd 'set runtimepath+=~/.config/nvim-nightly/after'
vim.cmd 'set runtimepath^=~/.config/nvim-nightly'
vim.cmd 'set runtimepath+=~/.local/share/nvim-nightly/site/after'
vim.cmd 'set runtimepath^=~/.local/share/nvim-nightly/site'

-- Utils
local utils = require 'creativenull.utils'
local CONFIG_DIR = os.getenv 'HOME' .. '/.config/nvim-nightly'
local LOCAL_DIR = os.getenv 'HOME' .. '/.local/share/nvim-nightly'

-- =============================================================================
-- = Plugin Manager =
-- =============================================================================
require 'creativenull.plugins'

-- =============================================================================
-- = Autocmds =
-- =============================================================================
vim.cmd 'augroup yank_hl'
vim.cmd 'au!'
vim.cmd [[au TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'Search', timeout = 500 }]]
vim.cmd 'augroup END'

vim.cmd 'augroup statusline_tabline_hi'
vim.cmd 'au!'
vim.cmd [[au ColorScheme * lua require'creativenull.statusline'.set_highlights()]]
vim.cmd [[au ColorScheme * lua require'creativenull.tabline'.set_highlights()]]
vim.cmd 'augroup END'

-- =============================================================================
-- = Theming and Looks =
-- =============================================================================
vim.cmd 'syntax on'
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_sign_column = 'dark0_hard'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_number_column = 'dark0_hard'

vim.cmd 'colorscheme gruvbox'

-- =============================================================================
-- = General =
-- =============================================================================
vim.cmd 'filetype plugin indent on'

-- Completion options
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Search options
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true

-- Indent options
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Line options
vim.o.showmatch = true
vim.o.showbreak = '+++'
vim.o.textwidth = 120
vim.o.scrolloff = 5
vim.wo.linebreak = true
vim.wo.colorcolumn = '120'

-- No backups or swapfiles needed
vim.o.dir = os.getenv 'HOME' .. '/.cache/nvim'
vim.o.backup = true
vim.o.backupdir = os.getenv 'HOME' .. '/.cache/nvim'
vim.o.undofile = true
vim.o.undodir = os.getenv 'HOME' .. '/.cache/nvim'
vim.o.undolevels = 1000
vim.o.history = 1000

-- Lazy redraw
vim.o.lazyredraw = true

-- Buffers/Tabs/Windows
vim.o.hidden = true

-- update time to 300ms
vim.o.updatetime = 300

-- Set spelling
vim.o.spell = false

-- For git
vim.wo.signcolumn = 'yes'

-- Mouse support
vim.o.mouse = 'a'

-- backspace behaviour
vim.o.backspace = 'indent,eol,start'

-- Status line
vim.o.showmode = false
vim.o.laststatus = 2
vim.o.statusline = [[%!luaeval("require'creativenull.statusline'.render()")]]

-- Tab line
vim.o.showtabline = 2
vim.o.tabline = [[%!luaeval("require'creativenull.tabline'.render()")]]

-- Better display
vim.o.cmdheight = 2

-- Auto reload file if changed outside vim, or just :e!
vim.o.autoread = true

-- =============================================================================
-- = Keybindings =
-- =============================================================================
vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
utils.vnoremap('<up>',    '<nop>')
utils.vnoremap('<down>',  '<nop>')
utils.vnoremap('<left>',  '<nop>')
utils.vnoremap('<right>', '<nop>')

utils.inoremap('<up>',    '<nop>')
utils.inoremap('<down>',  '<nop>')
utils.inoremap('<left>',  '<nop>')
utils.inoremap('<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
utils.inoremap('jk', '<ESC>')

-- Map escape from terminal input to Normal mode
utils.tnoremap('<ESC>', [[<C-\><C-n>]])
utils.tnoremap('<C-[>', [[<C-\><C-n>]])

-- Copy/Paste from the system clipboard
utils.vnoremap('<C-i>', [["+y<CR>]])
utils.nnoremap('<C-o>', [["+p<CR>]])

-- File explorer
utils.nnoremap('<F3>', ':Ex<CR>')

-- Omnifunc
utils.inoremap('<C-Space>', '<C-x><C-o>')

-- Disable highlights
utils.nnoremap('<leader><CR>', ':noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
utils.nnoremap('<leader>ba', ':buffers<CR>')
utils.nnoremap('<leader>bn', ':enew<CR>')
utils.nnoremap('<C-l>',      ':bnext<CR>')
utils.nnoremap('<C-h>',      ':bprevious<CR>')
utils.nnoremap('<leader>bd', ':bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
utils.nnoremap('<up>',    ':resize +2<CR>')
utils.nnoremap('<down>',  ':resize -2<CR>')
utils.nnoremap('<left>',  ':vertical resize -2<CR>')
utils.nnoremap('<right>', ':vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
utils.nnoremap('<M-j>', [[mz:m+<CR>`z]])
utils.nnoremap('<M-k>', [[mz:m-2<CR>`z]])
utils.vnoremap('<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
utils.vnoremap('<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
utils.nnoremap('<leader>r', ':e!<CR>')

-- =============================================================================
-- = Commands =
-- =============================================================================
vim.cmd('command! Config edit $MYVIMRC')
vim.cmd('command! ConfigDir edit ' .. CONFIG_DIR)
vim.cmd('command! ConfigReload luafile $MYVIMRC')
