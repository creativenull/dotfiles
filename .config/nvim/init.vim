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
  echoerr 'This config is only for neovim 0.4 and up!'
  finish
endif

if !executable('git')
  echoerr '[nvim] `git` is needed!'
  finish
endif

if !executable('python3')
  echoerr '[nvim] `python3`, `python3-pynvim`, `python3-msgpack` is needed!'
  finish
endif

if !executable('rg')
  echoerr '[nvim] `ripgrep` is needed!'
  finish
endif

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

" =============================================================================
" = Initialize =
" =============================================================================

let g:mapleader = ' '
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog = $PYTHON3_HOST_PROG

let g:cnull = {}
let g:cnull.transparent = v:false
let g:cnull.config = {}
let g:cnull.config.undodir = stdpath('cache') . '/undo'

" =============================================================================
" = Events =
" =============================================================================

if g:cnull.transparent
  augroup transparent_user_events
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

" UltiSnips/vim-snippets Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

function! g:TabCompletion() abort
  if pumvisible()
    if UltiSnips#CanExpandSnippet()
      return "\<C-r>=UltiSnips#ExpandSnippet()<CR>"
    else
      return "\<C-y>"
    endif
  endif
  return "\<Tab>"
endfunction

inoremap <silent><expr> <Tab> g:TabCompletion()

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
nnoremap <C-p> <Cmd>Files<CR>
nnoremap <C-t> <Cmd>Rg<CR>

" ALE Config
" ---
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 1
let g:ale_hover_cursor = 0
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters_explicit = 1
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

" Keymaps
nnoremap <silent> <Leader>le <Cmd>lopen<CR>
nnoremap <silent> <Leader>lo <Cmd>ALERename<CR>
nnoremap <silent> <Leader>la <Cmd>ALECodeAction<CR>
nnoremap <silent> <Leader>ld <Cmd>ALEGoToDefinition<CR>
nnoremap <silent> <Leader>lf <Cmd>ALEFix<CR>
nnoremap <silent> <Leader>lh <Cmd>ALEHover<CR>
inoremap <silent> <C-Space>  <Cmd>ALEComplete<CR>

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

" hlyank Config
" ---
let g:highlightedyank_highlight_duration = 500

augroup highlightedyank_user_events
  autocmd!
  autocmd ColorScheme * highlight link HighlightedyankRegion Search
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
function! g:FernLoad() abort
  packadd fern.vim
  execute 'Fern . -reveal=%'
endfunction

nnoremap <silent> <Leader>ff <Cmd>call FernLoad()<CR>

" lightline.vim Config
" ---
let g:lightline = {}
let g:lightline.component = { 'lineinfo': '%l/%L:%c' }
let g:lightline.active = {}
let g:lightline.active.left = [
  \ ['mode', 'paste'],
  \ ['gitbranch', 'readonly', 'filename', 'modified'],
\ ]
let g:lightline.active.right = [
  \ ['ale_error_component', 'ale_warning_component'],
  \ ['lineinfo'],
  \ ['filetype', 'fileencoding'],
\ ]

let g:lightline.component_function = {}
let g:lightline.component_function.gitbranch = 'FugitiveHead'

let g:lightline.component_expand = {}
let g:lightline.component_expand.ale_error_component = 'AleErrorStlComponent'
let g:lightline.component_expand.ale_warning_component = 'AleWarningStlComponent'

let g:lightline.component_type = {}
let g:lightline.component_type.ale_error_component = 'error'
let g:lightline.component_type.ale_warning_component = 'warning'

augroup ale_lightline_user_events
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
augroup END

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! PackagerInit(opts) abort
  packadd vim-packager
  call packager#init(a:opts)
  call packager#add('kristijanhusak/vim-packager', {'type': 'opt'})

  " Core
  call packager#add('cohama/lexima.vim')
  call packager#add('godlygeek/tabular')
  call packager#add('tpope/vim-surround')
  call packager#add('tpope/vim-abolish')
  call packager#add('tpope/vim-repeat')
  call packager#add('Shougo/context_filetype.vim')
  call packager#add('tyru/caw.vim')
  call packager#add('editorconfig/editorconfig-vim')
  call packager#add('mattn/emmet-vim')
  call packager#add('vim-denops/denops.vim')
  call packager#add('creativenull/projectlocal-vim')

  " File Explorer
  call packager#add('antoinemadec/FixCursorHold.nvim')
  call packager#add('lambdalisue/fern.vim', { 'type': 'opt' })

  " LSP/Linter/Formatter
  call packager#add('dense-analysis/ale')
  call packager#add('Shougo/deoplete.nvim', { 'type': 'opt' })

  " Snippets
  call packager#add('SirVer/ultisnips')
  call packager#add('honza/vim-snippets')

  " Fuzzy Finder
  call packager#add('junegunn/fzf')
  call packager#add('junegunn/fzf.vim')

  " Git
  call packager#add('tpope/vim-fugitive')
  call packager#add('airblade/vim-gitgutter')

  " UI Plugins
  call packager#add('machakann/vim-highlightedyank')
  call packager#add('Yggdroot/indentLine')
  call packager#add('ap/vim-buftabline')
  call packager#add('itchyny/lightline.vim')
  call packager#add('posva/vim-vue')
  call packager#add('neoclide/vim-jsx-improve')
  call packager#add('peitalin/vim-jsx-typescript')
  call packager#add('jwalton512/vim-blade')

  " Colorschemes
  call packager#add('bluz71/vim-nightfly-guicolors')
  call packager#add('bluz71/vim-moonfly-colors')
endfunction

let g:cnull.plugin = {}
let g:cnull.plugin.git = 'https://github.com/kristijanhusak/vim-packager.git'
let g:cnull.plugin.path = printf('%s/site/pack/packager/opt/vim-packager', stdpath('data'))
let g:cnull.plugin.opts = {}
let g:cnull.plugin.opts.dir = printf('%s/site/pack/packager', stdpath('data'))

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
function! g:FzfVimGrep(qargs, bang) abort
  let sh = "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(a:qargs)
  call fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), a:bang)
endfunction

command! -bang -nargs=* Rg call FzfVimGrep(<q-args>, <bang>0)

" deoplete.nvim Config
" ---
function! g:DeopleteEnable()
  packadd deoplete.nvim
  let deoplete_opts = {}
  let deoplete_opts.sources = { '_': ['ale', 'ultisnips'] }
  let deoplete_opts.num_processes = 2
  call deoplete#custom#option(deoplete_opts)
  call deoplete#enable()
endfunction

augroup deoplete_user_events
  au!
  au FileType * call DeopleteEnable()
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
set ttimeoutlen=50
set mouse=

" UI
set hidden
set signcolumn=yes
set cmdheight=2
set showtabline=2
set laststatus=2
set noshowmode

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
nnoremap <Leader>bn <Cmd>bnext<CR>
" Go to previous buffer
nnoremap <C-h> <Cmd>bprevious<CR>
nnoremap <Leader>bp <Cmd>bprevious<CR>
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
nnoremap <Leader>mn <Cmd>nmap<CR>
nnoremap <Leader>mv <Cmd>vmap<CR>
nnoremap <Leader>mi <Cmd>imap<CR>
nnoremap <Leader>mt <Cmd>tmap<CR>
nnoremap <Leader>mc <Cmd>cmap<CR>

" Copy/Paste from clipboard
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p

" Disable Ex-mode and command history
nnoremap Q <Nop>
nnoremap q: <Nop>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call s:toggleConcealLevel()
command! ToggleCodeshot call s:toggleCodeshot()
