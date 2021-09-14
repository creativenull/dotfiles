" Name: Arnold Chand
" Github: https://github.com/creativenull
" File: init.vim
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + python3 (globally installed)
"   + ripgrep (globally installed
"   + Environment variables: $PYTHON3_HOST_PROG
" =============================================================================

let userspace = 'nvim-nightly'

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

execute printf('set runtimepath+=~/.config/%s/after', userspace)
execute printf('set runtimepath^=~/.config/%s', userspace)
execute printf('set runtimepath+=~/.local/share/%s/site/after', userspace)
execute printf('set runtimepath^=~/.local/share/%s/site', userspace)

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

execute printf('set packpath^=~/.config/%s', userspace)
execute printf('set packpath+=~/.config/%s/after', userspace)
execute printf('set packpath^=~/.local/share/%s/site', userspace)
execute printf('set packpath+=~/.local/share/%s/site/after', userspace)

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

function! g:ToggleConcealLevel() abort
  if &conceallevel == 2
    set conceallevel=0
  else
    set conceallevel=2
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
let g:python3_host_prog = $PYTHON3_HOST_PROG

let cnull = {}
let cnull.transparent = v:true
let cnull.config = {}
let cnull.config.undodir = expand(printf('$HOME/.cache/%s/undo', userspace))

" =============================================================================
" = Events =
" =============================================================================

if cnull.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=NONE
    autocmd ColorScheme * highlight SignColumn guibg=NONE
    autocmd ColorScheme * highlight LineNr guibg=NONE
    autocmd ColorScheme * highlight CursorLineNr guibg=NONE
    autocmd ColorScheme * highlight EndOfBuffer guibg=NONE
    autocmd ColorScheme * highlight FloatBorder guifg=#aaaaaa guibg=NONE
  augroup END
endif

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" UltiSnips/vim-snippets Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'

" indentLine Config
" ---
let g:indentLine_char = '│'

" fern.vim Config
" ---
let g:fern#renderer = 'nerdfont'

function! g:FernLoad() abort
  if !exists('g:loaded_fern') && !exists('g:loaded_fix_cursorhold_nvim')
    packadd FixCursorHold.nvim
    packadd fern.vim
    packadd nerdfont.vim
    packadd fern-renderer-nerdfont.vim
  endif
  execute 'Fern . -reveal=%'
endfunction

nnoremap <silent> <Leader>ff <Cmd>call FernLoad()<CR>

" projectlocal-vim Config
" ---
let g:projectlocal = {}
let g:projectlocal.projectConfig = '.vim/init.lua'

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! PackagerInit(opts) abort
  packadd vim-packager
  call packager#init(a:opts)
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " Deps
  call packager#add('nvim-lua/plenary.nvim')
  call packager#add('vim-denops/denops.vim')
  call packager#add('kyazdani42/nvim-web-devicons')
  call packager#add('Shougo/context_filetype.vim')

  " Core
  call packager#add('windwp/nvim-autopairs')
  call packager#add('tpope/vim-abolish')
  call packager#add('tpope/vim-surround')
  call packager#add('tpope/vim-repeat')
  call packager#add('editorconfig/editorconfig-vim')
  call packager#add('creativenull/projectlocal-vim')
  call packager#add('b3nj5m1n/kommentary')
  call packager#add('kevinhwang91/nvim-bqf')

  " File Explorer
  call packager#add('antoinemadec/FixCursorHold.nvim', { 'type': 'opt' })
  call packager#add('lambdalisue/fern.vim', { 'type': 'opt' })
  call packager#add('lambdalisue/nerdfont.vim', { 'type': 'opt' })
  call packager#add('lambdalisue/fern-renderer-nerdfont.vim', { 'type': 'opt' })

  " LSP/Linter/Formatter
  call packager#add('neovim/nvim-lspconfig')
  call packager#add('creativenull/diagnosticls-configs-nvim')

  " AutoCompletion
  call packager#add('hrsh7th/nvim-cmp')
  call packager#add('hrsh7th/cmp-nvim-lsp')
  call packager#add('quangnguyen30192/cmp-nvim-ultisnips')
  " call packager#add('Shougo/ddc.vim')
  " call packager#add('Shougo/ddc-sorter_rank')
  " call packager#add('matsui54/ddc-matcher_fuzzy')
  " call packager#add('Shougo/ddc-around')
  " call packager#add('matsui54/ddc-ultisnips')
  " call packager#add('Shougo/ddc-nvim-lsp')
  " call packager#add('matsui54/ddc-nvim-lsp-doc')

  " Snippets
  call packager#add('SirVer/ultisnips')
  call packager#add('honza/vim-snippets')
  call packager#add('mattn/emmet-vim')

  " Fuzzy Finder
  call packager#add('nvim-telescope/telescope.nvim')

  " Git
  call packager#add('lewis6991/gitsigns.nvim')

  " UI Plugins
  call packager#add('nvim-treesitter/nvim-treesitter')
  call packager#add('nvim-treesitter/nvim-treesitter-refactor')
  call packager#add('code-biscuits/nvim-biscuits')
  call packager#add('akinsho/nvim-bufferline.lua')
  call packager#add('folke/todo-comments.nvim')
  call packager#add('glepnir/galaxyline.nvim')
  call packager#add('norcalli/nvim-colorizer.lua')

  " Colorschemes
  call packager#add('bluz71/vim-nightfly-guicolors')
  call packager#add('bluz71/vim-moonfly-colors')
endfunction

let cnull.plugin = {}
let cnull.plugin.git = 'https://github.com/kristijanhusak/vim-packager.git'
let cnull.plugin.path = expand(printf('$HOME/.local/share/%s/site/pack/packager/opt/vim-packager', userspace))
let cnull.plugin.opts = {}
let cnull.plugin.opts.dir = expand(printf('$HOME/.local/share/%s/site/pack/packager', userspace))

" Package manager bootstrapping strategy
if !isdirectory(cnull.plugin.path)
  execute printf('!git clone %s %s', cnull.plugin.git, cnull.plugin.path)
  call PackagerInit(cnull.plugin.opts)
  call packager#install()
endif

command! -bar -nargs=* PackagerInstall call PackagerInit(cnull.plugin.opts) | call packager#install(<args>)
command! -bar -nargs=* PackagerUpdate call PackagerInit(cnull.plugin.opts) | call packager#update(<args>)
command! -bar PackagerClean call PackagerInit(cnull.plugin.opts) | call packager#clean()
command! -bar PackagerStatus call PackagerInit(cnull.plugin.opts) | call packager#status()

" =============================================================================
" = Plugin Post-Config - after loading plugins =
" =============================================================================

" nvim-lspconfig Config
" ---
lua require('cnull.lsp')

" ddc.vim Config
" ---
lua require('cnull.autocompletion')

augroup autocompletion_user_events
  autocmd!
  autocmd FileType TelescopePrompt lua require('cmp').setup.buffer({ completion = false })
  "autocmd BufEnter,BufNew * if &filetype == 'TelescopePrompt' | call ddc#disable() | else | call ddc#enable() | endif
augroup END

" nvim-autopairs Config
" ---
lua require('nvim-autopairs').setup({})

" gitsigns.nvim Config
" ---
lua require('gitsigns').setup()

" todo-comments.nvim Config
" ---
lua require('todo-comments').setup({})

" telescope.nvim Config
" ---
lua require('cnull.finder')
nnoremap <C-p> <Cmd>lua TelescopeFindFiles()<CR>
nnoremap <C-t> <Cmd>lua TelescopeLiveGrep()<CR>
nnoremap <Leader>vf <Cmd>lua TelescopeFindConfigFiles()<CR>

augroup telescope_user_events
  autocmd!
  autocmd ColorScheme * highlight TelescopeBorder guifg=#aaaaaa
augroup END

" nvim-treesitter Config
" ---
lua require('cnull.treesitter')

" nvim-biscuits Config
" ---
lua require('cnull.biscuits')
nnoremap <Leader>it <Cmd>lua ToggleBiscuits()<CR>

" galaxyline.nvim Config
" ---
lua require('cnull.statusline')

" =============================================================================
" = UI/Theme =
" =============================================================================

set termguicolors

lua <<EOF
-- bufferline.lua Config
-- ---
require('bufferline').setup({
  options = {
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
})

-- nvim-colorizer.lua Config
-- ---
require('colorizer').setup({
  'css',
  'html',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
})
EOF

let g:moonflyNormalFloat = 1

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

" System
set encoding=utf-8
set nobackup
set noswapfile
set updatetime=250
set undofile
let &undodir=cnull.config.undodir
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

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | nohlsearch

command! ToggleConcealLevel call ToggleConcealLevel()
command! ToggleCodeshot call ToggleCodeshot()
