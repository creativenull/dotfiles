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
local v = require 'creativenull.utils'

local CONFIG_DIR = os.getenv('HOME') .. '/.config/nvim-nightly'
local LOCAL_DIR = os.getenv('HOME') .. '/.local/share/nvim-nightly'

-- =============================================================================
-- = Plugin Manager =
-- =============================================================================

require 'creativenull.plugins'

-- =============================================================================
-- = Plugin Options =
-- =============================================================================

-- LSP
require 'creativenull.lsp'

-- Treesitter
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'html', 'css', 'json', 'javascript', 'typescript', 'python', 'php', 'lua' },
    highlight = { enable = true }
}

-- Telescope
local telescope = require 'telescope'
local telescope_actions = require 'telescope.actions'
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = telescope_actions.move_selection_previous,
                ['<C-j>'] = telescope_actions.move_selection_next,
            }
        }
    }
}

v.nnoremap('<C-p>', '<cmd>Telescope find_files find_command=rg,--files,--hidden,--iglob,!.git<CR>')
v.nnoremap('<C-t>', '<cmd>Telescope live_grep<CR>')

-- Gitsigns
require 'gitsigns'.setup{}

-- ProjectCMD
-- require('projectcmd').setup {
--     key = os.getenv('NVIMRC_PROJECT_KEY')
-- }

-- =============================================================================
-- = Autocmds =
-- =============================================================================

vim.cmd 'augroup yank_hl'
vim.cmd 'au!'
vim.cmd [[au TextYankPost * silent! lua vim.highlight.on_yank { higroup = "Search", timeout = 500 }]]
vim.cmd 'augroup END'

vim.cmd 'augroup statusline_tabline_hi'
vim.cmd 'au!'
vim.cmd [[au ColorScheme * lua require('creativenull.statusline').set_highlights()]]
vim.cmd [[au ColorScheme * lua require('creativenull.tabline').set_highlights()]]
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
vim.o.scrolloff = 3
vim.wo.linebreak = true
vim.wo.colorcolumn = '120'

-- No backups or swapfiles needed
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Lazy redraw
vim.o.lazyredraw = true

-- Undo history
vim.o.undolevels = 1000

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
vim.o.statusline = [[%!luaeval("require('creativenull.statusline').render()")]]

-- Tab line
vim.o.showtabline = 2
vim.o.tabline = [[%!luaeval("require('creativenull.tabline').render()")]]

-- Better display
vim.o.cmdheight = 2

-- Auto reload file if changed outside vim, or just :e!
vim.o.autoread = true

-- =============================================================================
-- = Keybindings =
-- =============================================================================

vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
v.vnoremap('<up>',    '<nop>')
v.vnoremap('<down>',  '<nop>')
v.vnoremap('<left>',  '<nop>')
v.vnoremap('<right>', '<nop>')

v.inoremap('<up>',    '<nop>')
v.inoremap('<down>',  '<nop>')
v.inoremap('<left>',  '<nop>')
v.inoremap('<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
v.inoremap('jk', '<ESC>')

-- Map escape from terminal input to Normal mode
v.tnoremap('<ESC>', [[<C-\><C-n>]])
v.tnoremap('<C-[>', [[<C-\><C-n>]])

-- Copy/Paste from the system clipboard
v.vnoremap('<C-i>', [["+y<CR>]])
v.nnoremap('<C-o>', [["+p<CR>]])

-- File explorer
v.nnoremap('<F3>', ':Ex<CR>')

-- Omnifunc
v.inoremap('<C-Space>', '<C-x><C-o>')

-- Disable highlights
v.nnoremap('<leader><CR>', ':noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
v.nnoremap('<leader>ba', ':buffers<CR>')
v.nnoremap('<leader>bn', ':enew<CR>')
v.nnoremap('<C-l>',      ':bnext<CR>')
v.nnoremap('<C-h>',      ':bprevious<CR>')
v.nnoremap('<leader>bd', ':bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
v.nnoremap('<up>',    ':resize +2<CR>')
v.nnoremap('<down>',  ':resize -2<CR>')
v.nnoremap('<left>',  ':vertical resize -2<CR>')
v.nnoremap('<right>', ':vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
v.nnoremap('<M-j>', [[mz:m+<CR>`z]])
v.nnoremap('<M-k>', [[mz:m-2<CR>`z]])
v.vnoremap('<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
v.vnoremap('<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
v.nnoremap('<leader>r', ':e!<CR>')

-- =============================================================================
-- = Commands =
-- =============================================================================

vim.cmd('command! Config edit $MYVIMRC')
vim.cmd('command! ConfigDir edit ' .. CONFIG_DIR)
vim.cmd('command! ConfigReload luafile $MYVIMRC')
