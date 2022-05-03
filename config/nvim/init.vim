" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc works with MacOS, Linux and Windows.
" Requires:
"   + curl
"   + git
"   + python3
"   + ripgrep
"
" =============================================================================
" = Initialize =
" =============================================================================

" User Config
" ---
let s:cnull = {}
let s:cnull.leaderkey = "\<Space>"
let s:cnull.transparent = v:false
let s:cnull.config = {}
let s:cnull.config.undodir = stdpath('cache') . '/undo'

" Pre-checks
" ---
if !has('nvim') && !has('nvim-0.6')
  echoerr 'This config requires nvim >= 0.6'

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
    echoerr '[nvim] PowerShell Core >= v6 is required!'

    finish
  endif

  let s:shcmd_flag = [
    \ '-NoLogo',
    \ '-NoProfile',
    \ '-ExecutionPolicy',
    \ 'RemoteSigned',
    \ '-Command',
    \ '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  \ ]

  let &shellcmdflag = join(s:shcmd_flag, ' ')
  let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shell=pwsh
  set shellquote=
  set shellxquote=
endif

" leader and providers settings
let g:mapleader = s:cnull.leaderkey
let g:python3_host_prog = exepath('python3')
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" =============================================================================
" = Events (AUG) =
" =============================================================================

function! s:set_transparent_highlights() abort
  " Core highlights to make transparent
  highlight Normal guibg=NONE
  highlight SignColumn guibg=NONE
  highlight LineNr guibg=NONE guifg=#888888
  highlight CursorLineNr guibg=NONE
  highlight EndOfBuffer guibg=NONE
  highlight Visual guibg=#555555

  " Sometimes comments are too dark, affects in tranparent mode
  highlight Comment guifg=#888888

  " Tabline
  highlight TabLineFill guibg=NONE
  highlight TabLine guibg=NONE

  " Float Border
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE guifg=#eeeeee

  " Vertical Line
  highlight ColorColumn guibg=#999999

  " LSP Diagnostics
  highlight ErrorFloat guibg=NONE
  highlight WarningFloat guibg=NONE
  highlight InfoFloat guibg=NONE
  highlight HintFloat guibg=NONE
endfunction

if s:cnull.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * call s:set_transparent_highlights()
  augroup END
endif

augroup customhl_user_events
  autocmd!

  " Don't want any bold or underlines
  autocmd ColorScheme * highlight Tabline gui=NONE

  " Different color when confirming selected substitution `:s`
  autocmd ColorScheme * highlight IncSearch gui=NONE guibg=#103da5 guifg=#eeeeee
augroup END

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

augroup filetype_user_events
  autocmd!
  autocmd FileType javascript,javascriptreact  call cnull#utils#IndentSize(2, v:true)
  autocmd FileType json,jsonc                  call cnull#utils#IndentSize(2, v:true)
  autocmd FileType markdown                    call cnull#utils#IndentSize(4, v:true) | setlocal spell
  autocmd FileType php,blade,html              call cnull#utils#IndentSize(4, v:true)
  autocmd FileType scss,sass,css               call cnull#utils#IndentSize(2, v:true)
  autocmd FileType typescript,typescriptreact  call cnull#utils#IndentSize(2, v:true)
  autocmd FileType vim,lua                     call cnull#utils#IndentSize(2, v:true)
  autocmd FileType vue                         call cnull#utils#IndentSize(2, v:true)
augroup END

augroup quickfix_user_events
  autocmd!
  autocmd FileType qf nnoremap <CR> <CR>:cclose<CR>
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
set showmatch
set smartcase
set path=**

" Editor
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
set softtabstop=4
set wildignorecase

" System
let &undodir=s:cnull.config.undodir
set history=10000
set nobackup
set noswapfile
set undofile
set undolevels=10000
set updatetime=500

if !has('wsl')
  set mouse=nv
endif

" UI
set cmdheight=2
set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20
set number
set showtabline=2
set signcolumn=yes
set termguicolors

" =============================================================================
" = Keybindings (KEY) =
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
nnoremap <C-l>      <Cmd>bnext<CR>
nnoremap <Leader>bn <Cmd>bnext<CR>

" Go to previous buffer
nnoremap <C-h>      <Cmd>bprevious<CR>
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

" =============================================================================
" = Commands (CMD) =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call cnull#utils#ToggleConcealLevel()
command! ToggleCodeshot call cnull#utils#ToggleCodeshot()

command! MyTodoPersonal edit ~/todofiles/personal/README.md
command! MyTodoWork edit ~/todofiles/work/README.md

" Command Abbreviations, I can't release my shift key fast enough 😭
cnoreabbrev Q  q
cnoreabbrev Qa qa
cnoreabbrev W  w
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
  autocmd FileType html,vue EmmetInstall
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact EmmetInstall
  autocmd FileType php,blade EmmetInstall
  autocmd FileType twig,html.twig,htmldjango.twig,xml.twig EmmetInstall
augroup END

" indentLine Config
" ---
let g:indentLine_fileTypeExclude = ['help', 'fzf']
let g:indentLine_char = '│'

if s:cnull.transparent
  let g:indentLine_color_gui = '#333333'
endif

" fern.vim Config
" ---
let g:fern#renderer = 'nerdfont'
let g:fern#hide_cursor = 1

nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

function! g:FernKeymaps() abort
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
  nmap <buffer> D <Plug>(fern-action-remove)
endfunction

augroup fern_user_events
  autocmd!
  autocmd FileType fern call FernKeymaps()
  autocmd ColorScheme * highlight! default link CursorLine Visual
augroup END

" gin.vim Config
" ---
" Push from git repo, notify user since this is async
function! s:ginPushOrigin() abort
  let l:branch = gitbranch#name()
  let l:cmd = printf('Gin push origin %s', l:branch)
  execute printf('echo "%s"', l:cmd)
  execute l:cmd
endfunction

" Pull from git repo, notify user since this is async
function! s:ginPullOrigin() abort
  let l:branch = gitbranch#name()
  let l:cmd = printf('Gin pull origin %s', l:branch)
  execute printf('echo "%s"', l:cmd)
  execute l:cmd
endfunction

nnoremap <Leader>gs <Cmd>GinStatus<CR>
nnoremap <Leader>gp <Cmd>call <SID>GinPushOrigin()<CR>
nnoremap <Leader>gl <Cmd>call <SID>GinPullOrigin()<CR>
nnoremap <Leader>gb <Cmd>GinBranch<CR>
nnoremap <Leader>gc <Cmd>Gin commit<CR>

" vim-json Config
" ---
let g:vim_json_syntax_conceal = 0

" vim-javascript Config
" ---
let g:javascript_plugin_jsdoc = 1

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
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/nerdfont.vim'

" Core
Plug 'cohama/lexima.vim', { 'commit': 'fbc05de53ca98b7f36a82f566db1df49864e58ef' }
Plug 'godlygeek/tabular', { 'commit': '339091ac4dd1f17e225fe7d57b48aff55f99b23a' }
Plug 'tpope/vim-surround', { 'tag': 'v2.2' }
Plug 'tpope/vim-abolish', { 'tag': 'v1.1' }
Plug 'tpope/vim-repeat', { 'commit': '24afe922e6a05891756ecf331f39a1f6743d3d5a' }
Plug 'Shougo/context_filetype.vim', { 'commit': '28768168261bca161c3f2599e0ed63c96aab6dea' }
Plug 'tyru/caw.vim', { 'commit': '3aefcb5a752a599a9200dd801d6bcb0b7606bf29' }
Plug 'editorconfig/editorconfig-vim', { 'commit': 'a8e3e66deefb6122f476c27cee505aaae93f7109' }
Plug 'mattn/emmet-vim', { 'commit': 'def5d57a1ae5afb1b96ebe83c4652d1c03640f4d' }
Plug 'creativenull/projectlocal-vim', { 'tag': 'v0.4.3' }

" File Explorer + Addons
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim', { 'tag': 'v1.46.0' }
Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'commit': '1a3719f226edc27e7241da7cda4bc4d4c7db889c' }

" Linters + Formatters
Plug 'dense-analysis/ale'

" Builtin LSP Configs
Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.3' }
Plug 'creativenull/nvim-ale-diagnostic', { 'branch': 'v2' }

" AutoCompletion + Sources
Plug 'Shougo/ddc.vim'
Plug 'Shougo/pum.vim'
Plug 'matsui54/denops-popup-preview.vim'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-buffer'
Plug 'hrsh7th/vim-vsnip-integ'

" Snippet Engine + Presets
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'

" Fuzzy File/Code Finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Git
Plug 'lambdalisue/gin.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'

" JS/TS
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' }

" Vue
Plug 'posva/vim-vue'

" PHP
Plug 'jwalton512/vim-blade'

" JSON/JSONC
Plug 'elzr/vim-json'
Plug 'kevinoid/vim-jsonc'

" Vader
Plug 'junegunn/vader.vim'

" Twig templates
Plug 'lumiliet/vim-twig'

" UI Plugins
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Colorschemes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'
Plug 'gruvbox-community/gruvbox'
Plug 'fnune/base16-vim'
Plug 'rigellute/rigel'

call plug#end()

" =============================================================================
" = Plugin Post-Config - after loading plugins (POST) =
" =============================================================================

" nvim-lspconfig Config
" ---
lua require('cnull.lsp')

" fzf.vim Config
" ---
call cnull#fzf#Setup()

" pum.vim Config
" ---
call cnull#pum#Setup()

" ddc.vim Config
" ---
call cnull#ddc#Setup()

" ale Config
" ---
call cnull#ale#Setup()

" lightline.vim Config
" ---
call cnull#lightline#Setup()

" =============================================================================
" = Colorscheme =
" =============================================================================

" moonfly Config
" ---
let g:moonflyTransparent = 1
let g:moonflyNormalFloat = 1
let g:moonflyItalics = 0

" gruvbox Config
" ---
let g:gruvbox_bold = 0
let g:gruvbox_italic = 0
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_sign_column = 'bg0'

colorscheme moonfly
