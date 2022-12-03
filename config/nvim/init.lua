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

-- Enable treesitter highlights provided by nvim core
if vim.fn.has('nvim-0.8') == 1 then
  vim.g.ts_highlight_lua = true
end

-- Ensure the following tools are installed in the system
local required_execs = { 'git', 'curl', 'rg', 'deno' }
local optional_execs = { 'python3', 'stylua', 'luacheck' }

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

-- Windows specific settings
if vim.fn.has('win32') == 1 then
  if vim.fn.executable('pwsh') == 0 then
    local errmsg = debug.traceback('[nvim] PowerShell Core >= v6 is required on Windows!')
    vim.api.nvim_echo({ { errmsg, 'ErrorMsg' } }, true, {})
    return
  end

  local pwsh_flags = {
    '-NoLogo',
    '-NoProfile',
    '-ExecutionPolicy',
    'RemoteSigned',
    '-Command',
    '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  }

  vim.opt.shellcmdflag = table.concat(pwsh_flags, ' ')
  vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.opt.shell = 'pwsh'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
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
  if vim.fn.has('win32') == 1 then
    vim.cmd(string.format('silent !mkdir -Recurse %s', vim.g.user.config.undodir))
  else
    vim.cmd(string.format('silent !mkdir -p %s', vim.g.user.config.undodir))
  end
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
vim.opt.showtabline = 2
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.laststatus = 3

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

-- Go to next buffer
vim.keymap.set('n', '<C-l>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<Leader>bn', '<Cmd>bnext<CR>')

-- Go to previous buffer
vim.keymap.set('n', '<C-h>', '<Cmd>bprevious<CR>')
vim.keymap.set('n', '<Leader>bp', '<Cmd>bprevious<CR>')

-- Close the current buffer, and more?
vim.keymap.set('n', '<Leader>bd', '<Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>')

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
    'html',
    'vue',
    'astro',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'php',
    'blade',
    'twig',
    'html.twig',
    'htmldjango.twig',
    'xml.twig',
  },
  command = 'EmmetInstall',
  desc = 'Enable emmet for the listed filetypes',
})

-- indentLine Config
-- ---
vim.g.indentLine_fileTypeExclude = { 'help', 'fzf', 'fern' }
vim.g.indentLine_char = '│'

if vim.g.user.transparent then
  vim.g.indentLine_color_gui = '#333333'
end

-- fern.vim Config
-- ---
vim.g['fern#hide_cursor'] = 1
vim.g['fern#default_hidden'] = 1
-- vim.g['fern#renderer'] = 'nerdfont'
-- vim.g['fern#renderer#nerdfont#leading'] = '  '
vim.g['fern#renderer#default#root_symbol'] = ' @@ '
vim.g['fern#renderer#default#leaf_symbol'] = ' '
vim.g['fern#renderer#default#collapsed_symbol'] = ' + '
vim.g['fern#renderer#default#expanded_symbol'] = ' - '
vim.g['fern#renderer#default#leading'] = '  '

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
  local branch = vim.call('gitbranch#name')
  local cmd = string.format('Gin push origin %s', branch)
  print(cmd)
  vim.cmd(cmd)
end

-- Pull from git repo, notify user since this is async
gin.pull_origin = function()
  local branch = vim.call('gitbranch#name')
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
vim.keymap.set('n', '<Leader>gc', '<Cmd>Gin commit<CR>')

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

local function ensure_jetpack()
  -- nvim + Lua
  local fn = vim.fn
  local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
  local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  if fn.filereadable(jetpackfile) == 0 then
    print('Downloading plugin manager')
    fn.system({ 'curl', '-fsSLo', jetpackfile, '--create-dirs', jetpackurl })
    vim.cmd('source ' .. jetpackfile)
    return true
  end

  return false
end

local plugins_empty = ensure_jetpack()

vim.cmd('packadd vim-jetpack')
local jetpack = require('jetpack')
local jetpack_packer = require('jetpack.packer')
jetpack_packer.startup(function(use)
  use({ 'tani/vim-jetpack', opt = 1 })

  -- Deps
  -- ---
  use({ 'vim-denops/denops.vim', tag = 'v3.2.0' })
  use({ 'lambdalisue/nerdfont.vim', tag = 'v1.3.0' })
  use({ 'nvim-lua/plenary.nvim', commit = '4b7e52044bbb84242158d977a50c4cbcd85070c7' })

  -- Core
  -- ---
  use({ 'cohama/lexima.vim', commit = 'fbc05de53ca98b7f36a82f566db1df49864e58ef' })
  use({ 'creativenull/projectlocal-vim', tag = 'v0.4.3' })
  use({ 'editorconfig/editorconfig-vim', commit = 'd354117b72b3b43b75a29b8e816c0f91af10efe9' })
  use({ 'godlygeek/tabular', commit = '339091ac4dd1f17e225fe7d57b48aff55f99b23a' })
  use({ 'mattn/emmet-vim', commit = 'def5d57a1ae5afb1b96ebe83c4652d1c03640f4d' })
  use({ 'tpope/vim-abolish', tag = 'v1.1' })
  use({ 'tpope/vim-endwise', commit = '4e5c8358d751625bb040b187b9fe430c2b769f0a' })
  use({ 'tpope/vim-repeat', commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a' })
  use({ 'tpope/vim-surround', tag = 'v2.2' })
  use({ 'numToStr/Comment.nvim', commit = 'ad7ffa8ed2279f1c8a90212c7d3851f9b783a3d6' })
  -- use('Shougo/context_filetype.vim', { commit = '28768168261bca161c3f2599e0ed63c96aab6dea' })
  -- use('tyru/caw.vim', { commit = '3aefcb5a752a599a9200dd801d6bcb0b7606bf29' })

  -- File Explorer + Addons
  -- ---
  use({ 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' })
  use({ 'lambdalisue/fern.vim', tag = 'v1.51.1' })
  use({ 'lambdalisue/fern-renderer-nerdfont.vim', commit = '1a3719f226edc27e7241da7cda4bc4d4c7db889c' })

  -- Linters + Formatters
  -- ---
  use({ 'dense-analysis/ale', commit = '4b433e5693ccec8e408504c4b139b8f7cc6a4aa3' })
  use({ 'creativenull/nvim-ale-diagnostic', branch = 'v2' })

  -- Builtin LSP Configs
  -- ---
  use({ 'neovim/nvim-lspconfig', commit = 'a2817c9d9500079a0340286a88653b41707a92eb' })
  use({ 'creativenull/efmls-configs-nvim', tag = 'v0.1.3' })
  use({ 'creativenull/diagnosticls-configs-nvim', tag = 'v0.1.8' })
  use({ 'jose-elias-alvarez/null-ls.nvim', commit = 'c51978f546a86a653f4a492b86313f4616412cec' })
  use({ 'j-hui/fidget.nvim', commit = '44585a0c0085765195e6961c15529ba6c5a2a13b' })

  -- AutoCompletion + Sources (ddc.vim)
  -- ---
  use({ 'Shougo/ddc.vim', tag = 'v3.3.0' })
  use({ 'Shougo/pum.vim', commit = '31aae8d39061bcdae755e468e83a3a70b72a0fce' })
  use({ 'Shougo/ddc-ui-pum', commit = '82c646416d8653988e56b27e68256f01d02f7b1c' })
  use({ 'matsui54/denops-signature_help', commit = 'f5c6a5a571a1cc00a82245690ada0d5c13903d2f' })
  use({ 'tani/ddc-fuzzy', commit = '18a8008fd2653eadd00590311d250347abc7a9de' })
  use({ 'matsui54/ddc-buffer', commit = 'e417e47964788b0211c80252757531f7a3881178' })
  use({ 'Shougo/ddc-source-cmdline', commit = '6925e7a879ef598a8ddfde0a40c4d3324030535d' })
  use({ 'Shougo/ddc-source-around', commit = '4da913e4b82d303c2f690b39f2252038c7046221' })
  use({ 'Shougo/ddc-source-nvim-lsp', commit = '1795bfdbf0879054f3ca9f5ab7025ba68e0338c4' })
  -- use({ 'hrsh7th/vim-vsnip-integ', commit = '1cf89903f12777b90dd79eb4b3d7fbc0b9a254a1' })

  -- Snippet Engine + Presets
  -- ---
  -- use({ 'hrsh7th/vim-vsnip', commit = '6f873418c4dc601d8ad019a5906eddff5088de9b' })
  -- use({ 'rafamadriz/friendly-snippets', commit = '03f91a18022964d80a3f0413ed82cf1dbeba247f' })

  -- Fuzzy File/Code Finder
  -- ---
  use({ 'junegunn/fzf', tag = '0.34.0', run = 'call fzf#install()' })
  use({ 'junegunn/fzf.vim', commit = '9ceac718026fd39498d95ff04fa04d3e40c465d7' })

  -- Git
  -- ---
  use({ 'lambdalisue/gin.vim', tag = 'v0.2.1' })
  use({ 'itchyny/vim-gitbranch', commit = '1a8ba866f3eaf0194783b9f8573339d6ede8f1ed' })
  use({ 'lewis6991/gitsigns.nvim', branch = 'release' })

  -- UI/Aesthetics
  -- ---
  use({ 'lukas-reineke/indent-blankline.nvim', commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6' })
  use({ 'itchyny/lightline.vim', commit = 'b1e91b41f5028d65fa3d31a425ff21591d5d957f' })
  use({ 'mengelbrecht/lightline-bufferline', commit = '8b6e29e65e9711b75df289879186ff3888feed00' })

  -- TreeSitter
  -- ---
  use({
    'nvim-treesitter/nvim-treesitter',
    branch = 'v0.8.0',
    run = ':TSUpdate',
  })

  -- FileType Syntax
  -- ---
  use({
    'heavenshell/vim-jsdoc',
    commit = '71c98ed6eacb4f1c0b9e4950ef679eda6a651cdd',
    run = 'make install',
  })
  use({ 'jwalton512/vim-blade', commit = '9534101808cc320eef003129a40cab04b026a20c' })
  use({ 'lumiliet/vim-twig', commit = 'ad115512725bcc156f7f89b72ff563b9fa44933b' })
  use({ 'junegunn/vader.vim', commit = '6fff477431ac3191c69a3a5e5f187925466e275a' })
  use({ 'MTDL9/vim-log-highlighting', commit = '1037e26f3120e6a6a2c0c33b14a84336dee2a78f' })

  -- Colorschemes
  -- ---
  use({ 'bluz71/vim-moonfly-colors', commit = 'fe16eed4e61cbc178e6bb2b7d77e868f8602505d' })
  use({ 'tinted-theming/base16-vim', commit = '3cdd12bca750e8c41a9e8912c142b45cd821c03e' })
  use({ 'olimorris/onedarkpro.nvim', commit = '5e25c890d35c588f00f186623c885b64d98b86f2' })
  use({ 'navarasu/onedark.nvim', commit = 'cad3d983e57f467ba8e8252b0567e96dde9a8f0d' })
  use({ 'rmehri01/onenord.nvim', commit = '0cd9f681bee019715bfbe928891579a3af3331e8' })
  use({ 'tiagovla/tokyodark.nvim', commit = '9e940a11935b61da2fc2a170adca7b67eebcdc45' })
  use({ 'catppuccin/nvim', commit = '0184121f9d6565610ddffa8284512b7643ee723e', as = 'catppuccin' })
  use({ 'Yagua/nebulous.nvim', commit = '9599c2da4d234b78506ce30c6544595fac25e9ca' })
end)

-- Instal if first time
if plugins_empty then
  require('jetpack').sync()
end

-- Auto-install plugins
for _, name in pairs(jetpack.names()) do
  if jetpack.tap(name) == 0 then
    jetpack.sync()
    break
  end
end

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

--- nvim-treesitter Config
-- ---
require('user.treesitter').setup()

-- nvim-lspconfig Config
-- ---
require('user.lsp').setup()

-- fidget.nvim Config
-- ---
require('fidget').setup({})

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

-- lightline.vim Config
-- ---
require('user.lightline').setup()

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

-- onedark Config
-- ---
pcall(function()
  require('onedark').setup({ style = 'darker' })
end)

-- onedarkpro Config
-- ---
pcall(function()
  require('onedarkpro').setup({
    theme = 'onedark_dark',
    options = { transparency = true },
    highlights = {
      PmenuSel = { bg = '#333333' },
    },
    plugins = {
      all = false,
      gitsigns = true,
      treesitter = true,
    },
  })
end)

-- onenord Config
-- ---
pcall(function()
  require('onenord').setup({
    fade_nc = true,
    custom_colors = {
      NormalFloat = { bg = 'NONE' },
    },
  })
end)

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

-- nebulous Config
-- ---
pcall(function()
  require('nebulous').setup({
    variant = 'night',
    italic = {
      comments = true,
    },
    custom_colors = {
      NormalFloat = { bg = 'NONE' },
    },
  })
end)

pcall(vim.cmd, 'colorscheme moonfly')
