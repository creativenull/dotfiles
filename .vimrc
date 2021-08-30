vim9script
# Name: Arnold Chand
# Github: https://github.com/creativenull
# File: init.vim
# Description: My vimrc, currently tested on a Linux machine. Requires:
#   + git
#   + curl
#   + python3
#   + ripgrep
#   + Environment variables: $PYTHON3_HOST_PROG
# =============================================================================

set nocompatible
filetype plugin indent on
syntax on

# Pre-Requisites
if !executable('git')
  echoerr '[vim] "git" is needed!'
  finish
endif

if !executable('curl')
  echoerr '[vim] "curl" is needed!'
  finish
endif

if !executable('python3')
  echoerr '[vim] "python3" is needed!'
  finish
endif

if !executable('rg')
  echoerr '[vim] "ripgrep" is needed!'
  finish
endif

g:mapleader = ' '
g:python3_host_prog = $PYTHON3_HOST_PROG

def MakeConfig(): dict<string>
  const std_cache: string = expand('$HOME/.cache/vim')
  const std_config: string = expand('$HOME/.vim')
  const std_data: string = expand('$HOME/.vim')
  return {
    std_cache: std_cache,
    std_config: std_config,
    std_data: std_data,
    undodir: printf('%s/undo', std_cache),
  }
enddef

g:cnull = {
  transparent: false,
  config: MakeConfig(),
}

# =============================================================================
# = Functions =
# =============================================================================

def OptionsInit(): void
  const undodir: string = g:cnull.config.undodir
  if !isdirectory(undodir)
    printf('!mkdir -p %s', undodir)->execute('silent!')
  endif
enddef

def g:ToggleConcealLevel(): void
  if &conceallevel == 2
    set conceallevel=0
    g:vim_markdown_conceal = 0
    g:vim_markdown_conceal_code_blocks = 0
  else
    set conceallevel=2
    g:vim_markdown_conceal = 1
    g:vim_markdown_conceal_code_blocks = 1
  endif
enddef

def g:ToggleCodeshot(): void
  if &number
    setlocal nonumber signcolumn=no
  else
    setlocal number signcolumn=yes
  endif
enddef

# =============================================================================
# = Events =
# =============================================================================

if g:cnull.transparent
  augroup transparent_events
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=NONE
    autocmd ColorScheme * highlight SignColumn guibg=NONE
    autocmd ColorScheme * highlight LineNr guibg=NONE
    autocmd ColorScheme * highlight CursorLineNr guibg=NONE
    autocmd ColorScheme * highlight EndOfBuffer guibg=NONE
  augroup END
endif

# =============================================================================
# = Plugin Pre-Config - before loading plugins =
# =============================================================================

# UltiSnips Config
# ---
g:UltiSnipsExpandTrigger = '<C-q>.'
g:UltiSnipsJumpForwardTrigger = '<C-j>'
g:UltiSnipsJumpBackwardTrigger = '<C-k>'

# vim-vue Config
# ---
g:vue_pre_processors = []

# emmet-vim Config
# ---
g:user_emmet_leader_key = '<C-q>'
g:user_emmet_install_global = 0

# fzf.vim Config
# ---
$FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
$FZF_DEFAULT_OPTS = '--reverse'
g:fzf_preview_window = []
nnoremap <Leader>p <Cmd>Files<CR>
nnoremap <Leader>t <Cmd>Rg<CR>

# hlyank Config
# ---
g:highlightedyank_highlight_duration = 500

augroup user_highlightedyank_events
  autocmd!
  autocmd ColorScheme * highlight default link HighlightedyankRegion Search
augroup END

# indentLine Config
# ---
g:indentLine_char = '│'

# buftabline Config
# ---
g:buftabline_numbers = 2
g:buftabline_indicators = 1

# coc.nvim Config
# ---
g:coc_global_extensions = [
  'coc-json',
  'coc-tsserver',
  'coc-css',
  'coc-html',
  'coc-vetur',
  'coc-phpls',
  'coc-deno',
  'coc-snippets',
]

# ale Config
# ---
g:ale_completion_enabled = 0
g:ale_disable_lsp = 1
g:ale_hover_cursor = 0
g:ale_echo_msg_error_str = ''
g:ale_echo_msg_warning_str = ''
g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
g:ale_linters_explicit = 1
g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

def g:AleErrorStlComponent(): string
  if exists('g:loaded_ale')
    const info = ale#statusline#Count(bufnr(''))
    const errors = info.error
    if errors > 0
      return printf('%d', errors)
    endif
  endif

  return ''
enddef

def g:AleWarningStlComponent(): string
  if exists('g:loaded_ale')
    const info = ale#statusline#Count(bufnr(''))
    const warnings = info.warning
    if warnings > 0
      return printf('%d', warnings)
    endif
  endif

  return ''
enddef

# fern.vim Config
# ---
nnoremap <Leader>ff <Cmd>Fern . -reveal=%<CR>

# lightline.vim Config
# ---
g:lightline = {}
g:lightline.component = { lineinfo: '%l/%L:%c' }
g:lightline.active = {
  left: [
    ['mode', 'paste'],
    ['gitbranch', 'readonly', 'filename', 'modified'],
  ],

  right: [
    ['ale_error_component', 'ale_warning_component'],
    ['lineinfo'],
    ['filetype', 'fileencoding'],
  ],
}

g:lightline.component_function = {
  gitbranch: 'FugitiveHead',
}

g:lightline.component_expand = {
  ale_error_component: 'AleErrorStlComponent',
  ale_warning_component: 'AleWarningStlComponent',
}

g:lightline.component_type = {
  ale_error_component: 'error',
  ale_warning_component: 'warning',
}

augroup ale_lightline_user_events
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
augroup END

# =============================================================================
# = Plugin Manager =
# =============================================================================

# Bootstrap
const dataDir = ('~/.vim')->expand()
const plugDir = dataDir .. '/autoload/plug.vim'
const plugRemote = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !plugDir->filereadable()
  printf('!curl -fLo %s --create-dirs %s', plugDir, plugRemote)->execute()
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

plug#begin('~/.vim/plugged')

# Core
Plug 'Shougo/context_filetype.vim' | Plug 'tyru/caw.vim'
Plug 'cohama/lexima.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'vim-denops/denops.vim' | Plug 'creativenull/projectlocal-vim'

# File Explorer
Plug 'lambdalisue/fern.vim'

# Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

# Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

# Completion/LSP/Linters/Formatter
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'dense-analysis/ale'

# Fuzzy Finder
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'

# UI
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-buftabline'
Plug 'machakann/vim-highlightedyank'
Plug 'kevinoid/vim-jsonc'
Plug 'posva/vim-vue'
Plug 'neoclide/vim-jsx-improve'
Plug 'peitalin/vim-jsx-typescript'
Plug 'jwalton512/vim-blade'
Plug 'itchyny/lightline.vim'

# Colorscheme
Plug 'mhartington/oceanic-next'
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'

plug#end()

# =============================================================================
# = Plugin Post-Config - after loading plugins =
# =============================================================================

# fzf.vim Config
# ---
def g:FzfGrepCall(qargs: string, bang: number): void
  const sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. shellescape(qargs)
  fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), bang)
enddef

command! -bang -nargs=* Rg FzfGrepCall(<q-args>, <bang>0)

# coc.nvim Config
# ---
nnoremap <silent>       <Leader>ld <Plug>(coc-definition)
nnoremap <silent>       <Leader>lf <Plug>(coc-format)
nnoremap <silent>       <Leader>lo <Plug>(coc-rename)
nnoremap <silent>       <Leader>lh <Cmd>call CocActionAsync('doHover')<CR>
nnoremap <silent>       <Leader>la <Plug>(coc-codeaction)
nnoremap <silent>       <Leader>le <Cmd>CocList diagnostics<CR>
inoremap <silent><expr> <C-@> coc#refresh()

def g:TabCompletion(): string
  if pumvisible()
    if exists('g:did_coc_loaded')
      return coc#_select_confirm()
    else
      return "\<C-y>"
    endif
  endif

  return "\<Tab>"
enddef

inoremap <silent><expr> <Tab> TabCompletion()

# ale Config
# ---
nnoremap <silent> <Leader>ai <Cmd>ALEInfo<CR>
nnoremap <silent> <Leader>af <Cmd>ALEFix<CR>
nnoremap <silent> <Leader>ae <Cmd>lopen<CR>

# =============================================================================
# = UI/Theme =
# =============================================================================

if has('termguicolors')
  set termguicolors
  &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set number
set background=dark
colorscheme nightfly

# =============================================================================
# = Options =
# =============================================================================

OptionsInit()

# Completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c

# Search
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

# Editor
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smartindent
set smarttab
set autoindent
set nowrap
set colorcolumn=120
set scrolloff=5
set nospell

# System
set encoding=utf-8
set nobackup
set noswapfile
set updatetime=250
set undofile
set undolevels=10000
set history=10000
set backspace=indent,eol,start
set clipboard=unnamedplus
set ttimeoutlen=50
set mouse=
set lazyredraw
&undodir = g:cnull.config.undodir

# UI
set hidden
set conceallevel=0
set signcolumn=yes
set cmdheight=2
set showtabline=2
set laststatus=2
set noshowmode

# =============================================================================
# = Keybindings =
# =============================================================================

# Unbind default bindings for arrow keys, trust me this is for your own good
noremap  <Up>    <Nop>
noremap  <Down>  <Nop>
noremap  <Left>  <Nop>
noremap  <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

# Resize window panes, we can use those arrow keys
# to help use resize windows - at least we give them some purpose
nnoremap <Up>    <Cmd>resize +2<CR>
nnoremap <Down>  <Cmd>resize -2<CR>
nnoremap <Left>  <Cmd>vertical resize -2<CR>
nnoremap <Right> <Cmd>vertical resize +2<CR>

# Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <Esc>

# Map escape from terminal input to Normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>

# Disable highlights
nnoremap <Leader><CR> <Cmd>noh<CR>

# List all buffers
nnoremap <Leader>bb <Cmd>buffers<CR>
# Go to next buffer
nnoremap <C-l> <Cmd>bnext<CR>
nnoremap <Leader>bn <Cmd>bnext<CR>
# Go to previous buffer
nnoremap <C-h> <Cmd>bprevious<CR>
nnoremap <Leader>bp <Cmd>bprevious<CR>
# Close the current buffer, and more?
nnoremap <Leader>bd <Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>
# Close all buffer, except current
nnoremap <Leader>bx <Cmd>%bd<Bar>e#<Bar>bd#<CR>

# Edit vimrc
nnoremap <Leader>ve <Cmd>edit $MYVIMRC<CR>

# Source the vimrc to reflect changes
nnoremap <Leader>vs <Cmd>ConfigReload<CR>

# Reload file
nnoremap <Leader>r <Cmd>edit!<CR>

# List all maps
nmap <Leader>mn <Cmd>nmap<CR>
nmap <Leader>mv <Cmd>vmap<CR>
nmap <Leader>mi <Cmd>imap<CR>
nmap <Leader>mt <Cmd>tmap<CR>
nmap <Leader>mc <Cmd>cmap<CR>

# Move lines up/down with alt+j/k
set <M-j>=j
set <M-k>=k
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

# =============================================================================
# = Commands =
# =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel ToggleConcealLevel()
command! ToggleCodeshot ToggleCodeshot()
