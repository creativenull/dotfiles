" Name: Arnold Chand
" Github: https://github.com/creativenull
" File: init.vim
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + python3 (globally installed)
"   + ripgrep (globally installed
"   + Environment variables: $PYTHON3_HOST_PROG
" =============================================================================

set nocompatible
filetype plugin indent on
syntax on

if !has('nvim')
  echoerr "This config is only for neovim 0.4 and up!"
  finish
endif

if !executable('git')
  echoerr '[nvim] "git" is needed!'
  finish
endif

if !executable('python3')
  echoerr '[nvim] "python3" is needed!'
  echoerr 'Additionally install pynvim and msgpack: "pip3 install --user pynvim msgpack"'
  finish
endif

if !executable('rg')
  echoerr '[nvim] "ripgrep" is needed!'
  finish
endif

let g:mapleader = ' '
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog = $PYTHON3_HOST_PROG

let g:cnull = {}
let g:cnull.transparent = v:false
let g:cnull.config = { 'undodir': stdpath('cache') . '/undo' }

" =============================================================================
" = Functions =
" =============================================================================

function! s:toggleConcealLevel() abort
  if &conceallevel == 2
    set conceallevel=0
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0
  else
    set conceallevel=2
    let g:vim_markdown_conceal = 1
    let g:vim_markdown_conceal_code_blocks = 1
  endif
endfunction

function! s:toggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
  else
    setlocal number signcolumn=yes
  endif
endfunction

function! s:statuslineLspComponent() abort
  if exists('g:loaded_ale')
    let red_hl = '%#StatusLineLspRedText#'
    let yellow_hl = '%#StatusLineLspYellowText#'
    let counts = ale#statusline#Count(bufnr(''))
    let all_errors = counts.error + counts.style_error
    let all_non_errors = counts.total - all_errors
    return counts.total == 0
      \ ? 'LSP'
      \ : printf('%sE%d%s %sW%d%s LSP', red_hl, all_errors, '%*', yellow_hl, all_non_errors, '%*')
  endif

  return ''
endfunction

function! s:getHighlightColor(hi, type) abort
  let is_reverse = synIDattr(synIDtrans(hlID(a:hi)), 'reverse')
  let color = ''

  if !empty(is_reverse)
    if type == 'bg'
      let color = synIDattr(synIDtrans(hlID(a:hi)), 'fg')
    elseif type == 'fg'
      let color = synIDattr(synIDtrans(hlID(a:hi)), 'bg')
    endif
  else
    let color = synIDattr(synIDtrans(hlID(a:hi)), a:type)
  endif

  return color
endfunction

" LSP Highlights
function! g:SetLspHighlights() abort
  let bg_color = s:getHighlightColor('StatusLine', 'bg')
  if bg_color == ''
    let bg_color = '#333333'
  endif

  let red_color = '#ff4488'
  let yellow_color = '#eedd22'

  execute printf('highlight StatusLineLspRedText guifg=%s guibg=%s', red_color, bg_color)
  execute printf('highlight StatusLineLspYellowText guifg=%s guibg=%s', yellow_color, bg_color)
endfunction

" Active statusline
function! g:RenderActiveStatusLine() abort
  let branch = ''
  if exists('g:loaded_gitbranch')
    if gitbranch#name() != ''
      let branch = '' . gitbranch#name()
    endif
  endif

  let lsp = s:statuslineLspComponent()
  let fe = &fileencoding
  let ff = &fileformat
  return printf(' %s | %s | %s %s %s | %s | %s | %s ', '%t%m%r', branch, '%y', '%=', ff, fe, '%l/%L:%c', lsp)
endfunction

" Inactive statusline
function! g:RenderInactiveStatusLine() abort
  return ' %t%m%r | %y %= %l/%L:%c '
endfunction

function! g:LspKeymaps() abort
  nmap <silent> <Leader>le <Cmd>lopen<CR>
  nmap <silent> <Leader>lo <Cmd>ALERename<CR>
  nmap <silent> <Leader>la <Cmd>ALECodeAction<CR>
  nmap <silent> <Leader>ld <Cmd>ALEGoToDefinition<CR>
  nmap <silent> <Leader>lf <Cmd>ALEFix<CR>
  nmap <silent> <Leader>lh <Cmd>ALEHover<CR>
  inoremap <silent> <C-Space> <Cmd>ALEComplete<CR>
endfunction

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
  augroup end
endif

augroup statusline_events
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!RenderActiveStatusLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!RenderInactiveStatusLine()
  autocmd ColorScheme * call SetLspHighlights()
augroup END

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" UltiSnips/vim-snippets Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
inoremap <silent><expr> <Tab> pumvisible()
  \ ? UltiSnips#CanExpandSnippet() ? "\<C-r>=UltiSnips#ExpandSnippet()<CR>" : "\<C-y>"
  \ : "\<Tab>"

" vim-vue Config
" ---
let g:vue_pre_processors = []

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'

" fzf.vim Config
" ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []
nnoremap <Leader>p <Cmd>Files<CR>
nnoremap <Leader>t <Cmd>Rg<CR>

" ALE Config
" ---
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 1
let g:ale_hover_cursor = 0
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters_explicit = 1
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}

" hlyank Config
" ---
let g:highlightedyank_highlight_duration = 500
augroup user_highlightedyank_events
  autocmd!
  autocmd ColorScheme * highlight default link HighlightedyankRegion Search
augroup END

" indentLine Config
" ---
let g:indentLine_char = '│'

" buftabline Config
" ---
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1

" fern.vim Config
" ---
nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! PackagerInit(opts) abort
  packadd vim-packager
  call packager#init(a:opts)
  call packager#add('kristijanhusak/vim-packager', {'type': 'opt'})

  " Deps
  call packager#add('Shougo/context_filetype.vim')
  call packager#add('vim-denops/denops.vim')
  call packager#add('antoinemadec/FixCursorHold.nvim')

  " Core
  call packager#add('cohama/lexima.vim')
  call packager#add('godlygeek/tabular')
  call packager#add('tpope/vim-surround')
  call packager#add('tpope/vim-abolish')
  call packager#add('tyru/caw.vim')
  call packager#add('editorconfig/editorconfig-vim')
  call packager#add('mattn/emmet-vim')
  call packager#add('creativenull/projectlocal-vim')

  " File Explorer
  call packager#add('lambdalisue/fern.vim')

  " LSP/Linter/Formatter
  call packager#add('dense-analysis/ale')
  call packager#add('Shougo/deoplete.nvim')

  " Snippets
  call packager#add('SirVer/ultisnips')
  call packager#add('honza/vim-snippets')

  " Fuzzy Finder
  call packager#add('junegunn/fzf')
  call packager#add('junegunn/fzf.vim')

  " Git
  call packager#add('tpope/vim-fugitive')
  call packager#add('airblade/vim-gitgutter')
  call packager#add('itchyny/vim-gitbranch')

  " UI Plugins
  call packager#add('Yggdroot/indentLine')
  call packager#add('ap/vim-buftabline')
  call packager#add('posva/vim-vue')
  call packager#add('neoclide/vim-jsx-improve')
  call packager#add('peitalin/vim-jsx-typescript')
  call packager#add('jwalton512/vim-blade')
  call packager#add('machakann/vim-highlightedyank')

  " Colorschemes
  call packager#add('bluz71/vim-nightfly-guicolors')
  call packager#add('bluz71/vim-moonfly-colors')
endfunction

let g:cnull.plugin = {
  \ 'git': 'https://github.com/kristijanhusak/vim-packager.git',
  \ 'path': printf('%s/site/pack/packager/opt/vim-packager', stdpath('data')),
  \ 'opts': {'dir': printf('%s/site/pack/packager', stdpath('data'))},
\ }

" Package manager bootstrapping strategy
if !isdirectory(g:cnull.plugin.path)
  execute printf('!git clone %s %s', g:cnull.plugin.git, g:cnull.plugin.path)
  call PackagerInit(g:cnull.plugin.opts)
  call packager#install()
endif

command! -bar -nargs=* PackagerInstall call PackagerInit(g:cnull.plugin.opts) | call packager#install(<args>)
command! -bar -nargs=* PackagerUpdate call PackagerInit(g:cnull.plugin.opts) | call packager#update(<args>)
command! -bar PackagerClean call PackagerInit(g:cnull.plugin.opts) | call packager#clean()
command! -bar PackagerStatus call PackagerInit(g:cnull.plugin.opts) | call packager#status()

" =============================================================================
" = Plugin Post-Config - after loading plugins =
" =============================================================================

" fzf.vim Config
" ---
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview('right:50%', 'ctrl-/'),
  \ <bang>0
\ )

" deoplete.nvim Config
" ---
function! g:SetupDeoplete()
  packadd deoplete.nvim
  call deoplete#custom#option({
    \ 'sources': {'_': ['ale', 'ultisnips']},
    \ 'num_processes': 2,
    \ 'nofile_complete_filetypes': ['denite-filter', 'fzf', 'fern', 'gitcommit'],
  \ })
  call deoplete#enable()
endfunction

augroup user_deoplete_events
  au!
  au FileType * call SetupDeoplete()
augroup END

" =============================================================================
" = UI/Theme =
" =============================================================================

set termguicolors
set number
set background=dark
colorscheme moonfly

" =============================================================================
" = Options =
" =============================================================================

if !isdirectory(g:cnull.config.undodir)
  execute printf('silent !mkdir -p %s', g:cnull.config.undodir)
endif

" Completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch

" Editor
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smartindent
set smarttab
set autoindent
set showmatch
set nowrap
set colorcolumn=120
set scrolloff=5
set lazyredraw
set nospell
set wildignorecase

" System
set encoding=utf-8
set nobackup
set noswapfile
set updatetime=250
set undofile
let &undodir=g:cnull.config.undodir
set undolevels=10000
set history=10000
set backspace=indent,eol,start
set clipboard=unnamedplus
set ttimeoutlen=50
set mouse=

" UI
set hidden
set signcolumn=yes
set cmdheight=2
set statusline=%!RenderActiveStatusLine()
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
nnoremap <Leader>bl <Cmd>buffers<CR>
" Go to next buffer
nnoremap <C-l> <Cmd>bnext<CR>
" Go to previous buffer
nnoremap <C-h> <Cmd>bprevious<CR>
" Close the current buffer, and more?
nnoremap <Leader>bd <Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>
" Close all buffer, except current
nnoremap <Leader>bx <Cmd>%bd<Bar>e#<Bar>bd#<CR>

" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Edit vimrc
nnoremap <Leader>ve <Cmd>edit $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <Leader>vs <Cmd>ConfigReload<CR>

" Reload file
nnoremap <Leader>r <Cmd>edit!<CR>

" List all maps
nmap <Leader>mn <Cmd>nmap<CR>
nmap <Leader>mv <Cmd>vmap<CR>
nmap <Leader>mi <Cmd>imap<CR>
nmap <Leader>mt <Cmd>tmap<CR>
nmap <Leader>mc <Cmd>cmap<CR>

" Lsp Keymaps
call g:LspKeymaps()

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call s:toggleConcealLevel()
command! ToggleCodeshot call s:toggleCodeshot()

" I can't release my shift key fast enough :')
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Qa qa
command! QA qa
