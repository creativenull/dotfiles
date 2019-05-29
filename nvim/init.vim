" =============================================================
" = Vim.plug =
" =============================================================
call plug#begin('~/.local/share/nvim/plugged')

" ======== Essentials ========
" File explorer
Plug 'scrooloose/nerdtree'
" Make commenting easy
Plug 'scrooloose/nerdcommenter'
" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Editor Config
Plug 'editorconfig/editorconfig-vim'
" Auto close parenthesis
Plug 'jiangmiao/auto-pairs'
" Auto-completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Tab for auto-completion
Plug 'ervandew/supertab'
" Language client for a Language Server Protocol support
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Fuzzy file finder
Plug 'junegunn/fzf'
" Emmet
Plug 'mattn/emmet-vim'

" ======== Syntax Highlighting ========
" JavaScript (js/ts/jsx/tsx)
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
" Vue
Plug 'posva/vim-vue'

" ======== Themes ========
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'jacoborus/tender.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }

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
nnoremap <F2> :NERDTreeToggle<CR>

" --- Deoplete Options ---
let g:deoplete#enable_at_startup=1

" --- SuperTab Options ---
let g:SuperTabDefaultCompletionType='<C-n>'

" --- LanguageClient Options ---
let g:LanguageClient_rootMarkers={
			\ 'c': ['Makefile'],
			\ 'cpp': ['CMakeLists.txt'],
			\ 'go': ['.go-lsp'],
			\ 'rust': ['cargo.toml'],
			\ 'javascript': ['jsconfig.json'],
			\ 'typescript': ['tsconfig.json'],
			\ }
let g:LanguageClient_serverCommands={
			\ 'c': ['cquery', '--log-file=/tmp/cq.log'],
			\ 'cpp': ['clangd'],
			\ 'go': ['go-langserver',
			\ '-gocodecompletion',
			\ '-lint-tool', 'golint',
			\ '-diagnostics'],
			\ 'rust': ['rustup', 'run', 'stable', 'rls'],
			\ 'javascript': ['javascript-typescript-stdio'],
			\ 'javascript.jsx': ['javascript-typescript-stdio'],
			\ 'typescript': ['javascript-typescript-stdio'],
			\ 'typescript.tsx': ['javascript-typescript-stdio'],
			\ }
let g:LanguageClient_selectionUI='fzf'
let g:LanguageClient_loggingLevel='INFO'
let g:LanguageClient_loggingFile=expand('$HOME/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_serverStderr=expand('$HOME/.local/share/nvim/LanguageServer.log')
let g:LanguageClient_useVirtualText=0

" =============================================================
" = General =
" =============================================================

" Set the .h file to be a C filetype
autocmd BufRead,BufNewFile *.h,*.c set filetype=c

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
set smartcase

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
" = Theming and Looks =
" =============================================================
syntax on
set number
set relativenumber
set termguicolors
set cursorline
set noshowmode

" Theme
colorscheme onehalfdark
set background=dark

" Airline options
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline_powerline_fonts=1

set fileformats=unix,dos,mac

set title
set hidden
set smarttab
set smartindent
set autoindent

set linebreak
set textwidth=500

set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set wrap
set signcolumn=yes

" =============================================================
" = Key Bindings =
" =============================================================

" Unbind default bindings for arrow keys
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap <C-x> <nop>
inoremap <C-x> <nop>

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <C-[>

" Map escape from terminal input to Normal mode
tnoremap <C-[> <C-\><C-n>

" Quick save
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Safely exit vim
nnoremap <C-x> :q<CR>

" Copy/Paste key bindings in Visual mode
vnoremap <C-c> "+y<CR>
inoremap <C-v> <Esc>"+p<CR>

" Leader Map
let mapleader=' '

" Disable highlights
noremap <leader><CR> :noh<CR>

" Buffer maps
" ---
" List all buffers
nnoremap <leader>bl :buffers<CR>
" Create a new buffer
nnoremap <leader>bn :enew<CR>
" Go to next buffer
nnoremap <TAB> :bnext<CR>
" Go to previous buffer
nnoremap <S-TAB> :bprevious<CR>
" Close the current buffer
nnoremap <leader>bd :bp <BAR> bd! #<CR>

" Open a terminal in new buffer
nnoremap <leader>tn :enew<CR>:term<CR>
" Open termnal in Vertical split
nnoremap <leader>tv :vsplit<CR><C-w>l:term<CR>
" Open terminal in Horizontal split
nnoremap <leader>th :split<CR><C-w>j:term<CR>

" Window maps
" ---
" move to the split in the direction shown, or create a new split
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>

function! WinMove(key)
	let t:curwin = winnr()
	exec "wincmd ".a:key
	if (t:curwin == winnr())
		if (match(a:key,'[jk]'))
			wincmd v
		else
			wincmd s
		endif
		exec "wincmd ".a:key
	endif
endfunction

" Resize window panes
nnoremap <up> :resize +2<CR>
nnoremap <down> :resize -2<CR>
nnoremap <left> :vertical resize -2<CR>
nnoremap <right> :vertical resize +2<CR>

" Text maps
" ---
" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Misc maps
" ---
" File options
nnoremap <leader>fv :e $MYVIMRC<CR>
nnoremap <leader>fgv :e $HOME/.config/nvim/ginit.vim<CR>

" Source the current file
nnoremap <leader>fs :so %<CR>

" LanguageClient bindings
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>

" FZF key binding
nnoremap <C-p> :FZF<CR>
