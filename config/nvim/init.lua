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

-- User Config
-- ---
vim.g.user = {
  leaderkey = ' ',
  transparent = false,
  event = 'UserEvents',
  config = {
    undodir = vim.fn.stdpath('cache') .. '/undo',
  },
}

-- Global user group to register other custom autocmds
vim.api.nvim_create_augroup(vim.g.user.event, {})

-- TODO: remove once upgraded to 0.8
if vim.fn.has('nvim-0.8') == 0 then
  vim.g.do_filetype_lua = 1
end

-- Pre-checks
-- ---
if vim.fn.has('nvim-0.7') == 0 then
  local errmsg = debug.traceback('This config requires nvim >= 0.7')
  vim.api.nvim_echo({ { errmsg, 'ErrorMsg' } }, true, {})
  return
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

vim.api.nvim_create_user_command('Config', 'edit $MYVIMRC', {})
vim.api.nvim_create_user_command('ConfigReload', 'source $MYVIMRC | nohlsearch', {})

vim.api.nvim_create_user_command(
  'ToggleConcealLevel',
  require('user.utils').toggle_conceal_level,
  { desc = 'Toggle the conceals in editor' }
)
vim.api.nvim_create_user_command(
  'ToggleCodeshot',
  require('user.utils').toggle_codeshot,
  { desc = 'Toggle features to enable copying from terminal' }
)

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

-- vim-vsnip Config
-- ---
require('user.vsnip').setup()

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
vim.g.indentLine_fileTypeExclude = { 'help', 'fzf' }
vim.g.indentLine_char = '│'

if vim.g.user.transparent then
  vim.g.indentLine_color_gui = '#333333'
end

-- fern.vim Config
-- ---
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#hide_cursor'] = 1

vim.keymap.set('n', '<Leader>ff', '<Cmd>Fern . -reveal=%<CR>')

local function set_fern_keymaps(autocmd_args)
  local buf = autocmd_args.buf
  vim.keymap.set('n', 'q', '<Cmd>bd<CR>', { buffer = buf })
  vim.keymap.set('n', 'D', '<Plug>(fern-action-remove)', { remap = true, buffer = buf })
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.g.user.event,
  pattern = 'fern',
  callback = set_fern_keymaps,
  desc = 'Set custom fern keymaps',
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.g.user.event,
  callback = function()
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

local function packager_setup(packager)
  packager.add('kristijanhusak/vim-packager', { ['type'] = 'opt' })

  -- Deps
  -- ---
  packager.add('vim-denops/denops.vim', { tag = 'v3.2.0' })
  packager.add('lambdalisue/nerdfont.vim', { tag = 'v1.3.0' })
  packager.add('nvim-lua/plenary.nvim', { commit = '4b7e52044bbb84242158d977a50c4cbcd85070c7' })

  -- Core
  -- ---
  packager.add('Shougo/context_filetype.vim', { commit = '28768168261bca161c3f2599e0ed63c96aab6dea' })
  packager.add('cohama/lexima.vim', { commit = 'fbc05de53ca98b7f36a82f566db1df49864e58ef' })
  packager.add('creativenull/projectlocal-vim', { tag = 'v0.4.3' })
  packager.add('editorconfig/editorconfig-vim', { commit = 'd354117b72b3b43b75a29b8e816c0f91af10efe9' })
  packager.add('godlygeek/tabular', { commit = '339091ac4dd1f17e225fe7d57b48aff55f99b23a' })
  packager.add('mattn/emmet-vim', { commit = 'def5d57a1ae5afb1b96ebe83c4652d1c03640f4d' })
  packager.add('tpope/vim-abolish', { tag = 'v1.1' })
  packager.add('tpope/vim-endwise', { commit = '4e5c8358d751625bb040b187b9fe430c2b769f0a' })
  packager.add('tpope/vim-repeat', { commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a' })
  packager.add('tpope/vim-surround', { tag = 'v2.2' })
  packager.add('tyru/caw.vim', { commit = '3aefcb5a752a599a9200dd801d6bcb0b7606bf29' })

  -- File Explorer + Addons
  -- ---
  packager.add('antoinemadec/FixCursorHold.nvim', { commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' })
  packager.add('lambdalisue/fern.vim', { tag = 'v1.51.1' })
  packager.add('lambdalisue/fern-renderer-nerdfont.vim', { commit = '1a3719f226edc27e7241da7cda4bc4d4c7db889c' })

  -- Linters + Formatters
  -- ---
  packager.add('dense-analysis/ale', { tag = 'v3.2.0' })
  packager.add('creativenull/nvim-ale-diagnostic', { branch = 'v2' })

  -- Builtin LSP Configs
  -- ---
  packager.add('neovim/nvim-lspconfig')
  packager.add('creativenull/efmls-configs-nvim', { tag = 'v0.1.2', ['type'] = 'opt' })
  packager.add('creativenull/diagnosticls-configs-nvim', { tag = 'v0.1.7', ['type'] = 'opt' })
  packager.add('jose-elias-alvarez/null-ls.nvim', { commit = '643c67a296711ff40f1a4d1bec232fa20b179b90' })

  -- AutoCompletion + Sources
  -- ---
  packager.add('Shougo/ddc.vim', { tag = 'v2.5.1' })
  packager.add('matsui54/denops-signature_help', { commit = 'f77f9c9b578e425908e34875c58ae2134984acfa' })
  packager.add('tani/ddc-fuzzy', { commit = '3339deacff797cc23f79a45c5e72ba0eed0af119' })
  packager.add('Shougo/ddc-nvim-lsp', { commit = 'f0a34fa80fa80091c47b1c22b46a978b4f1dc221' })
  packager.add('Shougo/ddc-around', { commit = 'c30a1844509c424f2e59550db856dfb1bc0f24eb' })
  packager.add('matsui54/ddc-buffer', { commit = '9df18ccc37ed8dca6c1523b02ee510df480b9d3a' })
  packager.add('hrsh7th/vim-vsnip-integ', { commit = '64c2ed66406c58163cf81fb5e13ac2f9fcdfb52b' })

  -- AutoCompletion + Sources
  -- ---
  -- packager.add('hrsh7th/nvim-cmp')
  -- packager.add('hrsh7th/cmp-nvim-lsp')
  -- packager.add('hrsh7th/cmp-buffer')
  -- packager.add('hrsh7th/cmp-vsnip')
  -- packager.add('onsails/lspkind.nvim')

  -- Snippet Engine + Presets
  -- ---
  packager.add('hrsh7th/vim-vsnip', { commit = '8f199ef690ed26dcbb8973d9a6760d1332449ac9' })
  packager.add('rafamadriz/friendly-snippets', { commit = '22a99756492a340c161ab122b0ded90ab115a1b3' })

  -- Fuzzy File/Code Finder
  -- ---
  packager.add('junegunn/fzf', { tag = '0.34.0' })
  packager.add('junegunn/fzf.vim', { commit = '9ceac718026fd39498d95ff04fa04d3e40c465d7' })

  -- Git
  -- ---
  packager.add('lambdalisue/gin.vim', { tag = 'v0.2.1' })
  packager.add('itchyny/vim-gitbranch', { commit = '1a8ba866f3eaf0194783b9f8573339d6ede8f1ed' })
  packager.add('airblade/vim-gitgutter', { commit = 'f19b6203191d69de955d91467a5707959572119b' })

  -- UI/Aesthetics
  -- ---
  packager.add('Yggdroot/indentLine', { commit = 'd15d63bf9c4a74a02470d4bc8ecce53df13e3a75' })
  packager.add('itchyny/lightline.vim', { commit = 'b1e91b41f5028d65fa3d31a425ff21591d5d957f' })
  packager.add('mengelbrecht/lightline-bufferline', { commit = '8b6e29e65e9711b75df289879186ff3888feed00' })

  -- TreeSitter
  -- ---
  packager.add('nvim-treesitter/nvim-treesitter', {
    ['do'] = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  })

  -- FileType Syntax
  -- ---
  packager.add('pangloss/vim-javascript')
  packager.add('MaxMEllon/vim-jsx-pretty')
  packager.add('heavenshell/vim-jsdoc', { ['do'] = 'make install' })
  packager.add('posva/vim-vue')
  packager.add('jwalton512/vim-blade')
  packager.add('lumiliet/vim-twig')
  packager.add('elzr/vim-json')
  packager.add('kevinoid/vim-jsonc')
  packager.add('junegunn/vader.vim')
  packager.add('rajasegar/vim-astro')
  packager.add('MTDL9/vim-log-highlighting')

  -- Colorschemes
  -- ---
  packager.add('bluz71/vim-moonfly-colors')
  packager.add('fnune/base16-vim')
  packager.add('olimorris/onedarkpro.nvim')
end

local function packager_bootstrap()
  local manager = {
    git_url = 'https://github.com/kristijanhusak/vim-packager',
    local_path = string.format('%s/site/pack/packager/opt/vim-packager', vim.fn.stdpath('data')),
    config = {
      dir = string.format('%s/site/pack/packager', vim.fn.stdpath('data')),
    },
  }

  local is_first_time = false

  if vim.fn.isdirectory(manager.local_path) == 0 then
    print('Downloading plugin manager...')
    vim.fn.system({ 'git', 'clone', manager.git_url, manager.local_path })
    is_first_time = true
  end

  vim.cmd('packadd vim-packager')
  require('packager').setup(packager_setup, manager.config)

  if is_first_time then
    vim.cmd('PackagerInstall')
  end
end

packager_bootstrap()

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

--- nvim-treesitter Config
-- ---
require('user.treesitter').setup()

-- nvim-lspconfig Config
-- ---
require('user.lsp').setup()

-- fzf.vim Config
-- ---
require('user.fzf').setup()

-- pum.vim Config
-- ---
-- vim.g.enable_custom_pum = 1
-- require('user.pum').Setup()

-- ddc.vim Config
-- ---
require('user.ddc').setup()

-- nvim-cmp Config
-- ---
-- require('user.cmp').setup()

-- ale Config
-- ---
require('user.ale').setup()

-- lightline.vim Config
-- ---
require('user.lightline').setup()

-- =============================================================================
-- = Colorscheme =
-- =============================================================================

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.g.user.event,
  callback = function()
    -- Don't want any bold or underlines on the tabline
    -- vim.cmd('highlight Tabline gui=NONE')
    -- vim.api.nvim_set_hl(0, 'TabLine', { bold = false, underline = false, undercurl = false, italic = false })

    -- Show different color in substitution mode aka `:substitute` / `:s`
    -- vim.cmd('highlight IncSearch gui=NONE guibg=#103da5 guifg=#eeeeee')
    vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#103da5', fg = '#eeeeee' })

    -- Custom WinSeparator colors
    vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'NONE', fg = '#eeeeee' })
  end,
  desc = 'Custom user highlights',
})

-- moonfly Config
-- ---
vim.g.moonflyTransparent = 1
vim.g.moonflyNormalFloat = 1

-- onedarkpro Config
-- ---
pcall(function()
  require('onedarkpro').setup({ theme = 'onedark_dark' })
end)

pcall(vim.cmd, 'colorscheme onedarkpro')
