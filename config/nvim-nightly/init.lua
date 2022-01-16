-- Name: Arnold Chand
-- Github: https://github.com/creativenull
-- Description: My vimrc works with MacOS, Linux and Windows, requires
--   + curl (globally installed)
--   + git (globally installed)
--   + python3 (globally installed)
--   + ripgrep (globally installed)
--   + deno (globally installed)
-- =============================================================================

vim.g.userspace = 'nvim-nightly'
if vim.g.userspace then
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

  vim.cmd(string.format('set runtimepath+=~/.config/%s/after', vim.g.userspace))
  vim.cmd(string.format('set runtimepath^=~/.config/%s', vim.g.userspace))
  vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', vim.g.userspace))
  vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', vim.g.userspace))

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

  vim.cmd(string.format('set packpath^=~/.config/%s', vim.g.userspace))
  vim.cmd(string.format('set packpath+=~/.config/%s/after', vim.g.userspace))
  vim.cmd(string.format('set packpath^=~/.local/share/%s/site', vim.g.userspace))
  vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', vim.g.userspace))
end

if vim.fn.has('nvim') == 0 and vim.fn.has('nvim-0.7') == 0 then
  vim.api.nvim_err_writeln('This config is only for neovim nightly version aka EXPERIMENTAL!')
  return
end

local exec_list = { 'git', 'curl', 'python3', 'rg', 'deno' }
for _, exec in pairs(exec_list) do
  if vim.fn.executable(exec) == 0 then
    local errmsg = string.format('[nvim] %q is needed!', exec)
    vim.api.nvim_err_writeln(errmsg)
    return
  end
end

-- =============================================================================
-- = Initialize =
-- =============================================================================

vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = vim.fn.exepath('python3')

vim.g.mapleader = ' '
local cnull = {
  transparent = true,
  config = {
    config_dir = '',
    data_dir = '',
    cache_dir = '',
    undodir = '',
  },
}

if vim.g.userspace then
  cnull.config.data_dir = string.format('%s/.local/share/%s', vim.env.HOME, vim.g.userspace)
  cnull.config.cache_dir = string.format('%s/.cache/%s', vim.env.HOME, vim.g.userspace)
  cnull.config.config_dir = string.format('%s/.config/%s', vim.env.HOME, vim.g.userspace)
else
  cnull.config.data_dir = vim.fn.stdpath('data')
  cnull.config.cache_dir = vim.fn.stdpath('config')
  cnull.config.config_dir = vim.fn.stdpath('cache')
end

cnull.config.undodir = string.format('%s/undodir', cnull.config.cache_dir)

-- Custom vim functions
local vim = vim

vim.autocmd = {}

---Create an auto command
---@param event string
---@param pattern string
---@param command string
---@param opts table
---@return nil
vim.autocmd.set = function(event, pattern, command, opts)
  opts = opts or { once = nil, nested = nil }
  local once = opts.once and '++once' or ''
  local nested = opts.nested and '++nested' or ''
  vim.cmd(string.format('autocmd %s %s %s %s %s', event, pattern, once, nested, command))
end

---Delete an auto command
---@param event string
---@return nil
vim.autocmd.del = function(event)
  vim.cmd('autocmd! ' .. event)
end

vim.augroup = {}

---Create an auto group command that takes
---a vim.autocmd.set values as a table
---@param name string
---@param autocmds table
---@return nil
vim.augroup.set = function(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, au in pairs(autocmds) do
    -- vim.cmd(au)
    vim.autocmd.set(au[1], au[2], au[3], au[4])
  end
  vim.cmd('augroup END')
end

-- =============================================================================
-- = Functions =
-- =============================================================================

---Toggle conceal level of local buffer
---which is enabled by some syntax plugin
function _G.ToggleConcealLevel()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].conceallevel == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

---Toggle the view of the editor, for taking screenshots
---or for copying code from the editor w/o using "+ register
---when not accessible, eg from a remote ssh
function _G.ToggleCodeshot()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].number then
    vim.wo[win].number = false
    vim.wo[win].signcolumn = 'no'
  else
    vim.wo[win].number = true
    vim.wo[win].signcolumn = 'yes'
  end
end

-- Indent rules given to a filetype, use spaces if needed
---@param size number
---@param use_spaces boolean
function _G.IndentSize(size, use_spaces)
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].tabstop = size
  vim.bo[buf].softtabstop = size
  vim.bo[buf].shiftwidth = size

  if use_spaces then
    vim.bo[buf].expandtab = true
  else
    vim.bo[buf].expandtab = false
  end
end

-- =============================================================================
-- = Events (AUG) =
-- =============================================================================

if cnull.transparent then
  vim.augroup.set('transparent_user_events', {
    { 'ColorScheme', '*', 'highlight! Normal guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! SignColumn guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! LineNr guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! CursorLineNr guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! EndOfBuffer guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! ColorColumn guibg=#444444' },

    -- Transparent LSP Float Windows
    { 'ColorScheme', '*', 'highlight! NormalFloat guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! ErrorFloat guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! WarningFloat guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! InfoFloat guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! HintFloat guibg=NONE' },
    { 'ColorScheme', '*', 'highlight! FloatBorder guifg=#aaaaaa guibg=NONE' },

    -- Transparent Comments
    { 'ColorScheme', '*', 'highlight! Comment guifg=#888888 guibg=NONE' },
  })
end

vim.augroup.set('highlightyank_user_events', {
  { 'TextYankPost', '*', 'silent! lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })' },
})

-- Default Filetype Options
vim.augroup.set('filetype_user_events', {
  { 'FileType', 'vim,lua', 'lua IndentSize(2, true)' },
  { 'FileType', 'scss,sass,css', 'lua IndentSize(2, true)' },
  { 'FileType', 'javascript,javascriptreact', 'lua IndentSize(2, true)' },
  { 'FileType', 'typescript,typescriptreact', 'lua IndentSize(2, true)' },
  { 'FileType', 'json,jsonc', 'lua IndentSize(2, true)' },
  { 'FileType', 'vue', 'lua IndentSize(2, true)' },
  { 'FileType', 'php,blade,html', 'lua IndentSize(4, true)' },
  { 'FileType', 'markdown', 'setlocal spell | lua IndentSize(4, true)' },
})

-- =============================================================================
-- = Options (OPT) =
-- =============================================================================

if vim.fn.isdirectory(cnull.config.undodir) == 0 then
  vim.cmd(string.format('silent !mkdir -p %s', cnull.config.undodir))
end

-- Completion
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.shortmess:append('c')

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.path = '**'

-- Editor
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.colorcolumn = '120'
vim.opt.scrolloff = 3
vim.opt.lazyredraw = true
vim.opt.spell = false
vim.opt.wildignorecase = true

-- System
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.undodir = cnull.config.undodir
vim.opt.undolevels = 10000
vim.opt.history = 10000
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.ttimeoutlen = 50
vim.opt.mouse = ''

-- UI
vim.opt.hidden = true
vim.opt.signcolumn = 'yes'
vim.opt.cmdheight = 2
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:block', 'r-cr-o:hor20' }
vim.opt.termguicolors = true
vim.opt.number = true

-- =============================================================================
-- = Keybindings (KEY) =
-- =============================================================================
local keymap = vim.keymap
local DEFAULT_KEYMAP_OPTS = { noremap = true, silent = true }

-- Unbind default bindings for arrow keys, trust me this is for your own good
keymap.set('', '<Up>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('', '<Down>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('', '<Left>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('', '<Right>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('i', '<Up>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('i', '<Down>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('i', '<Left>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)
keymap.set('i', '<Right>', [[<Nop>]], DEFAULT_KEYMAP_OPTS)

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
keymap.set('n', '<Up>', [[<Cmd>resize +2<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Down>', [[<Cmd>resize -2<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Left>', [[<Cmd>vertical resize -2<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Right>', [[<Cmd>vertical resize +2<CR>]], DEFAULT_KEYMAP_OPTS)

-- Map Esc, to perform quick switching between Normal and Insert mode
keymap.set('i', 'jk', [[<Esc>]], DEFAULT_KEYMAP_OPTS)

-- Map escape from terminal input to Normal mode
keymap.set('t', '<Esc>', [[<C-\><C-n>]], DEFAULT_KEYMAP_OPTS)
keymap.set('t', '<C-[>', [[<C-\><C-n>]], DEFAULT_KEYMAP_OPTS)

-- Disable highlights
keymap.set('n', '<Leader><CR>', [[<Cmd>noh<CR>]], DEFAULT_KEYMAP_OPTS)

-- List all buffers
keymap.set('n', '<Leader>bl', [[<Cmd>buffers<CR>]], DEFAULT_KEYMAP_OPTS)

keymap.set('n', '<C-l>', [[<Cmd>bnext<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Leader>bn', [[<Cmd>bnext<CR>]], DEFAULT_KEYMAP_OPTS)

keymap.set('n', '<C-h>', [[<Cmd>bprevious<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Leader>bp', [[<Cmd>bprevious<CR>]], DEFAULT_KEYMAP_OPTS)

-- Close the current buffer, and more?
keymap.set('n', '<Leader>bd', [[<Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>]], DEFAULT_KEYMAP_OPTS)
-- Close all buffer, except current
keymap.set('n', '<Leader>bx', [[<Cmd>%bd<Bar>e#<Bar>bd#<CR>]], DEFAULT_KEYMAP_OPTS)

-- Move a line of text Alt+[j/k]
keymap.set('n', '<M-j>', [[mz:m+<CR>`z]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<M-k>', [[mz:m-2<CR>`z]], DEFAULT_KEYMAP_OPTS)
keymap.set('v', '<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]], DEFAULT_KEYMAP_OPTS)
keymap.set('v', '<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]], DEFAULT_KEYMAP_OPTS)

-- Edit vimrc
keymap.set('n', '<Leader>ve', [[<Cmd>edit $MYVIMRC<CR>]], DEFAULT_KEYMAP_OPTS)

-- Source the vimrc to reflect changes
keymap.set('n', '<Leader>vs', [[<Cmd>ConfigReload<CR>]], DEFAULT_KEYMAP_OPTS)

-- Reload file
keymap.set('n', '<Leader>r', [[<Cmd>edit!<CR>]], DEFAULT_KEYMAP_OPTS)

-- Copy/Paste from clipboard
keymap.set('v', '<Leader>y', [["+y]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Leader>y', [["+y]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Leader>p', [["+p]], DEFAULT_KEYMAP_OPTS)

-- Disable Ex-mode
keymap.set('n', 'Q', [[<Nop>]], DEFAULT_KEYMAP_OPTS)

-- Utilities
keymap.set('n', 'Y', [[y$]], DEFAULT_KEYMAP_OPTS)

-- =============================================================================
-- = Commands (CMD) =
-- =============================================================================

vim.cmd('command! Config edit $MYVIMRC')
vim.cmd('command! ConfigReload source $MYVIMRC | nohlsearch')

vim.cmd('command! ToggleConcealLevel lua ToggleConcealLevel()')
vim.cmd('command! ToggleCodeshot lua ToggleCodeshot()')

vim.cmd('command! MyTodoPersonal edit ~/todofiles/personal/README.md')
vim.cmd('command! MyTodoWork edit ~/todofiles/work/README.md')

-- Command Abbreviations, I can't release my shift key fast enough 😭
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qa qa')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Wq wq')

-- =============================================================================
-- = Plugin Pre-Config - before loading plugins (PRE) =
-- =============================================================================

-- vim-vsnip Config
-- ---
vim.g.vsnip_extra_mapping = false
vim.g.vsnip_filetypes = {
  javascriptreact = { 'javascript' },
  typescriptreact = { 'typescript' },
}

-- emmet-vim Config
-- ---
vim.g.user_emmet_leader_key = '<C-q>'
vim.g.user_emmet_install_global = 0

vim.augroup.set('emmet_user_events', {
  { 'FileType', 'html,blade,php,vue,javascriptreact,typescriptreact', 'EmmetInstall' },
})

-- indentLine Config
-- ---
vim.g.indentLine_char = '│'

-- projectlocal-vim Config
-- ---
vim.g.projectlocal = {
  showMessage = true,
  projectConfig = '.vim/init.lua',
  debug = false,
}

-- vim-json Config
-- ---
vim.g.vim_json_syntax_conceal = 0
vim.g.vim_json_conceal = 0

-- moonfly Config
-- ---
vim.g.moonflyNormalFloat = 1

-- lir.nvim Config
-- ---
vim.augroup.set('lir_user_events', {
  { 'ColorScheme', '*', 'highlight! default link CursorLine Visual' },
})

-- =============================================================================
-- = Plugin Manager (PLUG) =
-- =============================================================================

local install_path = cnull.config.data_dir .. '/site/pack/packer/start/packer.nvim'
local packer_firsttime = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local git = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({ 'git', 'clone', '--depth', '1', git, install_path })
  packer_firsttime = true
end

local packer = require('packer')
packer.init({
  package_root = cnull.config.data_dir .. '/site/pack',
  compile_path = cnull.config.data_dir .. '/site/plugin/packer_compiled.lua',
})

packer.startup(function(use)
  -- Self-maintenance
  use('wbthomason/packer.nvim')

  -- Deps
  use('Shougo/context_filetype.vim')
  use('kyazdani42/nvim-web-devicons')
  use('nvim-lua/plenary.nvim')
  use('vim-denops/denops.vim')
  use('lambdalisue/nerdfont.vim')

  -- Core
  use('creativenull/projectlocal-vim')
  use('windwp/nvim-autopairs')
  use('tpope/vim-abolish')
  use('tpope/vim-surround')
  use('tpope/vim-repeat')
  use('editorconfig/editorconfig-vim')
  use('numToStr/Comment.nvim')
  use('kevinhwang91/nvim-bqf')

  -- File Explorer
  use('tamago324/lir.nvim')

  -- Linters + Formatters + LSP Client
  use('neovim/nvim-lspconfig')
  -- use('creativenull/diagnosticls-configs-nvim')
  -- use('~/projects/github.com/creativenull/diagnosticls-configs-nvim')
  use('creativenull/efmls-configs-nvim')
  -- use('~/projects/github.com/creativenull/efmls-configs-nvim')

  -- Snippet Engine + Presets
  use('hrsh7th/vim-vsnip')
  use('rafamadriz/friendly-snippets')
  use('mattn/emmet-vim')

  -- AutoCompletion + Sources
  use({ 'Shougo/ddc.vim', tag = 'v1.0.0' })
  use('matsui54/denops-popup-preview.vim')
  use('tani/ddc-fuzzy')
  use('Shougo/ddc-around')
  use('matsui54/ddc-buffer')
  use('hrsh7th/vim-vsnip-integ')
  use('Shougo/ddc-nvim-lsp')

  -- Fuzzy File/Code Finder
  use('nvim-telescope/telescope.nvim')

  -- Git
  use('lewis6991/gitsigns.nvim')

  -- UI
  use('nvim-treesitter/nvim-treesitter')
  use('nvim-treesitter/nvim-treesitter-refactor')
  use('code-biscuits/nvim-biscuits')
  use('akinsho/bufferline.nvim')
  use('folke/todo-comments.nvim')
  use('nvim-lualine/lualine.nvim')
  use('norcalli/nvim-colorizer.lua')
  use('lukas-reineke/indent-blankline.nvim')

  -- Colorschemes
  use('bluz71/vim-nightfly-guicolors')
  use('bluz71/vim-moonfly-colors')
  use('fnune/base16-vim')

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_firsttime then
    packer.sync()
  end
end)

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

-- Comment.nvim Config
-- ---
require('Comment').setup()

-- nvim-lspconfig Config
-- ---
require('cnull.lsp')

-- ddc.vim Config
-- ---
require('cnull.autocompletion')

keymap.set(
  'i',
  '<C-y>',
  [[pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"]],
  { silent = true, expr = true }
)

keymap.set('i', '<C-Space>', [[ddc#map#manual_complete()]], {
  silent = true,
  expr = true,
  noremap = true,
})

-- Snippets
keymap.set({'i', 's'}, '<C-j>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<C-j>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true
})
keymap.set({'i', 's'}, '<C-k>', [[vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<C-k>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true
})

-- nvim-autopairs Config
-- ---
require('nvim-autopairs').setup()

-- gitsigns.nvim Config
-- ---
require('gitsigns').setup()

-- todo-comments.nvim Config
-- ---
require('todo-comments').setup()

-- telescope.nvim Config
-- ---
require('cnull.finder')

keymap.set('n', '<C-p>', [[<Cmd>lua TelescopeFindFiles()<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<C-t>', [[<Cmd>lua TelescopeLiveGrep()<CR>]], DEFAULT_KEYMAP_OPTS)
keymap.set('n', '<Leader>vf', [[<Cmd>lua TelescopeFindConfigFiles()<CR>]], DEFAULT_KEYMAP_OPTS)

if cnull.transparent then
  vim.augroup.set('augroup telescope_user_events', {
    { 'ColorScheme', '*', 'highlight! TelescopeBorder guifg=#aaaaaa' },
  })
end

-- nvim-treesitter Config
-- ---
require('cnull.treesitter')

-- nvim-biscuits Config
-- ---
require('cnull.biscuits')

keymap.set(
  'n',
  '<Leader>it',
  [[<Cmd>lua require('nvim-biscuits').toggle_biscuits()<CR>]],
  DEFAULT_KEYMAP_OPTS
)

-- lualine.nvim Config
-- ---
require('cnull.statusline')

-- indent-blankline.nvim Config
-- ---
if cnull.transparent then
  vim.augroup.set('augroup indent_blankline_user_events', {
    { 'ColorScheme', '*', 'highlight! IndentBlanklineHighlight guifg=#777777 guibg=NONE' },
  })
else
  vim.augroup.set('augroup indent_blankline_user_events', {
    { 'ColorScheme', '*', 'highlight! IndentBlanklineHighlight guifg=#444444 guibg=NONE' },
  })
end

require('cnull.indent_blankline')

-- bufferline.lua Config
-- ---
require('cnull.bufferline')

-- lir.nvim Config
-- ---
require('cnull.explorer')

-- colorizer.lua Config
-- ---
require('cnull.colorizer')

-- =============================================================================
-- = UI/Theme =
-- =============================================================================

vim.cmd('colorscheme base16-horizon-terminal-dark')
