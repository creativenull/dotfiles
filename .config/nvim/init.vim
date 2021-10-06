" Name: Arnold Chand
" Github: https://github.com/creativenull
" File: init.vim
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + curl (globally installed)
"   + git (globally installed)
"   + python3 (globally installed)
"   + ripgrep (globally installed
" =============================================================================

if !has('nvim') && !has('nvim-0.5')
  echoerr 'This config is only for neovim 0.5 and up!'
  finish
endif

if !executable('git')
  echoerr '[nvim] `git` is needed!'
  finish
endif

if !executable('curl')
  echoerr '[nvim] `curl` is needed!'
  finish
endif

if !executable('python3')
  echoerr '[nvim] `python3`, `python3-pynvim` is needed!'
  finish
endif

if !executable('rg')
  echoerr '[nvim] `ripgrep` is needed!'
  finish
endif

" =============================================================================
" = Functions =
" =============================================================================

function! g:ToggleConcealLevel() abort
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

let g:mapleader = ' '
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog = exepath('python3')

let g:cnull = {}
let g:cnull.transparent = v:true
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
    autocmd ColorScheme * highlight Visual guifg=#333333 guibg=#aaaaaa
  augroup END
endif

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

augroup filetype_user_events
  autocmd!
  autocmd FileType vim,lua setlocal tabstop=2 softtabstop=2 shiftwidth=0 expandtab
augroup END

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" UltiSnips/vim-snippets Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" Use tab to complete the popup menu item
inoremap <silent> <expr> <Tab> pumvisible()
  \ ? UltiSnips#CanExpandSnippet() ? "\<C-r>=UltiSnips#ExpandSnippet()<CR>" : "\<C-y>"
  \ : "\<Tab>"

augroup ultisnips_user_events
  autocmd!
  autocmd FileType javascriptreact UltiSnipsAddFiletypes javascript
  autocmd FileType typescriptreact UltiSnipsAddFiletypes typescript
augroup END

" vim-vue Config
" ---
let g:vue_pre_processors = []

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'
let g:user_emmet_mode = 'i'
let g:user_emmet_install_global = 0

augroup emmet_user_events
  autocmd!
  autocmd FileType html,php,blade,css EmmetInstall
augroup END

" fzf.vim Config
" ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []

nnoremap <C-p> <Cmd>Files<CR>
nnoremap <C-t> <Cmd>Rg<CR>

function! g:FzfFtSetup() abort
  setlocal laststatus=0 noruler
  autocmd BufLeave <buffer> setlocal laststatus=2 ruler
endfunction

augroup fzf_user_events
  autocmd!
  autocmd FileType fzf call FzfFtSetup()
  autocmd ColorScheme * highlight fzfBorder guifg=#aaaaaa
augroup END

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
nnoremap <silent> <Leader>lr <Cmd>ALERename<CR>
nnoremap <silent> <Leader>la <Cmd>ALECodeAction<CR>
nnoremap <silent> <Leader>ld <Cmd>ALEGoToDefinition<CR>
nnoremap <silent> <Leader>lf <Cmd>ALEFix<CR>
nnoremap <silent> <Leader>lh <Cmd>ALEHover<CR>
nnoremap <silent> <Leader>li <Cmd>ALEInfo<CR>

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

function! g:AleStatus()
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
endfunction

" indentLine Config
" ---
let g:indentLine_char = '│'

" buftabline Config
" ---
let g:buftabline_indicators = 1

augroup buftabline_user_events
  autocmd!
  autocmd ColorScheme * highlight TabLineSel guibg=#047857 guifg=#cdcdcd
augroup END

" fern.vim Config
" ---
let g:fern#renderer = 'nerdfont'

nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

function! g:FernKeymaps() abort
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
endfunction

augroup fern_user_events
  autocmd!
  autocmd FileType fern call FernKeymaps()
augroup END

" vim-json Config
" ---
let g:vim_json_syntax_conceal = 0

" =============================================================================
" = Plugin Manager =
" =============================================================================

let s:plugin = {}
let s:plugin.url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:plugin.plug_filepath = stdpath('data') . '/site/autoload/plug.vim'
let s:plugin.plugins_dir = stdpath('data') . '/plugged'

if !filereadable(s:plugin.plug_filepath)
  execute printf('!curl -fLo %s --create-dirs %s', s:plugin.plug_filepath, s:plugin.url)
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:plugin.plugins_dir)

" Deps
Plug 'Shougo/context_filetype.vim'
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/nerdfont.vim'

" Core
Plug 'cohama/lexima.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tyru/caw.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'creativenull/projectlocal-vim'

" File Explorer + Addons
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

" Linters + Formatters + LSP Client
Plug 'dense-analysis/ale'

" AutoCompletion + Sources
Plug 'Shougo/ddc.vim'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-buffer'
Plug 'matsui54/ddc-ultisnips'
Plug 'statiolake/ddc-ale'

" Snippet Engine + Presets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Fuzzy File/Code Finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" UI Plugins
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-buftabline'
Plug 'itchyny/lightline.vim'
Plug 'posva/vim-vue'
Plug 'neoclide/vim-jsx-improve'
Plug 'peitalin/vim-jsx-typescript'
Plug 'jwalton512/vim-blade'
Plug 'elzr/vim-json'
Plug 'kevinoid/vim-jsonc'
Plug 'junegunn/vader.vim'

" Colorschemes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'

call plug#end()

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

" ddc.vim Config
" ---
call ddc#custom#patch_global({
  \ 'autoCompleteDelay': 100,
  \ 'backspaceCompletion': v:true,
  \ 'sources': ['ale', 'ultisnips', 'around', 'buffer'],
  \ 'sourceOptions': {
    \ '_': {
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'ignoreCase': v:true,
    \ },
    \ 'ultisnips': { 'mark': 'ultisnips' },
    \ 'ale': { 'mark': 'ale' },
    \ 'around': { 'mark': 'around' },
    \ 'buffer': { 'mark': 'buffer' },
  \ },
\ })

inoremap <silent> <expr> <C-Space> ddc#manual_complete()

call ddc#enable()

" lightline.vim Config
" ---
" Adjust some colors in powerline theme
let s:powerline = copy(g:lightline#colorscheme#powerline#palette)
let s:powerline.normal.left = [ ['#cdcdcd', '#047857', 'bold'], ['white', 'gray4'] ]
let g:lightline#colorscheme#powerline#palette = lightline#colorscheme#fill(s:powerline)

let g:lightline = {}
let g:lightline.separator = {}
let g:lightline.separator.left = ''
let g:lightline.separator.right = ''
let g:lightline.colorscheme = 'powerline'
let g:lightline.component = { 'lineinfo': ' %l/%L  %c' }
let g:lightline.active = {}
let g:lightline.active.left = [
  \ ['filename'],
  \ ['gitbranch', 'readonly', 'modified'],
\ ]
let g:lightline.active.right = [
  \ ['ale_error_component', 'ale_warning_component', 'ale_status'],
  \ ['lineinfo'],
  \ ['filetype', 'fileencoding'],
\ ]

let g:lightline.component_function = {}
let g:lightline.component_function.gitbranch = 'FugitiveHead'
let g:lightline.component_function.ale_status = 'AleStatus'

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
" = UI/Theme =
" =============================================================================

set termguicolors
set number
set background=dark
colorscheme moonfly

" =============================================================================
" = Options =
" =============================================================================

if !isdirectory(cnull.config.undodir)
  execute printf('silent !mkdir -p %s', cnull.config.undodir)
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
set nofoldenable

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
set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20

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

" Disable Ex-mode
nnoremap Q <Nop>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call ToggleConcealLevel()
command! ToggleCodeshot call ToggleCodeshot()

" Command Abbreviations
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev W w
cnoreabbrev Wq wq
