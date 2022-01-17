" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc works with MacOS, Linux and Windows, requires
"   + curl (globally installed)
"   + git (globally installed)
"   + python3 (globally installed)
"   + ripgrep (globally installed
"
" =============================================================================
" = Initialize =
" =============================================================================

" User Config
" ---
let s:cnull = {}
let s:cnull.leaderkey = ' '
let s:cnull.transparent = v:true
let s:cnull.config = {}
let s:cnull.config.undodir = stdpath('cache') . '/undo'

" Pre-checks
" ---
if !has('nvim') && !has('nvim-0.5')
  echoerr 'This config requires nvim >= 0.5'
  finish
endif

" Ensure the following tools are installed in the system
let s:exec_list = ['git', 'curl', 'python3', 'rg', 'deno']
for s:exec in s:exec_list
  if !executable(s:exec)
    echoerr printf('[nvim] `%s` is needed!', s:exec)
    finish
  endif
endfor

" Windows specific settings
if has('win32')
  if !executable('pwsh')
    echoerr '[nvim] PowerShell Core >= v6 is needed!'
    finish
  endif

  set shell=pwsh
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif

" leader and providers settings
let g:mapleader = s:cnull.leaderkey
let g:python3_host_prog = exepath('python3')
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" =============================================================================
" = Functions =
" =============================================================================

" Toggle conceal level of local buffer
" which is enabled by some syntax plugin
function! g:ToggleConcealLevel() abort
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction

" Toggle the view of the editor, for taking screenshots
" or for copying code from the editor w/o using "+ register
" when not accessible, eg from a remote ssh
function! g:ToggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
    execute ':IndentLinesDisable'
  else
    setlocal number signcolumn=yes
    execute ':IndentLinesEnable'
  endif
endfunction

" Indent rules given to a filetype, use spaces if needed
function! g:IndentSize(size, use_spaces)
  execute printf('setlocal tabstop=%d softtabstop=%d shiftwidth=0', a:size, a:size)
  if !empty(a:use_spaces) && a:use_spaces
    setlocal expandtab
  else
    setlocal noexpandtab
  endif
endfunction

" =============================================================================
" = Events (AUG) =
" =============================================================================

if s:cnull.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * highlight! Normal guibg=NONE
    autocmd ColorScheme * highlight! SignColumn guibg=NONE
    autocmd ColorScheme * highlight! LineNr guibg=NONE guifg=#888888
    autocmd ColorScheme * highlight! CursorLineNr guibg=NONE
    autocmd ColorScheme * highlight! EndOfBuffer guibg=NONE
    autocmd ColorScheme * highlight! Visual guibg=#555555

    " Sometimes comments are too dark, affects in tranparent mode
    autocmd ColorScheme * highlight! Comment guifg=#888888

    " Tabline
    autocmd ColorScheme * highlight! TabLineFill guibg=NONE
    autocmd ColorScheme * highlight! TabLine guibg=NONE
  augroup END
endif

augroup customhl_user_events
  autocmd!
  " Don't want any bold or underlines
  autocmd ColorScheme * highlight Tabline gui=NONE
augroup END

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

augroup filetype_user_events
  autocmd!
  autocmd FileType vim,lua call IndentSize(2, v:true)
  autocmd FileType scss,sass,css call IndentSize(2, v:true)
  autocmd FileType javascript,javascriptreact call IndentSize(2, v:true)
  autocmd FileType typescript,typescriptreact call IndentSize(2, v:true)
  autocmd FileType json,jsonc call IndentSize(2, v:true)
  autocmd FileType vue call IndentSize(2, v:true)
  autocmd FileType php,blade,html call IndentSize(4, v:true)
  autocmd FileType markdown call IndentSize(4, v:true) | setlocal spell
augroup END

" =============================================================================
" = Options (OPT) =
" =============================================================================

if !isdirectory(s:cnull.config.undodir)
  if has('win32')
    execute printf('silent !mkdir -Recurse %s', s:cnull.config.undodir)
  else
    execute printf('silent !mkdir -p %s', s:cnull.config.undodir)
  endif
endif

" Completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Search
set hlsearch
set ignorecase
set incsearch
set path=**
set showmatch
set smartcase

" Editor
set autoindent
set colorcolumn=120
set expandtab
set iskeyword+=-
set lazyredraw
set nofoldenable
set nospell
set nowrap
set scrolloff=3
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set wildignorecase

" System
let &undodir=s:cnull.config.undodir
set backspace=indent,eol,start
set encoding=utf-8
set history=10000
set mouse=
set nobackup
set noswapfile
set ttimeoutlen=50
set undofile
set undolevels=10000
set updatetime=250

" UI
set cmdheight=2
set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20
set hidden
set laststatus=2
set number
set showtabline=2
set signcolumn=yes
set termguicolors

" =============================================================================
" = Keybindings (KEY) =
" =============================================================================

" Unbind default bindings for arrow keys, trust me this is for your own good
noremap  <Up> <Nop>
noremap  <Down> <Nop>
noremap  <Left> <Nop>
noremap  <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
nnoremap <Up> <Cmd>resize +2<CR>
nnoremap <Down> <Cmd>resize -2<CR>
nnoremap <Left> <Cmd>vertical resize -2<CR>
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
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p

" Disable Ex-mode
nnoremap Q <Nop>

" Utilities
nnoremap Y y$

" =============================================================================
" = Commands (CMD) =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call ToggleConcealLevel()
command! ToggleCodeshot call ToggleCodeshot()

command! MyTodoPersonal edit ~/todofiles/personal/README.md
command! MyTodoWork edit ~/todofiles/work/README.md

" Command Abbreviations, I can't release my shift key fast enough 😭
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev W w
cnoreabbrev Wq wq

" =============================================================================
" = Plugin Pre-Config - before loading plugins (PRE) =
" =============================================================================

" vim-vsnip Config
" ---
let g:vsnip_extra_mapping = v:false
let g:vsnip_filetypes = {
  \ 'javascriptreact': ['javascript'],
  \ 'typescriptreact': ['typescript'],
\ }

imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'

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
  autocmd FileType html,php,blade,vue,javascriptreact,typescriptreact EmmetInstall
augroup END

" fzf.vim Config
" ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []

nnoremap <C-p> <Cmd>Files<CR>
nnoremap <C-t> <Cmd>Rg<CR>

function! g:FzfFileTypeSetup() abort
  setlocal laststatus=0 noruler
  autocmd BufLeave <buffer> setlocal laststatus=2 ruler
endfunction

augroup fzf_user_events
  autocmd!
  autocmd FileType fzf call FzfFileTypeSetup()
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
let g:fern#hide_cursor = 1

nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

function! g:FernKeymaps() abort
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
endfunction

augroup fern_user_events
  autocmd!
  autocmd FileType fern call FernKeymaps()
  autocmd ColorScheme * highlight! default link CursorLine Visual
augroup END

" vim-json Config
" ---
let g:vim_json_syntax_conceal = 0

" moonfly Config
" ---
let g:moonflyNormalFloat = 1
let g:moonflyItalics = 0

" gruvbox Config
" ---
let g:gruvbox_bold = 0
let g:gruvbox_italic = 0
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_sign_column = 'bg0'

" projectlocal-vim
" ---
let g:projectlocal = {
  \ 'showMessage': v:true,
  \ 'projectConfig': '.vim/init.vim',
  \ 'debug': v:false,
\ }

" =============================================================================
" = Plugin Manager (PLUG) =
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
Plug 'Shougo/ddc.vim', { 'tag': 'v1.2.0' }
Plug 'matsui54/denops-popup-preview.vim'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-buffer'
Plug 'statiolake/ddc-ale'
Plug 'hrsh7th/vim-vsnip-integ'

" Snippet Engine + Presets
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'

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
Plug 'gruvbox-community/gruvbox'
Plug 'Mangeshrex/uwu.vim'
Plug 'ajmwagar/vim-deus'
Plug 'fnune/base16-vim'

call plug#end()

" =============================================================================
" = Plugin Post-Config - after loading plugins (POST) =
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
  \ 'sources': ['ale', 'vsnip', 'around', 'buffer'],
  \ 'sourceOptions': {
    \ '_': {
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'converters': ['converter_fuzzy'],
    \ },
    \ 'ale': {
      \ 'mark': 'LSP',
      \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
      \ 'maxCandidates': 10,
    \ },
    \ 'vsnip': {
      \ 'mark': 'SNIPPET',
      \ 'maxCandidates': 10,
    \ },
    \ 'around': {
      \ 'mark': 'AROUND',
      \ 'maxCandidates': 5,
    \ },
    \ 'buffer': {
      \ 'mark': 'BUFFER',
      \ 'maxCandidates': 5,
    \ },
  \ },
\ })

" Markdown FileType completion sources
call ddc#custom#patch_filetype('markdown', { 'sources': ['around', 'buffer'] })

" Use tab to complete the popup menu item w/ vsnip integration
inoremap <expr> <C-y> pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"

inoremap <expr> <C-Space> ddc#map#manual_complete()

call popup_preview#enable()
call ddc#enable()

" lightline.vim Config
" ---
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
  \ ['filetype', 'fileencoding'],
  \ ['lineinfo'],
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
" = Colorscheme =
" =============================================================================

colorscheme base16-horizon-terminal-dark
