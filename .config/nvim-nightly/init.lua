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

-- Utils
local util = require('creativenull.utils')

local config_dir = os.getenv('HOME') .. '/.config/nvim-nightly'
local local_dir = os.getenv('HOME') .. '/.local/share/nvim-nightly'

-- =============================================================================
-- = Functions =
-- =============================================================================

-- Toggle the conceal level to show
-- or hide chars in markdown, json and co.
function ToggleConceal()
    local conceal = vim.wo.conceallevel
    if conceal == 0 then
        vim.wo.conceallevel = 2
    else
        vim.wo.conceallevel = 0
    end
end

-- Returns the vim mode
function CursorMode()
    local mode_map = {
        ['n'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['i'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
    }

    return mode_map[vim.fn.mode()]
end

-- Check for the git repo and return the
-- branch name if it exists
function GitBranch()
    local cmd = 'git branch --show-current'

    local is_dir = util.is_dir(vim.fn.getcwd() .. '/.git')
    if not is_dir then
        return ''
    end

    local fp = io.popen(cmd)
    local branch = fp:read('*a')

    -- TODO:
    -- Will need to check if the '^@' chars are at the end
    -- instead of implicitly removing the last 2 chars
    branch = string.sub(branch, 0, -2)
    return branch
end

function LSPStatus()
    local diagnostics = require('lsp-status').diagnostics()
    if diagnostics.errors > 0 or diagnostics.warnings > 0 then
        return string.format('LSP %d 🔴 %d 🟡 ', diagnostics.errors, diagnostics.warnings)
    end

    return ''
end

function StatusLine()
    local status = ''

    -- left side
    status = status .. [[ %-{luaeval("CursorMode()")}]]
    status = status .. [[ %-{luaeval("GitBranch()")}]]
    status = status .. [[ %-t %-m %-r ]]

    -- right side
    status = status .. [[ %= %y LN %l/%L]]
    status = status .. [[ %{luaeval("LSPStatus()")}]]

    return status
end

-- =============================================================================
-- = Plugin Manager =
-- =============================================================================

vim.cmd('packadd packer.nvim')
require('creativenull.plugins')

-- =============================================================================
-- = Plugin Options =
-- =============================================================================

-- LSP
vim.cmd('packadd lsp-status.nvim')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd nvim-lspconfig')
require('creativenull.lsp')

-- Treesitter
vim.cmd('packadd nvim-treesitter')
require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'html', 'css', 'json', 'javascript', 'typescript', 'python', 'php', 'lua' },
    highlight = {
        enable = true
    }
}

-- Telescope
vim.cmd('packadd popup.nvim')
vim.cmd('packadd plenary.nvim')
vim.cmd('packadd telescope.nvim')
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')
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

nnoremap('<C-p>', '<cmd>Telescope find_files find_command=rg,--files,--hidden,--iglob,!.git<CR>')
nnoremap('<C-t>', '<cmd>Telescope live_grep<CR>')

-- Gitsigns
vim.cmd('packadd gitsigns.nvim')
require('gitsigns').setup{}

-- ProjectCMD
-- vim.cmd('packadd projectcmd.nvim')
-- require('projectcmd').setup {
--     key = os.getenv('NVIMRC_PROJECT_KEY')
-- }

-- =============================================================================
-- = General =
-- =============================================================================

vim.cmd('filetype plugin indent on')

vim.o.statusline = StatusLine()

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
vim.o.signcolumn = 'yes'

-- Mouse support
vim.o.mouse = 'a'

-- backspace behaviour
vim.o.backspace = 'indent,eol,start'

-- Status line
vim.o.showmode = false
vim.o.laststatus = 2

-- Tab line
vim.o.showtabline = 2

-- Better display
vim.o.cmdheight = 2

-- Auto reload file if changed outside vim, or just :e!
vim.o.autoread = true

-- =============================================================================
-- = Keybindings =
-- =============================================================================

vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
vnoremap('<up>', '<nop>')
vnoremap('<down>', '<nop>')
vnoremap('<left>', '<nop>')
vnoremap('<right>', '<nop>')

inoremap('<up>', '<nop>')
inoremap('<down>', '<nop>')
inoremap('<left>', '<nop>')
inoremap('<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
inoremap('jk', '<ESC>')

-- Map escape from terminal input to Normal mode
tnoremap('<ESC>', [[ <C-\><C-n> ]])
tnoremap('<C-[>', [[ <C-\><C-n> ]])

-- Copy/Paste from the system clipboard
vnoremap('<C-i>', [[ "+y<CR> ]])
nnoremap('<C-o>', [[ "+p<CR> ]])

-- File explorer
nnoremap('<F3>', ':Ex<CR>')

-- Disable highlights
nnoremap('<leader><CR>', ':noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
nnoremap('<leader>bl', ':buffers<CR>')
nnoremap('<leader>bn', ':enew<CR>')
nnoremap('<C-l>', ':bnext<CR>')
nnoremap('<C-h>', ':bprevious<CR>')
nnoremap('<leader>bd', ':bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
nnoremap('<up>', ':resize +2<CR>')
nnoremap('<down>', ':resize -2<CR>')
nnoremap('<left>', ':vertical resize -2<CR>')
nnoremap('<right>', ':vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
nnoremap('<M-j>', [[ mz:m+<CR>`z ]])
nnoremap('<M-k>', [[ mz:m-2<CR>`z ]])
vnoremap('<M-j>', [[ :m'>+<CR>`<my`>mzgv`yo`z ]])
vnoremap('<M-k>', [[ :m'<-2<CR>`>my`<mzgv`yo`z ]])

-- Reload file
nnoremap('<leader>r', ':e!<CR>')

-- =============================================================================
-- = Commands =
-- =============================================================================

vim.cmd('command! ToggleConceal lua ToggleConceal()')

vim.cmd('command! Config edit $MYVIMRC')
vim.cmd('command! ConfigDir edit ' .. config_dir)
vim.cmd('command! ConfigPlugins edit ' .. config_dir .. '/lua/creativenull/plugins.lua')
vim.cmd('command! ConfigLSP edit ' .. config_dir .. '/lua/creativenull/lsp.lua')

vim.cmd('command! ConfigReload luafile $MYVIMRC')

-- =============================================================================
-- = Theming and Looks =
-- =============================================================================

vim.cmd('syntax on')
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_sign_column = 'dark0_hard'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_number_column = 'dark0_hard'

vim.cmd('colorscheme gruvbox')
