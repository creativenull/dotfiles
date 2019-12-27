" =============================================================
" CreativeNobu - (neo)vim config file
" Cross-platform, runs on Linux, Windows and OS X (maybe?)
" =============================================================

filetype plugin indent on
set encoding=utf-8

" Python host
let g:python3_host_prog=$PYTHON3_HOST_PROG
let g:python_host_prog=$PYTHON_HOST_PROG

" Sort install dir for plugins
let g:nobu_config_dir='~/.config/nvim'
let g:nobu_local_dir='~/.local/share/nvim'
let g:nobu_plugins_dir='~/.local/share/nvim/plugged'

if has('win32')
    let g:nobu_config_dir='~/AppData/Local/nvim'
    let g:nobu_local_dir=g:nobu_config_dir
    let g:nobu_plugins_dir='~/AppData/Local/nvim/plugged'
endif

" =============================================================
" = Vim.plug =
" =============================================================

call plug#begin(g:nobu_plugins_dir)
    " ======== Core ========
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-surround'
    Plug 'airblade/vim-gitgutter'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'mattn/emmet-vim'
    Plug 'godlygeek/tabular'

    " ======== Syntax Highlighting ========
    Plug 'sheerun/vim-polyglot'
    Plug 'yggdroot/indentline'

    " ======== Theme and Look ========
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'gruvbox-community/gruvbox'
call plug#end()

" =============================================================
" = Plugin Options =
" =============================================================

" --- NERDTree Options ---
nnoremap <F3> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinPos='right'
let g:NERDTreeShowHidden=1

" --- NERD Commenter Options ---
let g:NERDSpaceDelims=1
let g:NERDTrimTrailingWhitespace=1

" --- Fuzzy Finder Options ---
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_user_command=['.git', 'cd %s && git ls-files -co --exclude-standard']

" --- vim-polyglot Options ---
let g:vue_pre_processors=['typescript', 'scss']

" --- Airline Options ---
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='jsformatter'
let g:airline_powerline_fonts=1

" =============================================================
" = General =
" =============================================================

" Search options
set ignorecase
set smartcase

" Indent options
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
set smartindent

" Line options
set linebreak
set showbreak=+++
set textwidth=120
set showmatch

" Performance options
set lazyredraw
set scrolloff=3

" No backups or swapfiles needed
set nobackup
set nowritebackup
set nowb
set noswapfile

" Undo history
set undolevels=1000

" Buffers/Tabs/Windows
set hidden

" Set vim update time to 100ms
set updatetime=750

" Set spelling
set nospell

" For git
set signcolumn=yes

" Mouse support
set mouse=a

" File format type
set fileformats=unix,dos

" no sounds
set visualbell

" backspace behaviour
set backspace=indent,eol,start

" Do not show insert twice
set noshowmode

" Better display
set cmdheight=2

" no ins-completion-menu
set shortmess+=c

" =============================================================
" = Theming and Looks =
" =============================================================

syntax on
set number
set termguicolors
set relativenumber

" Theme
colorscheme gruvbox
set background=dark

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
inoremap <C-s> <C-[>:w<CR>

" Safely exit vim
nnoremap <C-x> :q<CR>

" Copy/Paste from clipboard
vnoremap <C-c> "+y<CR>
nnoremap <C-o> "+p<CR>

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
nnoremap <C-l> :bnext<CR>
" Go to previous buffer
nnoremap <C-h> :bprevious<CR>
" Close the current buffer
nnoremap <leader>bd :bp<BAR>sp<BAR>bn<BAR>bd<CR>
" Open a terminal in new buffer
nnoremap <leader>tn :enew<CR>:term<CR>
" Open termnal in Vertical split
nnoremap <leader>tv :vsplit<CR><C-w>l:term<CR>
" Open terminal in Horizontal split
nnoremap <leader>th :split<CR><C-w>j:term<CR>

" Window maps
" ---
" move to the split in the direction shown, or create a new split
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>

" Switch between windows
nnoremap <TAB> <C-w>w
nnoremap <S-TAB> <C-w><S-w>

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
" Config file
nnoremap <leader>fve :e $MYVIMRC<CR>
nnoremap <leader>fvs :so $MYVIMRC<CR>

" Auto groups and commands
" ---
" Set the .h file to be a C filetype
augroup ctype
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

" Language Client shortcuts (LSP)
function! Set_LSPKeys()
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lr <Plug>(coc-rename)
    nmap <silent> <leader>lf :call CocAction('format')<cr>
    nmap <silent> <leader>lh :call CocAction('doHover')<cr>
    nmap <silent> <leader>l] <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>l[ <Plug>(coc-diagnostic-prev)
endfunction()

augroup lsp
    autocmd!
    autocmd FileType javascript,javascript.jsx call Set_LSPKeys()
    autocmd FileType typescript,typescript.tsx call Set_LSPKeys()
    autocmd FileType vue call Set_LSPKeys()
    autocmd FileType php call Set_LSPKeys()
augroup END

" Spell checker (SPELL)
augroup spell
    autocmd!
    autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

" Support transparent background if possible
augroup transparent_support
    autocmd!
    autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
augroup END
