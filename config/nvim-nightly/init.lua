--[[ ==========================================================================
Name: Arnold Chand

Github: https://github.com/creativenull

Description:
  My init.vim, sort of cross-platform but very experimental, requires:
    + curl (globally installed)
    + git (globally installed)
    + python3 (globally installed)
    + ripgrep (globally installed)
    + deno (globally installed)
============================================================================ ]]

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

if vim.fn.has('nvim') == 0 and vim.fn.has('nvim-0.8') == 0 then
  vim.api.nvim_err_writeln('This config is only for neovim nightly version aka EXPERIMENTAL!')

  return
end

-- Hard requirements for this config
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

local user = {
  transparent = true,
  config = {
    config_dir = '',
    data_dir = '',
    cache_dir = '',
    undodir = '',
  },
}

if vim.g.userspace then
  user.config.data_dir = string.format('%s/.local/share/%s', vim.env.HOME, vim.g.userspace)
  user.config.cache_dir = string.format('%s/.cache/%s', vim.env.HOME, vim.g.userspace)
  user.config.config_dir = string.format('%s/.config/%s', vim.env.HOME, vim.g.userspace)
else
  user.config.data_dir = vim.fn.stdpath('data')
  user.config.cache_dir = vim.fn.stdpath('config')
  user.config.config_dir = vim.fn.stdpath('cache')
end

user.config.undodir = string.format('%s/undodir', user.config.cache_dir)

-- =============================================================================
-- = Events (AUG) =
-- =============================================================================

if user.transparent then
  local transparent_user_events = vim.api.nvim_create_augroup('transparent_user_events', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = transparent_user_events,
    callback = function()
      vim.api.nvim_command('highlight! Normal guibg=NONE')
      vim.api.nvim_command('highlight! SignColumn guibg=NONE')
      vim.api.nvim_command('highlight! LineNr guibg=NONE')
      vim.api.nvim_command('highlight! CursorLineNr guibg=NONE')
      vim.api.nvim_command('highlight! EndOfBuffer guibg=NONE')
      vim.api.nvim_command('highlight! ColorColumn guibg=#444444')

      -- Transparent LSP Float Windows
      vim.api.nvim_command('highlight! NormalFloat guibg=NONE')
      vim.api.nvim_command('highlight! ErrorFloat guibg=NONE')
      vim.api.nvim_command('highlight! WarningFloat guibg=NONE')
      vim.api.nvim_command('highlight! InfoFloat guibg=NONE')
      vim.api.nvim_command('highlight! HintFloat guibg=NONE')
      vim.api.nvim_command('highlight! FloatBorder guifg=#aaaaaa guibg=NONE')

      -- Transparent Comments
      vim.api.nvim_command('highlight! Comment guifg=#888888 guibg=NONE')
    end,
  })
end

local hl_user_events = vim.api.nvim_create_augroup('hl_user_events', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = hl_user_events,
  callback = function()
    vim.api.nvim_command('highlight! WinSeparator guibg=NONE')
  end,
})

local yank_user_events = vim.api.nvim_create_augroup('yank_user_events', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_user_events,
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
  end,
})

-- Default Filetype Options
local function indent_size(size, use_spaces)
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

local filetype_user_events = vim.api.nvim_create_augroup('filetype_user_events', { clear = true })

-- Use 4 space indents for the following filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = filetype_user_events,
  pattern = { 'php', 'blade', 'html' },
  callback = function()
    indent_size(4, true)
  end,
})

-- Use 2 space indents for the following filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = filetype_user_events,
  pattern = {
    'vim',
    'lua',
    'scss',
    'sass',
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
    'vue',
  },
  callback = function()
    indent_size(2, true)
  end,
})

-- Enable spell check, 2 space indents in markdown files
vim.api.nvim_create_autocmd('FileType', {
  group = filetype_user_events,
  pattern = 'markdown',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.bo[bufnr].spell = true
    indent_size(2, true)
  end,
})

-- =============================================================================
-- = Options (OPT) =
-- =============================================================================

if vim.fn.isdirectory(user.config.undodir) == 0 then
  vim.cmd(string.format('silent !mkdir -p %s', user.config.undodir))
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
vim.opt.undodir = user.config.undodir
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
vim.opt.laststatus = 3
vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:block', 'r-cr-o:hor20' }
vim.opt.termguicolors = true
vim.opt.number = true

-- =============================================================================
-- = Keybindings (KEY) =
-- =============================================================================

-- Unbind default bindings for arrow keys, trust me this is for your own good
vim.keymap.set('', '<Up>', '')
vim.keymap.set('', '<Down>', '')
vim.keymap.set('', '<Left>', '')
vim.keymap.set('', '<Right>', '')
vim.keymap.set('i', '<Up>', '')
vim.keymap.set('i', '<Down>', '')
vim.keymap.set('i', '<Left>', '')
vim.keymap.set('i', '<Right>', '')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
vim.keymap.set('n', '<Up>', '<Cmd>resize +2<CR>')
vim.keymap.set('n', '<Down>', '<Cmd>resize -2<CR>')
vim.keymap.set('n', '<Left>', '<Cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<Right>', '<Cmd>vertical resize +2<CR>')

-- Map Esc, to perform quick switching between Normal and Insert mode
vim.keymap.set('i', 'jk', '<Esc>')

-- Map escape from terminal input to Normal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]])

-- Disable highlights
vim.keymap.set('n', '<Leader><CR>', '<Cmd>noh<CR>')

-- List all buffers
vim.keymap.set('n', '<Leader>bl', '<Cmd>buffers<CR>')

vim.keymap.set('n', '<C-l>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<Leader>bn', '<Cmd>bnext<CR>')

vim.keymap.set('n', '<C-h>', '<Cmd>bprevious<CR>')
vim.keymap.set('n', '<Leader>bp', '<Cmd>bprevious<CR>')

-- Close the current buffer, and more?
vim.keymap.set('n', '<Leader>bd', '<Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>')
-- Close all buffer, except current
vim.keymap.set('n', '<Leader>bx', '<Cmd>%bd<Bar>e#<Bar>bd#<CR>')

-- Move a line of text Alt+[j/k]
vim.keymap.set('n', '<M-j>', [[mz:m+<CR>`z]])
vim.keymap.set('n', '<M-k>', [[mz:m-2<CR>`z]])
vim.keymap.set('v', '<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
vim.keymap.set('v', '<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Edit vimrc
vim.keymap.set('n', '<Leader>ve', '<Cmd>edit $MYVIMRC<CR>')

-- Source the vimrc to reflect changes
vim.keymap.set('n', '<Leader>vs', '<Cmd>ConfigReload<CR>')

-- Reload file
vim.keymap.set('n', '<Leader>r', '<Cmd>edit!<CR>')

-- Copy/Paste from clipboard
vim.keymap.set('v', '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>p', [["+p]])

-- Disable Ex-mode
vim.keymap.set('n', 'Q', '')

-- =============================================================================
-- = User Commands (CMD) =
-- =============================================================================

-- Access Todo files
vim.api.nvim_create_user_command('MyTodoPersonal', 'edit ~/todofiles/personal/README.md', {})
vim.api.nvim_create_user_command('MyTodoWork', 'edit ~/todofiles/work/README.md', {})

-- Open/reload config
vim.api.nvim_create_user_command('Config', string.format('edit ~/.config/%s/init.lua', vim.g.userspace), {})
vim.api.nvim_create_user_command(
  'ConfigReload',
  string.format('so ~/.config/%s/init.lua | nohlsearch', vim.g.userspace),
  {}
)

---Toggle conceal level of local buffer
---which is enabled by some syntax plugin
---@return nil
local function toggle_conceal()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].conceallevel == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

vim.api.nvim_create_user_command('ToggleConcealLevel', toggle_conceal, {})

---Toggle the view of the editor, for taking screenshots
---or for copying code from the editor w/o using "+ register
---when not accessible, eg from a remote ssh
---@return nil
local function toggle_codeshot()
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].number then
    vim.wo[win].number = false
    vim.wo[win].signcolumn = 'no'
  else
    vim.wo[win].number = true
    vim.wo[win].signcolumn = 'yes'
  end
end

vim.api.nvim_create_user_command('ToggleCodeshot', toggle_codeshot, {})

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

local emmet_user_events = vim.api.nvim_create_augroup('emmet_user_events', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = emmet_user_events,
  pattern = { 'html', 'blade', 'php', 'vue', 'javascriptreact', 'typescriptreact' },
  command = 'EmmetInstall',
})

-- indentLine Config
-- ---
vim.g.indentLine_char = '│'

-- vim-json Config
-- ---
vim.g.vim_json_syntax_conceal = 0
vim.g.vim_json_conceal = 0

-- lir.nvim Config
-- ---
local lir_user_events = vim.api.nvim_create_augroup('lir_user_events', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = lir_user_events,
  command = 'highlight! default link CursorLine Visual',
})

-- =============================================================================
-- = Plugin Manager (PLUG) =
-- =============================================================================

local plugins = {
  -- Self-maintenance
  { 'savq/paq-nvim', opt = true },

  -- Dependencies
  'Shougo/context_filetype.vim',
  'kyazdani42/nvim-web-devicons',
  'lambdalisue/nerdfont.vim',
  'nvim-lua/plenary.nvim',
  'vim-denops/denops.vim',

  -- Core
  'creativenull/projectlocal-vim',
  'kevinhwang91/nvim-bqf',
  'numToStr/Comment.nvim',
  'tpope/vim-abolish',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'windwp/nvim-autopairs',

  -- File Explorer
  'tamago324/lir.nvim',

  -- Linters + Formatters + LSP Client
  'creativenull/diagnosticls-configs-nvim',
  'creativenull/efmls-configs-nvim',
  'neovim/nvim-lspconfig',

  -- Snippet Engine + Presets
  'hrsh7th/vim-vsnip',
  'mattn/emmet-vim',
  'rafamadriz/friendly-snippets',

  -- AutoCompletion + Sources
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-vsnip',
  'onsails/lspkind-nvim',

  -- Fuzzy File/Code Finder
  'nvim-telescope/telescope.nvim',

  -- Git
  'lewis6991/gitsigns.nvim',

  -- UI
  'akinsho/bufferline.nvim',
  'code-biscuits/nvim-biscuits',
  'folke/todo-comments.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'norcalli/nvim-colorizer.lua',
  'nvim-lualine/lualine.nvim',

  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-refactor',

  -- Colorschemes
  'bluz71/vim-nightfly-guicolors',
  'bluz71/vim-moonfly-colors',
  'fnune/base16-vim',
}

local pluginmanager = {
  git = 'https://github.com/savq/paq-nvim.git',
  install_dir = string.format('%s/site/pack/paq/opt/paq-nvim', user.config.data_dir),
  is_firsttime = false,

  -- Options to pass to the plugin manager
  init_opts = {
    path = string.format('%s/site/pack/paq/', user.config.data_dir),
  },
}

-- Install plugin manager if not installed, only for new machine
-- or first time load
if vim.fn.isdirectory(pluginmanager.install_dir) == 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', pluginmanager.git, pluginmanager.install_dir })
  pluginmanager.is_firsttime = true
end

vim.cmd('packadd paq-nvim')
local paq = require('paq')

paq:setup(pluginmanager.init_opts)(plugins)

-- On the first run in new machine, install all plugins and then exit
if pluginmanager.is_firsttime then
  vim.api.nvim_create_autocmd('User PaqDoneInstall', { command = 'quitall' })
  paq.install()
end

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

-- Comment.nvim Config
-- ---
local function comment_config()
  require('Comment').setup()
end

pcall(comment_config)

-- nvim-lspconfig Config
-- ---
pcall(require, 'user.lsp')

-- autocompletion Config
-- ---
pcall(require, 'user.autocompletion')

-- vim.keymap.set(
--   'i',
--   '<C-y>',
--   [[pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"]],
--   { silent = true, expr = true }
-- )
--
-- vim.keymap.set('i', '<C-Space>', [[ddc#map#manual_complete()]], {
--   silent = true,
--   expr = true,
--   noremap = true,
-- })

-- Snippets
vim.keymap.set({ 'i', 's' }, '<C-j>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<C-j>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true,
})

vim.keymap.set({ 'i', 's' }, '<C-k>', [[vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<C-k>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true,
})

-- nvim-autopairs Config
-- ---
local function autopairs_config()
  require('nvim-autopairs').setup()
end

pcall(autopairs_config)

-- gitsigns.nvim Config
-- ---
local function gitsigns_config()
  require('gitsigns').setup()
end

pcall(gitsigns_config)

-- todo-comments.nvim Config
-- ---
local function todocomments_config()
  require('todo-comments').setup()
end

pcall(todocomments_config)

-- telescope.nvim Config
pcall(require, 'user.finder')

if user.transparent then
  local telescope_user_events = vim.api.nvim_create_augroup('telescope_user_events', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = telescope_user_events,
    command = 'highlight! TelescopeBorder guifg=#aaaaaa',
  })
end

-- nvim-treesitter Config
pcall(require, 'user.treesitter')

-- nvim-biscuits Config
-- ---
pcall(require, 'user.biscuits')

vim.keymap.set('n', '<Leader>it', [[<Cmd>lua require('nvim-biscuits').toggle_biscuits()<CR>]])

-- lualine.nvim Config
-- ---
pcall(require, 'user.statusline')

-- indent-blankline.nvim Config
-- ---
local indent_blankline_user_events = vim.api.nvim_create_augroup('indent_blankline_user_events', { clear = true })

if user.transparent then
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indent_blankline_user_events,
    command = 'highlight! IndentBlanklineHighlight guifg=#777777 guibg=NONE',
  })
else
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indent_blankline_user_events,
    command = 'highlight! IndentBlanklineHighlight guifg=#444444 guibg=NONE',
  })
end

pcall(require, 'user.indent_blankline')

-- bufferline.lua Config
-- ---
pcall(require, 'user.bufferline')

-- lir.nvim Config
-- ---
pcall(require, 'user.explorer')

-- colorizer.lua Config
-- ---
pcall(require, 'user.colorizer')

-- =============================================================================
-- = UI/Theme =
-- =============================================================================

-- moonfly Config
-- ---
vim.g.moonflyNormalFloat = 1

pcall(vim.cmd, 'colorscheme base16-horizon-terminal-dark')
