" =============================================================
" = Vim.plug =
" =============================================================
call plug#begin('~/.local/share/nvim/plugged')

" ======== Essentials ========
" File explorer
Plug 'scrooloose/nerdtree'
" Make commenting easy
Plug 'scrooloose/nerdcommenter'
" Git checker
Plug 'airblade/vim-gitgutter'
" Editor Config
Plug 'editorconfig/editorconfig-vim'
" Auto close parenthesis
Plug 'jiangmiao/auto-pairs'
" Auto-completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Tab for auto-completion
Plug 'ervandew/supertab'
" Language client for a Language Server Protocol support
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }

" ======== Syntax Highlighting ========
" Javascript
Plug 'pangloss/vim-javascript'
" Typescript
Plug 'leafgarland/typescript-vim'
" Vue
Plug 'posva/vim-vue'

" ======== Themes ========
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kaicataldo/material.vim'

call plug#end()

" Plugin and Indent enable
filetype plugin indent on

" =============================================================
" = Plugin Options =
" =============================================================

" --- NERDTree Options ---
" Auto close NERD Tree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinPos='right'
let g:NERDTreeShowHidden=1

" Toggle File explorer
nnoremap <C-e> :NERDTreeToggle<CR>

" --- Deoplete Options ---
let g:deoplete#enable_at_startup=1

" --- SuperTab Options --- 
let g:SuperTabDefaultCompletionType='<C-n>'

" --- LanguageClient Options --- 
let g:LanguageClient_autoStart=1
let g:LanguageClient_loggingLevel='INFO'
let g:LanguageClient_loggingFile= expand('~/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_serverStderr=expand('~/.local/share/nvim/LanguageServer.log')
let g:LanguageClient_rootMarkers={
	\ 'rust': ['cargo.toml'],
	\ 'go': ['main.go'],
	\ }
let g:LanguageClient_serverCommands={
	\ 'rust': ['rustup', 'run', 'stable', 'rls'],
	\ 'go': ['bingo', '--format-style', 'goimports'],
	\ 'javascript': ['javascript-typescript-stdio'],
	\ 'typescript': ['javascript-typescript-stdio'],
	\ }

" =============================================================
" = General =
" =============================================================

" Set directory specific config for nvim
set exrc " Will look for .exrc/.nvimrc file in the current directory
set secure " Avoid any write or commands on non-default config file

" Set 5 line space between cursor and navigation up/down
set so=5

" Wild menu
set wildmenu

" Show current position
set ruler

" Search properties
set ignorecase
set hlsearch
set incsearch
set magic

" For better performance?
set lazyredraw

" File backups off
set nobackup
set nowb
set noswapfile

" Disable preview window
set completeopt-=preview

" Set vim update time to 100ms
set updatetime=100

" =============================================================
" = Key Bindings =
" =============================================================

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <ESC>

" Map escape from terminal input to Normal mode
tnoremap <C-[> <C-\><C-n>

" Quick save
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Quick exit
nnoremap <C-x> :q<CR>

" Copy/Paste key bindings in Visual mode
vnoremap <C-c> "+y<CR>

" Switch windows
nnoremap <TAB> <C-w><C-w>
nnoremap <S-TAB> <C-w><S-w>

" Leader Map
let mapleader=','

" Disable highlights
noremap <leader><CR> :noh<CR>

" Horizontal and Vertical split and resize
nnoremap <leader>hs :split<CR>
nnoremap <leader>vs :vsplit<CR>

nnoremap <up> :resize +2<CR>
nnoremap <down> :resize -2<CR>
nnoremap <left> :vertical resize -2<CR>
nnoremap <right> :vertical resize +2<CR>

" Set no ops
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Buffer maps
" List all buffers
nnoremap <leader>bl :buffers<CR>
" Create a new buffer
nnoremap <leader>bn :enew<CR>
" Go to next buffer
nnoremap <C-l> :bnext<CR>
" Go to previous buffer
nnoremap <C-h> :bprevious<CR>
" Close the current buffer
nnoremap <leader>x :bd<CR>
" Open a terminal in new buffer
nnoremap <leader>tb :enew<CR>:term<CR>
" Open termnal in Vertical split
nnoremap <leader>tv :vsplit<CR><C-w>l:term<CR>
" Open terminal in Horizontal split
nnoremap <leader>th :split<CR><C-w>j:term<CR>

" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Vim settings .vimrc
nnoremap <leader>ve :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>vr :so ~/.config/nvim/init.vim<CR>

" Langauge client menu call
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" =============================================================
" = Theming and Looks =
" =============================================================
syntax on
set number
set relativenumber
set termguicolors
set cursorline
set noshowmode

" Theme
set background=dark
let g:material_theme_style='dark'
let g:material_terminal_italics=1
colorscheme material

" Airline options
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'

set fileformats=unix,dos,mac

set title
set hidden
set smarttab
set smartindent
set autoindent

set linebreak
set textwidth=500

set shiftwidth=8
set softtabstop=8
set wrap
