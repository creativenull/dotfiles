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
  config = {
    undodir = vim.fn.stdpath('cache') .. '/undo',
  },
}

-- Pre-checks
-- ---
if vim.fn.has('nvim') == 1 and vim.fn.has('nvim-0.7') == 0 then
  print('This config requires nvim >= 0.7')
  return
end

-- Ensure the following tools are installed in the system
local executables = { 'git', 'curl', 'python3', 'rg', 'deno' }

for _, exec in pairs(executables) do
  if vim.fn.executable(exec) == 0 then
    print(string.format('[nvim] `%s` is needed!', exec))

    return
  end
end

-- Windows specific settings
if vim.fn.has('win32') == 1 then
  if vim.fn.executable('pwsh') == 0 then
    print('[nvim] PowerShell Core >= v6 is required on Windows!')

    return
  end

  local pwshFlags = {
    '-NoLogo',
    '-NoProfile',
    '-ExecutionPolicy',
    'RemoteSigned',
    '-Command',
    '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  }

  vim.opt.shellcmdflag = table.concat(pwshFlags, ' ')
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

vim.api.nvim_create_augroup('UserFileTypeEvents', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserFileTypeEvents',
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
    require('user.utils').IndentSize(2, true)
  end,
  desc = 'Set code indents',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserFileTypeEvents',
  pattern = { 'markdown', 'php', 'blade', 'html' },
  callback = function()
    require('user.utils').IndentSize(4, true)
    vim.opt.iskeyword:append('-')
  end,
  desc = 'Set code indents',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserFileTypeEvents',
  pattern = { 'vue' },
  callback = function()
    require('user.utils').IndentSize(2, true)
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
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.shortmess:append('c')

-- Search
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.path = '**'
vim.opt.wildignore = '*.git/*,*node_modules/*,*vendor/*,*dist/*,*build/*'

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

if vim.fn.has('wsl') == 0 then
  vim.opt.mouse = 'nv'
end

-- UI
vim.opt.cmdheight = 2
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20'
vim.opt.number = true
vim.opt.showtabline = 2
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

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

-- Copy/Paste from clipboard
vim.keymap.set('v', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>p', '"+p')

-- =============================================================================
-- = Commands (CMD) =
-- =============================================================================

vim.api.nvim_create_user_command('Config', 'edit $MYVIMRC', {})
vim.api.nvim_create_user_command('ConfigReload', 'source $MYVIMRC | nohlsearch', {})

vim.api.nvim_create_user_command(
  'ToggleConcealLevel',
  require('user.utils').ToggleConcealLevel,
  { desc = 'Toggle the conceals in editor' }
)
vim.api.nvim_create_user_command(
  'ToggleCodeshot',
  require('user.utils').ToggleCodeshot,
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
vim.g.vsnip_extra_mapping = false
vim.g.vsnip_filetypes = {
  javascriptreact = { 'javascript' },
  typescriptreact = { 'typescript' },
}

vim.keymap.set('i', '<C-j>', [[vsnip#jumpable(1)  ? "\<Plug>(vsnip-jump-next)" : "\<C-j>"]], { expr = true })
vim.keymap.set('i', '<C-j>', [[vsnip#jumpable(1)  ? "\<Plug>(vsnip-jump-next)" : "\<C-j>"]], { expr = true })
vim.keymap.set('s', '<C-k>', [[vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<C-k>"]], { expr = true })
vim.keymap.set('s', '<C-k>', [[vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<C-k>"]], { expr = true })

-- vim-vue Config
-- ---
vim.g.vue_pre_processors = { 'typescript' }

-- emmet-vim Config
-- ---
vim.g.user_emmet_leader_key = '<C-q>'
vim.g.user_emmet_mode = 'i'
vim.g.user_emmet_install_global = 0

vim.api.nvim_create_augroup('UserEmmetEvents', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserEmmetEvents',
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

local function setFernKeymaps()
  local buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'q', '<Cmd>bd<CR>', { buffer = buf })
  vim.keymap.set('n', 'D', '<Plug>(fern-action-remove)', { remap = true })
end

vim.api.nvim_create_augroup('UserFernEvents', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserFernEvents',
  pattern = 'fern',
  callback = setFernKeymaps,
  desc = 'Set custom fern keymaps',
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'UserFernEvents',
  pattern = '*',
  command = 'highlight! default link CursorLine Visual',
  desc = 'Set custom line highlight in fern',
})

-- gin.vim Config
-- ---
-- Push from git repo, notify user since this is async
local function ginPushOrigin()
  local branch = vim.call('gitbranch#name')
  local cmd = string.format('Gin push origin %s', branch)
  print(cmd)
  vim.cmd(cmd)
end

-- Pull from git repo, notify user since this is async
local function ginPullOrigin()
  local branch = vim.call('gitbranch#name')
  local cmd = string.format('Gin pull origin %s', branch)
  print(cmd)
  vim.cmd(cmd)
end

vim.keymap.set('n', '<Leader>gs', '<Cmd>GinStatus<CR>')
vim.keymap.set('n', '<Leader>gp', ginPushOrigin, { desc = 'Git push to origin from default branch' })
vim.keymap.set('n', '<Leader>gpp', '<Cmd>call :Gin push origin ')
vim.keymap.set('n', '<Leader>gl', ginPullOrigin, { desc = 'Git pull from origin from default branch' })
vim.keymap.set('n', '<Leader>gll', '<Cmd>call :Gin pull origin ')
vim.keymap.set('n', '<Leader>gb', '<Cmd>GinBranch<CR>')
vim.keymap.set('n', '<Leader>gc', '<Cmd>Gin commit<CR>')

-- vim-json Config
-- ---
vim.g.vim_json_syntax_conceal = 0

-- vim-javascript Config
-- ---
vim.g.javascript_plugin_jsdoc = 1

-- =============================================================================
-- = Plugin Manager (PLUG) =
-- =============================================================================

local plugin = {
  plugUrl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
  plugFilepath = string.format('%s/site/autoload/plug.vim', vim.fn.stdpath('data')),
  pluginsDirpath = string.format('%s/plugged', vim.fn.stdpath('data')),
}

if vim.fn.filereadable(plugin.plugFilepath) == 0 then
  vim.cmd(string.format('!curl -fLo %s --create-dirs %s', plugin.plugFilepath, plugin.plugUrl))
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    command = 'PlugInstall --sync | source $MYVIMRC',
  })
end

vim.call('plug#begin', plugin.pluginsDirpath)

-- Deps
-- ---
vim.cmd([[ Plug 'vim-denops/denops.vim' ]])
vim.cmd([[ Plug 'lambdalisue/nerdfont.vim' ]])

-- Core
-- ---
vim.cmd([[ Plug 'cohama/lexima.vim', { 'commit': 'fbc05de53ca98b7f36a82f566db1df49864e58ef' } ]])
vim.cmd([[ Plug 'godlygeek/tabular', { 'commit': '339091ac4dd1f17e225fe7d57b48aff55f99b23a' } ]])
vim.cmd([[ Plug 'tpope/vim-surround', { 'tag': 'v2.2' } ]])
vim.cmd([[ Plug 'tpope/vim-abolish', { 'tag': 'v1.1' } ]])
vim.cmd([[ Plug 'tpope/vim-repeat', { 'commit': '24afe922e6a05891756ecf331f39a1f6743d3d5a' } ]])
vim.cmd([[ Plug 'Shougo/context_filetype.vim' ]])
vim.cmd([[ Plug 'tyru/caw.vim', { 'commit': '3aefcb5a752a599a9200dd801d6bcb0b7606bf29' } ]])
vim.cmd([[ Plug 'editorconfig/editorconfig-vim' ]])
vim.cmd([[ Plug 'mattn/emmet-vim' ]])
vim.cmd([[ Plug 'creativenull/projectlocal-vim', { 'tag': 'v0.4.3' } ]])

-- File Explorer + Addons
-- ---
vim.cmd([[ Plug 'antoinemadec/FixCursorHold.nvim' ]])
vim.cmd([[ Plug 'lambdalisue/fern.vim', { 'tag': 'v1.46.0' } ]])
vim.cmd([[ Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'commit': '1a3719f226edc27e7241da7cda4bc4d4c7db889c' } ]])

-- Linters + Formatters
-- ---
vim.cmd([[ Plug 'dense-analysis/ale' ]])

-- Builtin LSP Configs
-- ---
vim.cmd([[ Plug 'neovim/nvim-lspconfig' ]])
vim.cmd([[ Plug 'creativenull/nvim-ale-diagnostic', { 'branch': 'v2' } ]])

-- AutoCompletion + Sources
-- ---
vim.cmd([[ Plug 'Shougo/ddc.vim' ]])
vim.cmd([[ Plug 'matsui54/denops-signature_help' ]])
vim.cmd([[ Plug 'tani/ddc-fuzzy' ]])
vim.cmd([[ Plug 'Shougo/ddc-nvim-lsp' ]])
vim.cmd([[ Plug 'Shougo/ddc-around' ]])
vim.cmd([[ Plug 'matsui54/ddc-buffer' ]])
vim.cmd([[ Plug 'hrsh7th/vim-vsnip-integ' ]])

-- Snippet Engine + Presets
-- ---
vim.cmd([[ Plug 'hrsh7th/vim-vsnip' ]])
vim.cmd([[ Plug 'rafamadriz/friendly-snippets' ]])

-- Fuzzy File/Code Finder
-- ---
vim.cmd([[ Plug 'junegunn/fzf' ]])
vim.cmd([[ Plug 'junegunn/fzf.vim' ]])

-- Git
-- ---
vim.cmd([[ Plug 'lambdalisue/gin.vim' ]])
vim.cmd([[ Plug 'itchyny/vim-gitbranch' ]])
vim.cmd([[ Plug 'airblade/vim-gitgutter' ]])

-- FileType Syntax
-- ---
vim.cmd([[ Plug 'pangloss/vim-javascript' ]])
vim.cmd([[ Plug 'MaxMEllon/vim-jsx-pretty' ]])
vim.cmd([[ Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' } ]])
vim.cmd([[ Plug 'posva/vim-vue' ]])
vim.cmd([[ Plug 'jwalton512/vim-blade' ]])
vim.cmd([[ Plug 'lumiliet/vim-twig' ]])
vim.cmd([[ Plug 'elzr/vim-json' ]])
vim.cmd([[ Plug 'kevinoid/vim-jsonc' ]])
vim.cmd([[ Plug 'junegunn/vader.vim' ]])
vim.cmd([[ Plug 'rajasegar/vim-astro' ]])

-- UI/Aesthetics
-- ---
vim.cmd([[ Plug 'Yggdroot/indentLine' ]])
vim.cmd([[ Plug 'itchyny/lightline.vim' ]])
vim.cmd([[ Plug 'mengelbrecht/lightline-bufferline' ]])

-- Colorschemes
-- ---
vim.cmd([[ Plug 'bluz71/vim-nightfly-guicolors' ]])
vim.cmd([[ Plug 'bluz71/vim-moonfly-colors' ]])
vim.cmd([[ Plug 'gruvbox-community/gruvbox' ]])
vim.cmd([[ Plug 'fnune/base16-vim' ]])
vim.cmd([[ Plug 'rigellute/rigel' ]])

vim.call('plug#end')

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

-- nvim-lspconfig Config
-- ---
require('user.lsp')

-- fzf.vim Config
-- ---
require('user.fzf').Setup()

-- pum.vim Config
-- ---
-- vim.g.enable_custom_pum = 1
-- require('user.pum').Setup()

-- ddc.vim Config
-- ---
require('user.ddc').Setup()

-- ale Config
-- ---
require('user.ale').Setup()

-- lightline.vim Config
-- ---
require('user.lightline').Setup()

-- =============================================================================
-- = Colorscheme =
-- =============================================================================

-- moonfly Config
-- ---
vim.g.moonflyTransparent = 1
vim.g.moonflyNormalFloat = 1
vim.g.moonflyItalics = 0

vim.api.nvim_create_augroup('UserMoonflyEvents', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'UserMoonflyEvents',
  pattern = '*',
  command = 'highlight! ColorColumn guibg=#777777',
  desc = 'Set custom higlights for moonfly theme only',
})

-- gruvbox Config
-- ---
vim.g.gruvbox_bold = 0
vim.g.gruvbox_italic = 0
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_sign_column = 'bg0'

vim.cmd('colorscheme moonfly')
