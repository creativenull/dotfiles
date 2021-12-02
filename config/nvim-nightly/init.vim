" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc works with MacOS, Linux and Windows, requires
"   + curl (globally installed)
"   + git (globally installed)
"   + python3 (globally installed)
"   + ripgrep (globally installed
" =============================================================================

let g:userspace = 'nvim-nightly'
if exists('g:userspace')
  " Runtime Path
  set runtimepath-=~/.config/nvim
  set runtimepath-=~/.config/nvim/after
  set runtimepath-=~/.local/share/nvim/site
  set runtimepath-=~/.local/share/nvim/site/after
  set runtimepath-=/etc/xdg/nvim
  set runtimepath-=/etc/xdg/nvim/after
  set runtimepath-=/usr/share/nvim/site
  set runtimepath-=/usr/share/nvim/site/after
  set runtimepath-=/usr/local/share/nvim/site
  set runtimepath-=/usr/local/share/nvim/site/after

  execute printf('set runtimepath+=~/.config/%s/after', g:userspace)
  execute printf('set runtimepath^=~/.config/%s', g:userspace)
  execute printf('set runtimepath+=~/.local/share/%s/site/after', g:userspace)
  execute printf('set runtimepath^=~/.local/share/%s/site', g:userspace)

  " Pack Path
  set packpath-=~/.config/nvim
  set packpath-=~/.config/nvim/after
  set packpath-=~/.local/share/nvim/site
  set packpath-=~/.local/share/nvim/site/after
  set packpath-=/etc/xdg/nvim
  set packpath-=/etc/xdg/nvim/after
  set packpath-=/usr/local/share/nvim/site
  set packpath-=/usr/local/share/nvim/site/after
  set packpath-=/usr/share/nvim/site
  set packpath-=/usr/share/nvim/site/after

  execute printf('set packpath^=~/.config/%s', g:userspace)
  execute printf('set packpath+=~/.config/%s/after', g:userspace)
  execute printf('set packpath^=~/.local/share/%s/site', g:userspace)
  execute printf('set packpath+=~/.local/share/%s/site/after', g:userspace)
endif

if !has('nvim') && !has('nvim-0.7')
  echoerr 'This config is only for neovim nightly version aka EXPERIMENTAL!'
  finish
endif

let s:exec_list = ['git', 'curl', 'python3', 'rg', 'deno']
for s:exec in s:exec_list
  if !executable(s:exec)
    echoerr printf('[nvim] `%s` is needed!', s:exec)
    finish
  endif
endfor

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
  else
    setlocal number signcolumn=yes
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
" = Initialize =
" =============================================================================

let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog = exepath('python3')

let g:mapleader = ' '
let s:cnull = {}
let s:cnull.transparent = v:true
let s:cnull.config = {}

if exists('g:userspace')
  let s:cnull.config.data_dir = expand(printf('$HOME/.local/share/%s', userspace))
  let s:cnull.config.cache_dir = expand(printf('$HOME/.cache/%s', userspace))
  let s:cnull.config.config_dir = expand(printf('$HOME/.config/%s', userspace))
  let s:cnull.config.undodir = s:cnull.config.cache_dir . '/undo'
else
  let s:cnull.config.data_dir = stdpath('data')
  let s:cnull.config.cache_dir = stdpath('config')
  let s:cnull.config.config_dir = stdpath('cache')
  let s:cnull.config.undodir = s:cnull.config.cache_dir . '/undo'
endif

" =============================================================================
" = Events =
" =============================================================================

if s:cnull.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * highlight! Normal guibg=NONE
    autocmd ColorScheme * highlight! SignColumn guibg=NONE
    autocmd ColorScheme * highlight! LineNr guibg=NONE
    autocmd ColorScheme * highlight! CursorLineNr guibg=NONE
    autocmd ColorScheme * highlight! EndOfBuffer guibg=NONE
    autocmd ColorScheme * highlight! Visual guifg=#333333 guibg=#aaaaaa
    autocmd ColorScheme * highlight! ColorColumn guifg=#888888

    " Transparent LSP Float Windows
    autocmd ColorScheme * highlight! NormalFloat guibg=NONE
    autocmd ColorScheme * highlight! ErrorFloat guibg=NONE
    autocmd ColorScheme * highlight! WarningFloat guibg=NONE
    autocmd ColorScheme * highlight! InfoFloat guibg=NONE
    autocmd ColorScheme * highlight! HintFloat guibg=NONE
    autocmd ColorScheme * highlight! FloatBorder guifg=#aaaaaa guibg=NONE

    " Transparent Comments
    autocmd ColorScheme * highlight! Comment guifg=#888888 guibg=NONE
  augroup END
endif

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

" Default Filetype Options
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
" = Options =
" =============================================================================

if !isdirectory(s:cnull.config.undodir)
  execute printf('silent !mkdir -p %s', s:cnull.config.undodir)
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
set path=**

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
set scrolloff=3
set lazyredraw
set nospell
set wildignorecase

" System
set encoding=utf-8
set nobackup
set noswapfile
set updatetime=250
set undofile
let &undodir=s:cnull.config.undodir
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
set termguicolors
set number

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

nnoremap <C-l> <Cmd>bnext<CR>
nnoremap <Leader>bn <Cmd>bnext<CR>

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

" Copy/Paste from clipboard
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p

" Disable Ex-mode
nnoremap Q <Nop>

" Utilities
nnoremap Y y$

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call ToggleConcealLevel()
command! ToggleCodeshot call ToggleCodeshot()

" Command Abbreviations, I can't release my shift key fast enough 😭
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev W w
cnoreabbrev Wq wq

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'
let g:user_emmet_install_global = 0

augroup emmet_user_events
  autocmd!
  autocmd FileType html,blade,php,vue,javascriptreact,typescriptreact EmmetInstall
augroup END

" indentLine Config
" ---
let g:indentLine_char = '│'

" projectlocal-vim Config
" ---
let g:projectlocal = {
  \ 'showMessage': v:true,
  \ 'projectConfig': '.vim/init.lua',
  \ 'debug': v:false,
\ }

" vim-json Config
" ---
let g:vim_json_syntax_conceal = 0
let g:vim_json_conceal = 0

" moonfly Config
" ---
let g:moonflyNormalFloat = 1

" lir.nvim Config
" ---
augroup lir_user_events
  autocmd!
  autocmd ColorScheme * highlight! CursorLine guibg=#333333
augroup END

" =============================================================================
" = Plugin Manager =
" =============================================================================

let s:plugin = {}
let s:plugin.url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:plugin.plug_filepath = s:cnull.config.data_dir . '/site/autoload/plug.vim'
let s:plugin.plugins_dir = s:cnull.config.data_dir . '/plugged'

if !filereadable(s:plugin.plug_filepath)
  execute printf('!curl -fLo %s --create-dirs %s', s:plugin.plug_filepath, s:plugin.url)
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:plugin.plugins_dir)

" Deps
Plug 'Shougo/context_filetype.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/nerdfont.vim'

" Core
Plug 'creativenull/projectlocal-vim'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'b3nj5m1n/kommentary'
Plug 'kevinhwang91/nvim-bqf'

" File Explorer
Plug 'tamago324/lir.nvim'

" Linters + Formatters + LSP Client
Plug 'neovim/nvim-lspconfig'
Plug 'creativenull/diagnosticls-configs-nvim'
Plug 'creativenull/efmls-configs-nvim'

" Snippet Engine + Presets
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'mattn/emmet-vim'

" AutoCompletion + Sources
Plug 'Shougo/ddc.vim'
Plug 'matsui54/denops-popup-preview.vim'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-buffer'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'Shougo/ddc-nvim-lsp'

" Fuzzy File/Code Finder
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'

" UI
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'code-biscuits/nvim-biscuits'
Plug 'akinsho/bufferline.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lukas-reineke/indent-blankline.nvim'

" Colorschemes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'
Plug 'fnune/base16-vim'

call plug#end()

" =============================================================================
" = Plugin Post-Config - after loading plugins =
" =============================================================================

" nvim-lspconfig Config
" ---
lua require('cnull.lsp')

" ddc.vim Config
" ---
lua require('cnull.autocompletion')

inoremap <silent> <expr> <C-Space> ddc#map#manual_complete()

" nvim-autopairs Config
" ---
lua require('nvim-autopairs').setup()

" gitsigns.nvim Config
" ---
lua require('gitsigns').setup()

" todo-comments.nvim Config
" ---
lua require('todo-comments').setup()

" telescope.nvim Config
" ---
lua require('cnull.finder')

nnoremap <C-p> <Cmd>lua TelescopeFindFiles()<CR>
nnoremap <C-t> <Cmd>lua TelescopeLiveGrep()<CR>
nnoremap <Leader>vf <Cmd>lua TelescopeFindConfigFiles()<CR>

if s:cnull.transparent
  augroup telescope_user_events
    autocmd!
    autocmd ColorScheme * highlight! TelescopeBorder guifg=#aaaaaa
  augroup END
endif

" nvim-treesitter Config
" ---
lua require('cnull.treesitter')

" nvim-biscuits Config
" ---
lua require('cnull.biscuits')

nnoremap <Leader>it <Cmd>lua require('nvim-biscuits').toggle_biscuits()<CR>

" lualine.nvim Config
" ---
lua require('cnull.statusline')

" indent-blankline.nvim Config
" ---
if s:cnull.transparent
  augroup indent_blankline_user_events
    autocmd!
    autocmd ColorScheme * highlight! IndentBlanklineHighlight guifg=#777777 guibg=NONE
  augroup END
else
  augroup indent_blankline_user_events
    autocmd!
    autocmd ColorScheme * highlight! IndentBlanklineHighlight guifg=#444444 guibg=NONE
  augroup END
endif

lua require('cnull.indent_blankline')

" bufferline.lua Config
" ---
lua require('cnull.bufferline')

" lir.nvim Config
" ---
lua require('cnull.explorer')

" colorizer.lua Config
" ---
lua require('cnull.colorizer')

" =============================================================================
" = UI/Theme =
" =============================================================================

colorscheme base16-horizon-terminal-dark
