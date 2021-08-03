" Name: Arnold Chand
" Github: https://github.com/creativenull
" File: init.vim
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + python3 (globally installed)
"   + ripgrep (globally installed
"   + Environment variables: $PYTHON3_HOST_PROG
" =============================================================================

if !has('nvim')
  set nocompatible
  filetype plugin indent on
  syntax on
endif

let mapleader = ' '
let g:python3_host_prog = $PYTHON3_HOST_PROG

let g:cnull = {}
let g:cnull.transparent = v:false

function! s:make_config() abort
  let l:std_cache = stdpath('cache')
  let l:std_config = stdpath('config')
  let l:std_data = stdpath('data')
  return {
    \ 'std_cache': std_cache,
    \ 'std_config': std_config,
    \ 'std_data': std_data,
    \ 'undodir': printf('%s/undo', std_cache),
  \ }
endfunction

function! s:make_plugin() abort
  let l:namespace = 'packager'
  let l:pack = 'vim-packager'
  let l:git = 'https://github.com/kristijanhusak/vim-packager.git'
  return {
    \ 'git': git,
    \ 'path': printf('%s/site/pack/%s/opt/%s', g:cnull.config.std_data, namespace, pack),
    \ 'opts': { 'dir': printf('%s/site/pack/%s', g:cnull.config.std_data, namespace) },
  \ }
endfunction

let g:cnull.config = s:make_config()
let g:cnull.plugin = s:make_plugin()

if !executable('python3') || !exists('$PYTHON3_HOST_PROG')
  echoerr '"python3" not installed, please install it via your OS software manager, and set the $PYTHON_HOST_PROG env'
  echoerr 'Additionally install pynvim and msgpack: "pip3 install pynvim msgpack"'
  finish
endif

if !executable('rg')
  echoerr '"ripgrep" not installed, please install it via your OS software manager'
  finish
endif

" =============================================================================
" = Functions =
" =============================================================================

function! s:options_init() abort
  if !isdirectory(g:cnull.config.undodir)
    execute printf('silent !mkdir -p %s', g:cnull.config.undodir)
  endif
endfunction

function! s:conceal_toggle() abort
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

function! s:codeshot_toggle() abort
  if &number
    setlocal nonumber signcolumn=no
  else
    setlocal number signcolumn=yes
  endif
endfunction

function! s:lsp_status() abort
  if exists('g:loaded_ale')
    let l:red_hl = '%#StatusLineLspRedText#'
    let l:yellow_hl = '%#StatusLineLspYellowText#'
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = counts.error + counts.style_error
    let l:all_non_errors = counts.total - all_errors
    return counts.total == 0
      \ ? 'LSP'
      \ : printf('%sE%d%s %sW%d%s LSP', l:red_hl, all_errors, '%*', l:yellow_hl, all_non_errors, '%*')
  endif

  return ''
endfunction

function! s:get_hicolor(hi, type) abort
  let l:is_reverse = synIDattr(synIDtrans(hlID(a:hi)), 'reverse')
  if l:is_reverse
    if a:type == 'bg'
      let l:color = synIDattr(synIDtrans(hlID(a:hi)), 'fg')
    elseif a:type == 'fg'
      let l:color = synIDattr(synIDtrans(hlID(a:hi)), 'bg')
    endif
  else
    let l:color = synIDattr(synIDtrans(hlID(a:hi)), a:type)
  endif

  return l:color
endfunction

" LSP Highlights
function! g:SetLspHighlight() abort
  let l:bg_color = s:get_hicolor('StatusLine', 'bg')
  let l:red_color = '#ff4488'
  let l:yellow_color = '#eedd22'
  execute printf('highlight StatusLineLspRedText guifg=%s guibg=%s', l:red_color, l:bg_color)
  execute printf('highlight StatusLineLspYellowText guifg=%s guibg=%s', l:yellow_color, l:bg_color)
endfunction

" autocompletion Config
function! g:RegisterCompletionEngine() abort
  let l:sources = ['buffer', 'ultisnips', 'ale']
  call deoplete#custom#option({
    \ 'max_list': 10,
    \ 'smart_case': v:true,
    \ 'auto_complete_delay': 50,
    \ 'sources': {
      \ '_': ['buffer'],
      \ 'javascript': l:sources,
      \ 'javascriptreact': l:sources,
      \ 'php': l:sources,
      \ 'typescript': l:sources,
      \ 'typescriptreact': l:sources,
      \ 'vue': l:sources,
    \ },
  \ })
  call deoplete#enable()
endfunction

" LSP Keymaps
function! g:RegisterKeymaps() abort
  " ALE
  nmap <buffer><silent> <Leader>lo <Cmd>ALERename<CR>
  nmap <buffer><silent> <Leader>la <Cmd>ALECodeAction<CR>
  nmap <buffer><silent> <Leader>ld <Plug>(ale_go_to_definition)
  nmap <buffer><silent> <Leader>lr <PLug>(ale_find_references)
  nmap <buffer><silent> <Leader>lf <Plug>(ale_fix)
  nmap <buffer><silent> <Leader>lh <Plug>(ale_hover)
  imap <buffer><silent> <C-Space>  <Plug>(ale_complete)
endfunction

" LSP settings - registerd on FileType event
function! g:RegisterLsp() abort
  call RegisterCompletionEngine()
  call RegisterKeymaps()
endfunction

" Active statusline
function! g:RenderActiveStatusLine() abort
  let l:branch = ''
  if exists('g:loaded_gitbranch')
    if gitbranch#name() != ''
      let l:branch = '' . gitbranch#name()
    endif
  endif

  let l:lsp = s:lsp_status()
  let l:fe = &fileencoding
  let l:ff = &fileformat
  return printf(' %s | %s | %s %s %s | %s | %s | %s ', '%t%m%r', l:branch, '%y', '%=', l:ff, l:fe, '%l/%L:%c', l:lsp)
endfunction

" Inactive statusline
function! g:RenderInactiveStatusLine() abort
  return ' %t%m%r | %y %= %l/%L:%c '
endfunction

function! g:LoadCommonFtPackages() abort
  " Editor
  packadd editorconfig-vim

  " Commenting
  packadd caw.vim

  " Snippets
  packadd ultisnips
  packadd vim-snippets
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
  autocmd ColorScheme * call SetLspHighlight()
augroup END

if has('nvim-0.5')
  autocmd! TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'Search', timeout = 500 }
endif

" =============================================================================
" = Plugin Config - before loading plugins =
" =============================================================================

" UltiSnips Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
inoremap <silent><expr> <Tab> pumvisible() ?
  \ UltiSnips#CanExpandSnippet() ?
  \ "<C-r>=UltiSnips#ExpandSnippet()<CR>" :
  \ "\<C-y>" :
  \ "\<Tab>"

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
nnoremap <Leader>p <Cmd>Files<CR>
nnoremap <Leader>t <Cmd>Rg<CR>

" ALE Config
" ---
let g:ale_completion_autoimport = 1
let g:ale_hover_cursor = 0
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters_explicit = 1
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}

" vim-startify Config
" ---
let g:startify_change_to_dir = 0
let g:startify_lists = [
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
\ ]

" hlyank Config
" ---
if !has('nvim-0.5')
  let g:highlightedyank_highlight_duration = 500
  autocmd! ColorScheme * highlight default link HighlightedyankRegion Search
endif

" indentLine Config
" ---
let g:indentLine_char = '│'

" buftabline Config
" ---
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1

" defx.nvim Config
" ---
let g:cnull.defx = {}
if has('win32')
  let g:cnull.defx.esc = "\\"
else
  let g:cnull.defx.esc = ':'
endif

" Search files the current working directory
let g:cnull.defx.escapepath = "escape(expand('%:p:h'), ' ". g:cnull.defx.esc ."')"
let g:cnull.defx.filepath = "expand('%:p')"
nnoremap <silent> <Leader>ff
  \ <Cmd>execute printf("Defx `%s` -search=`%s`", g:cnull.defx.escapepath, g:cnull.defx.filepath)<CR>

" tokyonight-vim Config
" ---
let g:tokyonight_style = 'night'

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
  call packager#add('Shougo/defx.nvim')
  call packager#add('tyru/caw.vim', {'type': 'opt', 'requires': 'Shougo/context_filetype.vim'})
  call packager#add('editorconfig/editorconfig-vim', {'type': 'opt'})
  call packager#add('mattn/emmet-vim', {'type': 'opt'})
  call packager#add('vim-denops/denops.vim')
  call packager#add('creativenull/projectlocal-vim')

  " LSP/Linter/Formatter
  call packager#add('dense-analysis/ale')

  " Autocompletion
  call packager#add('Shougo/deoplete.nvim', {'type': 'opt'})

  " Snippets
  call packager#add('SirVer/ultisnips', {'type': 'opt'})
  call packager#add('honza/vim-snippets', {'type': 'opt'})

  " Fuzzy Finder
  call packager#add('junegunn/fzf')
  call packager#add('junegunn/fzf.vim', {'requires': 'junegunn/fzf'})

  " Git
  call packager#add('tpope/vim-fugitive')
  call packager#add('airblade/vim-gitgutter')
  call packager#add('itchyny/vim-gitbranch')

  " UI Plugins
  call packager#add('mhinz/vim-startify')
  call packager#add('Yggdroot/indentLine')
  call packager#add('ap/vim-buftabline')
  call packager#add('posva/vim-vue')
  call packager#add('neoclide/vim-jsx-improve')
  call packager#add('peitalin/vim-jsx-typescript')
  call packager#add('jwalton512/vim-blade')
  if !has('nvim-0.5')
    call packager#add('machakann/vim-highlightedyank')
  endif

  " Colorschemes
  call packager#add('ghifarit53/tokyonight-vim')
  call packager#add('mhartington/oceanic-next')
  call packager#add('jacoborus/tender.vim')
endfunction

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
" = Plugin Config - after loading plugins =
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

" =============================================================================
" = UI/Theme =
" =============================================================================

if has('termguicolors')
  set termguicolors
  if !has('nvim')
    set t_Co=256
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

set number
set background=dark
colorscheme tokyonight

" =============================================================================
" = Options =
" =============================================================================

call s:options_init()

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

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch | execute ':EditorConfigReload'

command! ConcealToggle call s:conceal_toggle()
command! CodeshotToggle call s:codeshot_toggle()

" I can't release my shift key fast enough :')
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Qa qa
command! QA qa
