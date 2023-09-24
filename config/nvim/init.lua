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
    'blade',
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'typescript',
    'typescriptreact',
    'vim',
    'vue',
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 0
    vim.opt_local.expandtab = true
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
vim.opt.expandtab = false
vim.opt.lazyredraw = true
vim.opt.foldenable = false
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.scrolloff = 1
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 8
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
vim.opt.conceallevel = 2
vim.opt.cmdheight = 2
vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:block', 'r-cr-o:hor20' }
vim.opt.number = true
vim.opt.showtabline = 0
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.title = true
vim.opt.titlestring = string.format('%s [nvim]', vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))

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

-- neural Config
-- ---
vim.g.neural = {
  ui = { prompt_icon = '>' },
  source = {
    openai = { api_key = vim.env.OPENAI_API_NEURAL_KEY },
  },
}

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
vim.g.user_emmet_mode = 'in'
vim.keymap.set('i', '<C-x><C-y>', '<Plug>(emmet-expand-abbr)', { remap = false })
vim.keymap.set('n', '<Leader>er', '<Plug>(emmet-update-tag)', { remap = false })

-- indentLine Config
-- ---
vim.g.indentLine_fileTypeExclude = { 'help', 'fzf', 'fern' }
vim.g.indentLine_char = '│'
vim.g.indent_blankline_show_first_indent_level = false

vim.g.indentLine_color_gui = '#333333'

-- fern.vim Config
-- ---
vim.g['fern#hide_cursor'] = 1
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#renderer#nerdfont#root_symbol'] = ' '
vim.g['fern#renderer#nerdfont#indent_markers'] = 1

vim.keymap.set('n', '<Leader>ff', '<Cmd>Fern . -reveal=%<CR>')

local function init_fern(ev)
  vim.keymap.set('n', 'q', '<Cmd>bd<CR>', { buffer = ev.buf, desc = 'Exit fern buffer' })
  vim.keymap.set(
    'n',
    'D',
    '<Plug>(fern-action-remove)',
    { remap = true, buffer = ev.buf, desc = 'Delete file from the directory' }
  )

  vim.bo[ev.buf].expandtab = true
  vim.bo[ev.buf].shiftwidth = 2
  vim.bo[ev.buf].tabstop = 2

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

-- vim-json Config
-- ---
vim.g.vim_json_syntax_conceal = 0

-- vim-javascript Config
-- ---
vim.g.javascript_plugin_jsdoc = 1

-- vim-doge Config
-- ---
vim.g.doge_enable_mappings = 0

vim.keymap.set('n', '<Leader>dg', '<CMD>DogeGenerate<CR>')

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

-- For development (DEV)
-- vim.g['denops#debug'] = 1
-- vim.opt.runtimepath:append(vim.fn.expand('~/projects/github.com/creativenull/projectlocal.vim'))

ensure_plug()
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Deps
-- ---
Plug('vim-denops/denops.vim')
Plug('vim-denops/denops-shared-server.vim')
Plug('lambdalisue/nerdfont.vim')
Plug('nvim-lua/plenary.nvim')
Plug('lambdalisue/glyph-palette.vim')
Plug('muniftanjim/nui.nvim')

-- Core
-- ---
Plug('creativenull/projectlocal.vim', { tag = 'v1.*' })
Plug('cohama/lexima.vim')
Plug('godlygeek/tabular')
Plug('mattn/emmet-vim')
Plug('tpope/vim-abolish')
Plug('tpope/vim-repeat')
Plug('tpope/vim-surround')
Plug('numToStr/Comment.nvim')
Plug('JoosepAlviste/nvim-ts-context-commentstring')

-- AI
-- ---
Plug('dense-analysis/neural')

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
Plug('neovim/nvim-lspconfig')
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
Plug('Shougo/ddc-source-around')
Plug('Shougo/ddc-source-nvim-lsp')
Plug('matsui54/ddc-ultisnips')

-- Snippet Engine + Presets
-- ---
Plug('SirVer/ultisnips', { commit = '0ad238b1910d447476b2d98f593322c1cdb71285' })

-- Fuzzy File/Code Finder
-- ---
Plug('junegunn/fzf', { tag = '0.38.0' })
Plug('junegunn/fzf.vim', { commit = 'dc71692255b62d1f67dc55c8e51ab1aa467b1d46' })
Plug('dominickng/fzf-session.vim', { commit = 'b23069ad17352cbf55fde3d274dd172f3f40d6a9' })
Plug('linrongbin16/fzfx.vim', { commit = '8610252e27855731275709e0e62b2e2738aebfbd' })
Plug('gelguy/wilder.nvim', { commit = '679f348dc90d80ff9ba0e7c470c40a4d038dcecf' })

-- Git
-- ---
Plug('lewis6991/gitsigns.nvim')
Plug('tpope/vim-fugitive')

-- UI/Aesthetics
-- ---
Plug('lukas-reineke/indent-blankline.nvim', { tag = 'v2.*' })
Plug('creativenull/feline.nvim')
Plug('creativenull/feline-provider-ale.nvim')

-- TreeSitter
-- ---
Plug('nvim-treesitter/nvim-treesitter', { tag = 'v0.9.1', ['do'] = ':TSUpdate' })

-- Doc Generation
-- ---
Plug('kkoomen/vim-doge', { tag = 'v4.*', ['do'] = ':call doge#install()' })

-- FileType Syntax
-- ---
-- Log
Plug('MTDL9/vim-log-highlighting', { commit = '1037e26f3120e6a6a2c0c33b14a84336dee2a78f' })
-- Haskell
Plug('neovimhaskell/haskell-vim')
-- PHP
Plug('lumiliet/vim-twig', { commit = 'ad115512725bcc156f7f89b72ff563b9fa44933b' })
Plug('jwalton512/vim-blade')
Plug('gbprod/php-enhanced-treesitter.nvim')
Plug('creativenull/better-indent-support-for-php-with-html')
-- Plant UML
Plug('aklt/plantuml-syntax')

-- Colorschemes
-- ---
Plug('bluz71/vim-moonfly-colors', { commit = 'fe16eed4e61cbc178e6bb2b7d77e868f8602505d' })
Plug('tinted-theming/base16-vim', { commit = '3cdd12bca750e8c41a9e8912c142b45cd821c03e' })
Plug('folke/tokyonight.nvim', { commit = '1ee11019f8a81dac989ae1db1a013e3d582e2033' })
Plug('catppuccin/nvim', { commit = '0184121f9d6565610ddffa8284512b7643ee723e', as = 'catppuccin' })
Plug('bluz71/vim-nightfly-colors', { commit = '3ca232533b2bd58cc486552e9f4a9da7f7458bdd' })
Plug('rafamadriz/neon', { commit = '7765aaa7d1cd3804176140644640766e4411c766' })

-- Misc
-- ---
Plug('creativenull/dotfyle-metadata.nvim')

vim.call('plug#end')

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

-- lexima.vim Config
-- ---
require('user.lexima').setup()

-- ultisnips Config
-- ---
vim.g.UltiSnipsExpandTrigger = '<C-x><C-u>'
vim.g.UltiSnipsListSnippets = ''

-- ---
require('user.wilder').setup()

-- denops.vim Config
-- ---
vim.g.denops_server_addr = '127.0.0.1:2390'

-- fzf-session.vim Config
-- ---
local fzf_session = string.format('%s/sessions', vim.fn.stdpath('cache'))
if vim.fn.isdirectory(fzf_session) == 0 then
  vim.fn.mkdir(fzf_session)
end

vim.g.fzf_session_path = fzf_session

vim.keymap.set('n', '<Leader>ss', '<Cmd>Sessions<CR>')
vim.keymap.set('n', '<Leader>sc', ':Session ')

--- nvim-treesitter Config
-- ---
require('user.treesitter').setup()

-- nvim-lspconfig Config
-- ---
require('user.lsp').setup()

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
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

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

    -- Float border transparent
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
    -- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })

    -- Disable inverse visual
    -- vim.api.nvim_set_hl(0, 'Visual', { bg = '#aaaaaa', fg = '#222222' })
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
    custom_highlights = { NormalFloat = { bg = 'NONE' } },
    term_colors = true,
    color_overrides = {
      mocha = {
        base = '#111111',
        mantle = '#111111',
        crust = '#111111',
      },
    },
  })
end)

-- tokyonight.nvim Config
-- ---
pcall(function()
  require('tokyonight').setup({
    style = 'night',
    on_highlights = function(hi, _)
      hi.NormalFloat = { bg = 'NONE' }
      hi.FloatBorder = { bg = 'NONE' }
    end,
  })
end)

-- neon Config
-- ---
vim.g.neon_style = 'dark'

pcall(vim.cmd, 'colorscheme tokyonight')
