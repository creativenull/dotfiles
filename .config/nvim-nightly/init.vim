" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc, currently tested on a Linux machine. Requires:
"   + python3 (globally installed)
"   + ripgrep (globally installed
"   + Environment variables: $PYTHON3_HOST_PROG
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
endif

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

let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:python3_host_prog = $PYTHON3_HOST_PROG

let g:mapleader = ' '
let g:cnull = {}
let g:cnull.transparent = v:true
let g:cnull.config = {}

if exists('g:userspace')
  let g:cnull.config.data_dir = expand(printf('$HOME/.local/share/%s', userspace))
  let g:cnull.config.cache_dir = expand(printf('$HOME/.cache/%s', userspace))
  let g:cnull.config.config_dir = expand(printf('$HOME/.config/%s', userspace))
  let g:cnull.config.undodir = g:cnull.config.cache_dir . '/undo'
else
  let g:cnull.config.data_dir = stdpath('data')
  let g:cnull.config.cache_dir = stdpath('config')
  let g:cnull.config.config_dir = stdpath('cache')
  let g:cnull.config.undodir = g:cnull.config.cache_dir . '/undo'
endif

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
    autocmd ColorScheme * highlight FloatBorder guifg=#aaaaaa guibg=NONE
    autocmd ColorScheme * highlight Visual guifg=#333333 guibg=#aaaaaa
  augroup END
endif

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

" Default Filetype Options
augroup filetype_option_user_events
  autocmd!
  autocmd FileType lua,vim setlocal tabstop=2 softtabstop=2 shiftwidth=0 expandtab
augroup END

" =============================================================================
" = Plugin Pre-Config - before loading plugins =
" =============================================================================

" UltiSnips/vim-snippets Config
" ---
let g:UltiSnipsExpandTrigger = '<C-q>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

augroup ultisnips_user_events
  autocmd!
  autocmd FileType javascriptreact UltiSnipsAddFiletypes javascript
  autocmd FileType typescriptreact UltiSnipsAddFiletypes typescript
augroup END

" emmet-vim Config
" ---
let g:user_emmet_leader_key = '<C-q>'
let g:user_emmet_install_global = 0

augroup emmet_user_events
  autocmd!
  autocmd FileType html,blade,javascriptreact,typescriptreact EmmetInstall
augroup END

" indentLine Config
" ---
let g:indentLine_char = '│'

" fern.vim Config
" ---
let g:fern#renderer = 'nerdfont'

function! g:FernUserKeymaps() abort
  " Quit fern
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
endfunction

nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

augroup fern_user_events
  autocmd!
  autocmd FileType fern call FernUserKeymaps()
augroup END

" projectlocal-vim Config
" ---
let g:projectlocal = {
  \ 'showMessage': v:true,
  \ 'projectConfig': '.vim/init.lua',
  \ 'debug': v:false,
\ }

" =============================================================================
" = Plugin Manager =
" =============================================================================

let s:plugin = {}
let s:plugin.url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:plugin.plug_filepath = g:cnull.config.data_dir . '/site/autoload/plug.vim'
let s:plugin.plugins_dir = g:cnull.config.data_dir . '/plugged'

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
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'creativenull/projectlocal-vim'
Plug 'b3nj5m1n/kommentary'
Plug 'kevinhwang91/nvim-bqf'

" File Explorer + Addons
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

" Linters + Formatters + LSP Client
Plug 'neovim/nvim-lspconfig'
Plug 'creativenull/diagnosticls-configs-nvim'

" AutoCompletion + Sources
Plug 'Shougo/ddc.vim'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-buffer'
Plug 'matsui54/ddc-ultisnips'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'matsui54/ddc-nvim-lsp-doc'

" Snippet Engine + Presets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'

" Fuzzy File/Code Finder
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'

" UI Plugins
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'code-biscuits/nvim-biscuits'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'folke/todo-comments.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" Colorschemes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'

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

function! g:TabCompletion() abort
  if pumvisible()
    if UltiSnips#CanExpandSnippet()
      return "\<C-r>=UltiSnips#ExpandSnippet()\<CR>"
    else
      return "\<C-y>"
    endif
  else
    return "\<Tab>"
  endif
endfunction

inoremap <silent> <expr> <Tab> TabCompletion()
inoremap <silent> <expr> <C-Space> ddc#manual_complete()

call ddc_nvim_lsp_doc#enable()
call ddc#enable()

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

if g:cnull.transparent
  augroup telescope_user_events
    autocmd!
    autocmd ColorScheme * highlight TelescopeBorder guifg=#aaaaaa
  augroup END
endif

" nvim-treesitter Config
" ---
lua require('cnull.treesitter')

" nvim-biscuits Config
" ---
lua require('cnull.biscuits')

nnoremap <Leader>it <Cmd>lua ToggleBiscuits()<CR>

" lualine.nvim Config
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
  'vim',
})
EOF

let g:moonflyNormalFloat = 1

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

" Disable Ex-mode
nnoremap Q <Nop>

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
