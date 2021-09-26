" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + git
"   + curl
"   + python3
"   + ripgrep
" =============================================================================

set nocompatible
filetype plugin indent on
syntax on

" Pre-Requisites
if !executable('git')
  echoerr '[vim] `git` is needed!'
  finish
endif

if !executable('curl')
  echoerr '[vim] `curl` is needed!'
  finish
endif

if !executable('python3')
  echoerr '[vim] `python3` is needed!'
  finish
endif

if !executable('rg')
  echoerr '[vim] `ripgrep` is needed!'
  finish
endif

" =============================================================================
" = Functions =
" =============================================================================

function! g:MakeConfig() abort
  let std_cache = ''
  let std_config = ''
  let std_data = ''
  if has('win32')
    let std_cache = expand('$HOME/AppData/Local/Temp/vim')
    let std_config = expand('$HOME')
    let std_data = expand('$HOME/vimfiles')
  else
    let std_cache = expand('$HOME/.cache/vim')
    let std_config = expand('$HOME')
    let std_data = expand('$HOME/.vim')
  endif

  return {
    \ 'std_cache': std_cache,
    \ 'std_config': std_config,
    \ 'std_data': std_data,
    \ 'undodir': printf('%s/undo', std_cache),
  \ }
endfunction

function! g:ToggleConcealLevel() abort
  if &conceallevel == 2
    set conceallevel=0
    g:vim_markdown_conceal = 0
    g:vim_markdown_conceal_code_blocks = 0
  else
    set conceallevel=2
    g:vim_markdown_conceal = 1
    g:vim_markdown_conceal_code_blocks = 1
  endif
endfunction

function! g:ToggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
  else
    setlocal number signcolumn=yes
  endif
endfunction

" =============================================================================
" = Initialize =
" =============================================================================

let mapleader = ' '
let g:cnull = {}
let g:cnull.transparent = v:false
let g:cnull.config = MakeConfig()

" =============================================================================
" = Events =
" =============================================================================

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

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" UltiSnips Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" vim-vue Config
" ---
let g:vue_pre_processors = []

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'
let g:user_emmet_install_global = 0

" fzf.vim Config
" ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []

nnoremap <C-p> <Cmd>Files<CR>
nnoremap <C-t> <Cmd>Rg<CR>

augroup fzf_highlight_user_events
  autocmd!
  autocmd ColorScheme * highlight fzfBorder guifg=#aaaaaa
augroup END

" hlyank Config
" ---
let g:highlightedyank_highlight_duration = 500

augroup user_highlightedyank_events
  autocmd!
  autocmd ColorScheme * highlight default HighlightedyankRegion Search
augroup END

" indentLine Config
" ---
let g:indentLine_char = '│'

" buftabline Config
" ---
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1

augroup buftabline_user_events
  autocmd!
  autocmd ColorScheme * highlight TabLineSel guibg=#047857 guifg=#cdcdcd
augroup END

" coc.nvim Config
" ---
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-vetur',
  \ 'coc-phpls',
  \ 'coc-deno',
  \ 'coc-snippets',
\ ]

nnoremap <silent>        <Leader>ld <Cmd>call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent>        <Leader>lf <Cmd>call CocActionAsync('format')<CR>
nnoremap <silent>        <Leader>lr <Cmd>call CocActionAsync('rename')<CR>
nnoremap <silent>        <Leader>lh <Cmd>call CocActionAsync('doHover')<CR>
nnoremap <silent>        <Leader>la <Cmd>call CocActionAsync('codeAction')<CR>
nnoremap <silent>        <Leader>le <Cmd>CocList diagnostics<CR>
inoremap <silent> <expr> <C-@>      coc#refresh()

inoremap <silent> <expr> <Tab> pumvisible()
  \ ? exists('g:did_coc_loaded') ? coc#_select_confirm() : "\<C-y>"
  \ : "\<Tab>"

" ale Config
" ---
let g:ale_completion_enabled = 0
let g:ale_disable_lsp = 1
let g:ale_hover_cursor = 0
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters_explicit = 1
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

nnoremap <silent> <Leader>ai <Cmd>ALEInfo<CR>
nnoremap <silent> <Leader>af <Cmd>ALEFix<CR>
nnoremap <silent> <Leader>ae <Cmd>lopen<CR>

function! g:AleErrorStlComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let errors = info.error
    if errors > 0
      return printf('%d', errors)
    endif
  endif

  return ''
endfunction

function! g:AleWarningStlComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let warnings = info.warning
    if warnings > 0
      return printf('%d', warnings)
    endif
  endif

  return ''
endfunction

function! g:AleStatus() abort
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
endfunction

" fern.vim Config
" ---
let g:fern#renderer = 'nerdfont'

nnoremap <Leader>ff <Cmd>Fern . -reveal=%<CR>

" =============================================================================
" = Plugin Manager =
" =============================================================================

" Bootstrap
let s:plugin = {}
let s:plugin.git = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:plugin.filepath = g:cnull.config.std_data . '/autoload/plug.vim'
let s:plugin.plugins_dir = g:cnull.config.std_data . '/plugged'

if !filereadable(s:plugin.filepath)
  execute printf('!curl -fLo %s --create-dirs %s', s:plugin.filepath, s:plugin.git)
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:plugin.plugins_dir)

" Deps
Plug 'Shougo/context_filetype.vim'
Plug 'vim-denops/denops.vim'

" Core
Plug 'tyru/caw.vim'
Plug 'cohama/lexima.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'creativenull/projectlocal-vim'

" File Explorer
Plug 'lambdalisue/fern.vim', { 'on': 'Fern' }
Plug 'lambdalisue/nerdfont.vim', { 'on': 'Fern' }
Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'on': 'Fern' }

" Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Auto-completion/LSP/Linters/Formatter
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'dense-analysis/ale'

" Fuzzy Finder
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'

" UI/Syntax
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-buftabline'
Plug 'machakann/vim-highlightedyank'
Plug 'kevinoid/vim-jsonc'
Plug 'posva/vim-vue'
Plug 'neoclide/vim-jsx-improve'
Plug 'peitalin/vim-jsx-typescript'
Plug 'jwalton512/vim-blade'
Plug 'itchyny/lightline.vim'

" Colorscheme
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'

call plug#end()

" =============================================================================
" = Plugin Post-Config - after loading plugins =
" =============================================================================

" fzf.vim Config
" ---
function! g:FzfVimGrep(qargs, bang) abort
  let sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(a:qargs)
  fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), a:bang)
endfunction

command! -bang -nargs=* Rg FzfVimGrep(<q-args>, <bang>0)

" lightline.vim Config
" ---
let s:powerline = copy(g:lightline#colorscheme#powerline#palette)
let s:powerline.normal.left = [
  \ ['#cdcdcd', '#047857', 'bold'],
  \ ['white', 'gray4'],
\ ]
let g:lightline#colorscheme#powerline#palette = lightline#colorscheme#fill(s:powerline)

let g:lightline = {}
let g:lightline.separator = {
  \ 'left': '',
  \ 'right': '',
\ }
let g:lightline.component = { 'lineinfo': '%l/%L:%c' }
let g:lightline.active = {
  \ 'left': [ ['filename'], ['gitbranch', 'readonly', 'modified'], ],
  \ 'right': [
    \ ['ale_error_component', 'ale_warning_component', 'ale_status'],
    \ ['lineinfo'],
    \ ['filetype', 'fileencoding'],
  \ ],
\ }

let g:lightline.component_function = {
  \ 'gitbranch': 'FugitiveHead',
  \ 'ale_status': 'AleStatus',
\ }

let g:lightline.component_expand = {
  \ 'ale_error_component': 'AleErrorStlComponent',
  \ 'ale_warning_component': 'AleWarningStlComponent',
\ }

let g:lightline.component_type = {
  \ 'ale_error_component': 'error',
  \ 'ale_warning_component': 'warning',
\ }

augroup ale_lightline_user_events
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
augroup END

" =============================================================================
" = UI/Theme =
" =============================================================================

if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set number
set background=dark
colorscheme moonfly

" =============================================================================
" = Options =
" =============================================================================

if isdirectory(g:cnull.config.undodir)
  execute printf('silent !mkdir -p %s', g:cnull.config.undodir)
endif

" Completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set wildmenu

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" Editor
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

" System
set encoding=utf-8
set nobackup
set noswapfile
set updatetime=250
set undofile
set undolevels=10000
set history=10000
set backspace=indent,eol,start
set ttimeoutlen=50
set mouse=
set lazyredraw
let &undodir = cnull.config.undodir

" UI
set hidden
set conceallevel=0
set signcolumn=yes
set cmdheight=2
set showtabline=2
set laststatus=2

" =============================================================================
" = Keybindings =
" =============================================================================

" Unbind default bindings for arrow keys, trust me this is for your own good
noremap  <Up>    <Nop>
noremap  <Down>  <Nop>
noremap  <Left>  <Nop>
noremap  <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
nnoremap <Up>    <Cmd>resize +2<CR>
nnoremap <Down>  <Cmd>resize -2<CR>
nnoremap <Left>  <Cmd>vertical resize -2<CR>
nnoremap <Right> <Cmd>vertical resize +2<CR>

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <Esc>

" Map escape from terminal input to Normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>

" Disable highlights
nnoremap <Leader><CR> <Cmd>noh<CR>

" List all buffers
nnoremap <Leader>bb <Cmd>buffers<CR>
" Go to next buffer
nnoremap <C-l> <Cmd>bnext<CR>
nnoremap <Leader>bn <Cmd>bnext<CR>
" Go to previous buffer
nnoremap <C-h> <Cmd>bprevious<CR>
nnoremap <Leader>bp <Cmd>bprevious<CR>
" Close the current buffer, and more?
nnoremap <Leader>bd <Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>
" Close all buffer, except current
nnoremap <Leader>bx <Cmd>%bd<Bar>e#<Bar>bd#<CR>

" Edit vimrc
nnoremap <Leader>ve <Cmd>edit $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <Leader>vs <Cmd>ConfigReload<CR>

" Reload file
nnoremap <Leader>r <Cmd>edit!<CR>

" List all maps
nnoremap <Leader>mn <Cmd>nmap<CR>
nnoremap <Leader>mv <Cmd>vmap<CR>
nnoremap <Leader>mi <Cmd>imap<CR>
nnoremap <Leader>mt <Cmd>tmap<CR>
nnoremap <Leader>mc <Cmd>cmap<CR>

" Move lines up/down with alt+j/k
set <M-j>=j
set <M-k>=k
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Copy/Paste system clipboard
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p

" Disable Ex-mode
nnoremap Q <Nop>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel ToggleConcealLevel()
command! ToggleCodeshot ToggleCodeshot()

" Command Abbreviations
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev W w
cnoreabbrev Wq wq
