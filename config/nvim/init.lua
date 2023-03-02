-- Name: Arnold Chand
-- Github: https://github.com/creativenull
-- Description: My vimrc works with MacOS, Linux and Windows.
-- Requires:
--   + curl
--   + git
--   + python3
--   + ripgrep
-- =============================================================================
-- = Initialize =
-- =============================================================================

-- Pre-checks
-- ---
if vim.fn.has('nvim-0.7') == 0 then
  local errmsg = debug.traceback('This config requires nvim >= 0.7')
  vim.api.nvim_echo({ { errmsg, 'ErrorMsg' } }, true, {})
  return
end

-- User Config
-- ---
vim.g.user = {
  leaderkey = ' ',
  transparent = false,
  event = 'UserGroup',
  config = {
    undodir = vim.fn.stdpath('cache') .. '/undo',
  },
}

-- Global user group to register other custom autocmds
vim.api.nvim_create_augroup(vim.g.user.event, {})

-- Ensure the following tools are installed in the system
local required_execs = { 'git', 'curl', 'rg', 'fzf', 'deno' }
local optional_execs = { 'python3', 'stylua' }

for _, exec in pairs(required_execs) do
  if vim.fn.executable(exec) == 0 then
    local errmsg = debug.traceback(string.format('[nvim] `%s` is needed!', exec))
    vim.api.nvim_echo({ { errmsg, 'ErrorMsg' } }, true, {})
    return
  end
end

for _, exec in pairs(optional_execs) do
  if vim.fn.executable(exec) == 0 then
    vim.api.nvim_echo({ { string.format('[nvim] `%s` not found, but optional', exec), 'WarningMsg' } }, true, {})
  end
end

-- leader and providers settings
vim.g.mapleader = vim.g.user.leaderkey
vim.g.python3_host_prog = vim.fn.exepath('python3')
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- =============================================================================
-- = Events (AUG) =
-- =============================================================================

-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.g.user.event,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = {
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'scss',
    'sass',
    'css',
    'typescript',
    'typescriptreact',
    'vim',
    'lua',
  },
  callback = function()
    require('user.utils').indent_size(2, true)
  end,
  desc = 'Set code indents',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = { 'markdown', 'php', 'blade', 'html' },
  callback = function()
    require('user.utils').indent_size(4, true)
    vim.opt.iskeyword:append('-')
  end,
  desc = 'Set code indents',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = { 'vue' },
  callback = function()
    require('user.utils').indent_size(2, true)
    vim.opt.iskeyword:append('-')
  end,
  desc = 'Set code indents',
})

-- =============================================================================
-- = Options (OPT) =
-- =============================================================================

if vim.fn.isdirectory(vim.g.user.config.undodir) == 0 then
  local cmd = { 'mkdir' }

  if vim.fn.has('win32') == 1 and vim.opt.shell:get() == 'pwsh' or vim.opt.shell:get() == 'powershell' then
    table.insert(cmd, '-Recurse')
  else
    table.insert(cmd, '-p')
  end

  table.insert(cmd, vim.g.user.config.undodir)

  vim.fn.system(cmd)
end

-- Completion
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.shortmess:append('c')

-- Search
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.path = { '**' }
vim.opt.wildignore = { '*.git/*', '*node_modules/*', '*vendor/*', '*dist/*', '*build/*' }

-- Editor
vim.opt.colorcolumn = '120'
vim.opt.expandtab = true
vim.opt.lazyredraw = true
vim.opt.foldenable = false
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.scrolloff = 1
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.wildignorecase = true

-- System
vim.opt.undodir = vim.g.user.config.undodir
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 500

if vim.fn.has('wsl') == 1 then
  vim.opt.mouse = ''
else
  vim.opt.mouse = 'nv'
end

-- UI
vim.opt.cmdheight = 2
vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:block', 'r-cr-o:hor20' }
vim.opt.number = true
vim.opt.showtabline = 0
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.laststatus = 3

-- =============================================================================
-- = Keybindings (KEY) =
-- =============================================================================

-- Unbind default bindings for arrow keys, trust me this is for your own good
vim.keymap.set({ 'n', 'i', 'v' }, '<Up>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<Down>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<Left>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<Right>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-h>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-j>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-k>', '')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-l>', '')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
vim.keymap.set('n', '<Up>', function()
  require('user.utils').resize_win_hor(2)
end, { desc = 'Resize window horizontally (inc)' })
vim.keymap.set('n', '<Down>', function()
  require('user.utils').resize_win_hor(-2)
end, { desc = 'Resize window horizontally (dec)' })
vim.keymap.set('n', '<Left>', function()
  require('user.utils').resize_win_vert(-2)
end, { desc = 'Resize window vertically (inc)' })
vim.keymap.set('n', '<Right>', function()
  require('user.utils').resize_win_vert(2)
end, { desc = 'Resize window vertically (dec)' })

-- Map Esc, to perform quick switching between Normal and Insert mode
vim.keymap.set('i', 'jk', '<Esc>')

-- Map escape from terminal input to Normal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]])

-- Disable highlights
vim.keymap.set('n', '<Leader><CR>', '<Cmd>noh<CR>')

-- List all buffers
-- vim.keymap.set('n', '<Leader>bl', '<Cmd>buffers<CR>')

-- Go to next buffer
-- vim.keymap.set('n', '<C-l>', '<Cmd>bnext<CR>')
-- vim.keymap.set('n', '<Leader>bn', '<Cmd>bnext<CR>')

-- Go to previous buffer
-- vim.keymap.set('n', '<C-h>', '<Cmd>bprevious<CR>')
-- vim.keymap.set('n', '<Leader>bp', '<Cmd>bprevious<CR>')

-- Close the current buffer, and more?
-- vim.keymap.set('n', '<Leader>bd', '<Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>')

-- Close all buffer, except current
vim.keymap.set('n', '<Leader>bx', '<Cmd>%bd<Bar>e#<Bar>bd#<CR>')

-- Move a line of text Alt+[j/k]
vim.keymap.set('n', '<M-j>', 'mz:m+<CR>`z')
vim.keymap.set('n', '<M-k>', 'mz:m-2<CR>`z')
vim.keymap.set('v', '<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
vim.keymap.set('v', '<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Edit vimrc
vim.keymap.set('n', '<Leader>ve', '<Cmd>edit $MYVIMRC<CR>')

-- Source the vimrc to reflect changes
vim.keymap.set('n', '<Leader>vs', '<Cmd>ConfigReload<CR>')

-- Reload file
vim.keymap.set('n', '<Leader>r', '<Cmd>edit!<CR>')

-- List all maps
vim.keymap.set('n', '<Leader>mn', '<Cmd>nmap<CR>')
vim.keymap.set('n', '<Leader>mv', '<Cmd>vmap<CR>')
vim.keymap.set('n', '<Leader>mi', '<Cmd>imap<CR>')
vim.keymap.set('n', '<Leader>mt', '<Cmd>tmap<CR>')
vim.keymap.set('n', '<Leader>mc', '<Cmd>cmap<CR>')

-- Copy/Paste from sytem clipboard
vim.keymap.set('v', 'p', [["_dP]])
vim.keymap.set('v', '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>p', [["+p]])

-- =============================================================================
-- = Commands (CMD) =
-- =============================================================================

vim.api.nvim_create_user_command('Config', 'edit $MYVIMRC', { desc = 'Open init.lua' })

vim.api.nvim_create_user_command('ConfigReload', function()
  require('user.utils').reload_config()
end, { desc = 'Reload vim config' })

vim.api.nvim_create_user_command('ToggleConcealLevel', function()
  require('user.utils').toggle_conceal_level()
end, { desc = 'Toggle the conceals in editor' })

vim.api.nvim_create_user_command('ToggleCodeshot', function()
  require('user.utils').toggle_codeshot()
end, { desc = 'Toggle features to enable copying from terminal' })

vim.api.nvim_create_user_command('MyTodoPersonal', 'edit ~/todofiles/personal/README.md', {})
vim.api.nvim_create_user_command('MyTodoWork', 'edit ~/todofiles/work/README.md', {})

-- Command Abbreviations, I can't release my shift key fast enough 😭
vim.cmd('cnoreabbrev Q  q')
vim.cmd('cnoreabbrev Qa qa')
vim.cmd('cnoreabbrev W  w')
vim.cmd('cnoreabbrev Wq wq')

-- =============================================================================
-- = Plugin Pre-Config - before loading plugins (PRE) =
-- =============================================================================

-- Built-in plugins
-- ---
vim.g.vim_json_conceal = 0
vim.g.vim_markdown_conceal = 0

-- vim-vsnip Config
-- ---
-- require('user.vsnip').setup()

-- vim-vue Config
-- ---
vim.g.vue_pre_processors = { 'typescript' }

-- emmet-vim Config
-- ---
vim.g.user_emmet_leader_key = '<C-q>'
vim.g.user_emmet_mode = 'i'
vim.g.user_emmet_install_global = 0

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = {
    'astro',
    'blade',
    'html',
    'html.twig',
    'htmldjango.twig',
    'javascript',
    'javascriptreact',
    'php',
    'svelte',
    'twig',
    'typescript',
    'typescriptreact',
    'vue',
    'xml.twig',
  },
  command = 'EmmetInstall',
  desc = 'Enable emmet for the listed filetypes',
})

-- indentLine Config
-- ---
vim.g.indentLine_fileTypeExclude = { 'help', 'fzf', 'fern' }
vim.g.indentLine_char = '│'

vim.g.indentLine_color_gui = '#333333'

-- fern.vim Config
-- ---
vim.g['fern#hide_cursor'] = 1
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#renderer#nerdfont#root_symbol'] = ' '
vim.g['fern#renderer#nerdfont#indent_markers'] = 1

vim.keymap.set('n', '<Leader>ff', '<Cmd>Fern . -reveal=%<CR>')

local function init_fern(event_args)
  vim.keymap.set('n', 'q', '<Cmd>bd<CR>', { buffer = event_args.buf, desc = 'Exit fern buffer' })
  vim.keymap.set(
    'n',
    'D',
    '<Plug>(fern-action-remove)',
    { remap = true, buffer = event_args.buf, desc = 'Delete file from the directory' }
  )

  vim.bo[event_args.buf].expandtab = true
  vim.bo[event_args.buf].shiftwidth = 2
  vim.bo[event_args.buf].tabstop = 2

  vim.call('glyph_palette#apply')
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = 'fern',
  callback = init_fern,
  desc = 'Set custom fern keymaps',
})

-- Custom cursorline color for fern
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.g.user.event,
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorLine', {})
    vim.api.nvim_set_hl(0, 'CursorLine', { link = 'Visual', default = true })
  end,
  desc = 'Set custom line highlight in fern',
})

-- gin.vim Config
-- ---
local gin = {}

-- Push from git repo, notify user since this is async
gin.push_origin = function()
  -- local branch = vim.call('gitbranch#name')
  local branch = vim.g.gitsigns_head
  local cmd = string.format('Gin push origin %s', branch)
  print(cmd)
  vim.cmd(cmd)
end

-- Pull from git repo, notify user since this is async
gin.pull_origin = function()
  -- local branch = vim.call('gitbranch#name')
  local branch = vim.g.gitsigns_head
  local cmd = string.format('Gin pull origin %s', branch)
  print(cmd)
  vim.cmd(cmd)
end

vim.keymap.set('n', '<Leader>gs', '<Cmd>GinStatus<CR>')
vim.keymap.set('n', '<Leader>gp', gin.push_origin, { desc = 'Git push to origin from default branch' })
vim.keymap.set('n', '<Leader>gpp', ':Gin push origin ')
vim.keymap.set('n', '<Leader>gl', gin.pull_origin, { desc = 'Git pull from origin from default branch' })
vim.keymap.set('n', '<Leader>gll', ':Gin pull origin ')
vim.keymap.set('n', '<Leader>gb', '<Cmd>GinBranch<CR>')

-- vim-json Config
-- ---
vim.g.vim_json_syntax_conceal = 0

-- vim-javascript Config
-- ---
vim.g.javascript_plugin_jsdoc = 1

-- lexima Config
-- ---
vim.g.lexima_enable_endwise_rules = 0
vim.g.lexima_enable_newline_rules = 0

-- =============================================================================
-- = Plugin Manager (PLUG) =
-- =============================================================================

local function ensure_plug()
  local data_dir = vim.fn.stdpath('data') .. '/site'

  if vim.fn.empty(vim.fn.glob(data_dir .. '/autoload/plug.vim')) == 1 then
    print('Installing plugin manager')

    vim.fn.system({
      'curl',
      '-fLo',
      data_dir .. '/autoload/plug.vim',
      '--create-dirs',
      'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
    })

    vim.cmd('quit')
  end
end

ensure_plug()
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Deps
-- ---
Plug('vim-denops/denops.vim')
Plug('lambdalisue/nerdfont.vim')
Plug('nvim-lua/plenary.nvim')
Plug('lambdalisue/glyph-palette.vim')

-- Core
-- ---
Plug('creativenull/projectlocal-vim', { tag = 'v0.5.0' })
Plug('cohama/lexima.vim')
Plug('editorconfig/editorconfig-vim')
Plug('godlygeek/tabular')
Plug('mattn/emmet-vim')
Plug('tpope/vim-abolish')
Plug('tpope/vim-endwise')
Plug('tpope/vim-repeat')
Plug('tpope/vim-surround')
Plug('numToStr/Comment.nvim')
-- Plug('Shougo/context_filetype.vim', { commit = '28768168261bca161c3f2599e0ed63c96aab6dea' })
-- Plug('tyru/caw.vim', { commit = '3aefcb5a752a599a9200dd801d6bcb0b7606bf29' })

-- File Explorer + Addons
-- ---
Plug('antoinemadec/FixCursorHold.nvim')
Plug('lambdalisue/fern.vim')
Plug('lambdalisue/fern-renderer-nerdfont.vim')

-- Linters + Formatters
-- ---
Plug('dense-analysis/ale')

-- Builtin LSP Configs
-- ---
Plug('neovim/nvim-lspconfig', { commit = '95b7a69bc6da2a6a740584ea3c555e5327638b7d' })
Plug('j-hui/fidget.nvim', { commit = '44585a0c0085765195e6961c15529ba6c5a2a13b' })
Plug('creativenull/efmls-configs-nvim')
Plug('creativenull/diagnosticls-configs-nvim')
Plug('jose-elias-alvarez/null-ls.nvim')

-- AutoCompletion + Sources (ddc.vim)
-- ---
Plug('Shougo/ddc.vim')
Plug('Shougo/pum.vim')
Plug('Shougo/ddc-ui-pum')
Plug('matsui54/denops-signature_help')
Plug('tani/ddc-fuzzy')
Plug('matsui54/ddc-buffer')
Plug('Shougo/ddc-source-cmdline')
Plug('Shougo/ddc-source-around')
Plug('Shougo/ddc-source-nvim-lsp')
-- Plug('hrsh7th/vim-vsnip-integ')

-- Snippet Engine + Presets
-- ---
-- Plug('hrsh7th/vim-vsnip', { commit = '6f873418c4dc601d8ad019a5906eddff5088de9b' })
-- Plug('rafamadriz/friendly-snippets', { commit = '03f91a18022964d80a3f0413ed82cf1dbeba247f' })

-- Fuzzy File/Code Finder
-- ---
Plug('junegunn/fzf', { tag = '0.38.0' })
Plug('junegunn/fzf.vim', { commit = 'dc71692255b62d1f67dc55c8e51ab1aa467b1d46' })
Plug('vim-ctrlspace/vim-ctrlspace', { commit = '5e444c6af06de58d5ed7d7bd0dcbb958f292cd2e' })

-- Git
-- ---
Plug('lambdalisue/gin.vim', { tag = 'v0.2.1' })
Plug('lewis6991/gitsigns.nvim', { tag = 'v0.6' })

-- UI/Aesthetics
-- ---
Plug('lukas-reineke/indent-blankline.nvim', { commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6' })
Plug('feline-nvim/feline.nvim', { commit = 'd48b6f92c6ccdd6654c956f437be49ea160b5b0c' })
Plug('creativenull/feline-provider-ale.nvim')

-- TreeSitter
-- ---
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- FileType Syntax
-- ---
Plug('heavenshell/vim-jsdoc', { commit = '71c98ed6eacb4f1c0b9e4950ef679eda6a651cdd', ['do'] = 'make install' })
Plug('jwalton512/vim-blade', { commit = '9534101808cc320eef003129a40cab04b026a20c' })
Plug('lumiliet/vim-twig', { commit = 'ad115512725bcc156f7f89b72ff563b9fa44933b' })
Plug('junegunn/vader.vim', { commit = '6fff477431ac3191c69a3a5e5f187925466e275a' })
Plug('MTDL9/vim-log-highlighting', { commit = '1037e26f3120e6a6a2c0c33b14a84336dee2a78f' })

-- Colorschemes
-- ---
Plug('bluz71/vim-moonfly-colors', { commit = 'fe16eed4e61cbc178e6bb2b7d77e868f8602505d' })
Plug('tinted-theming/base16-vim', { commit = '3cdd12bca750e8c41a9e8912c142b45cd821c03e' })
Plug('folke/tokyonight.nvim', { commit = '95c88be515550bd519ffe54eeaa2df5b9af62cc5' })
Plug('catppuccin/nvim', { commit = '0184121f9d6565610ddffa8284512b7643ee723e', as = 'catppuccin' })
Plug('bluz71/vim-nightfly-colors', { commit = '3ca232533b2bd58cc486552e9f4a9da7f7458bdd' })

vim.call('plug#end')

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

-- vim-ctrlspace Config
-- ---
vim.g.CtrlSpaceDefaultMappingKey = '<C-space> '
vim.g.CtrlSpaceSymbols = { File = '', Tabs = '', BM = '' }
vim.g.CtrlSpaceSaveWorkspaceOnExit = 1

--- nvim-treesitter Config
-- ---
require('user.treesitter').setup()

-- nvim-lspconfig Config
-- ---
require('user.lsp').setup()

-- fidget.nvim Config
-- ---
require('user.fidget').setup()

-- fzf.vim Config
-- ---
require('user.fzf').setup()

-- ddc.vim Config
-- ---
require('user.ddc').setup()

-- nvim-cmp Config
-- ---
-- require('user.cmp').setup()

-- ale Config
-- ---
require('user.ale').setup()

-- gitsigns.nvim Config
-- ---
require('gitsigns').setup()

-- Comment.nvim Config
-- ---
require('Comment').setup()

-- feline.nvim Config
-- ---
require('user.feline').setup()

-- =============================================================================
-- = Colorscheme =
-- =============================================================================

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.g.user.event,
  callback = function()
    -- Show different color in substitution mode aka `:substitute` / `:s`
    vim.api.nvim_set_hl(0, 'IncSearch', {})
    vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#103da5', fg = '#eeeeee' })

    -- Custom window separator line color
    vim.api.nvim_set_hl(0, 'WinSeparator', {})
    vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'NONE', fg = '#eeeeee' })
  end,
  desc = 'Custom user highlights',
})

-- moonfly Config
-- ---
vim.g.moonflyTransparent = 1
vim.g.moonflyNormalFloat = 1

-- nightfly Config
-- ---
vim.g.nightflyNormalFloat = 1

-- catppuccin Config
-- ---
pcall(function()
  vim.g.catppuccin_flavour = 'mocha'
  require('catppuccin').setup({
    custom_highlights = {
      NormalFloat = { bg = 'NONE' },
    },
  })
end)

-- tokyonight.nvim Config
-- ---
pcall(function()
  require('tokyonight').setup({
    style = 'night',
  })
end)

pcall(vim.cmd, 'colorscheme nightfly')
