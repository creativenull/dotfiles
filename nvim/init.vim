" =============================================================
" CreativeNobu - (neo)vim config file
" Cross-platform, runs on Linux, Windows and OS X (maybe?)
" =============================================================

" Plugin and Indent enable
filetype plugin indent on

" Python host
let g:python3_host_prog=$PYTHON3_HOST_PROG
let g:python_host_prog=$PYTHON_HOST_PROG

" Sort install dir for plugins
let g:nobu_config_dir='~/.config/nvim'
let g:nobu_local_dir='~/.local/share/nvim'
let g:nobu_plugins_dir='~/.local/share/nvim/plugged'
let g:nobu_lsp_opts='bash install.sh'

" For npm bin installed in windows
let g:nobu_npm_wincmd=''

if has('win32')
    let g:nobu_config_dir='~/AppData/Local/nvim'
    let g:nobu_local_dir=g:nobu_config_dir
    let g:nobu_plugins_dir='~/AppData/Local/nvim/plugged'
    let g:nobu_lsp_opts='powershell -executionpolicy bypass -File install.ps1'
    let g:nobu_npm_wincmd='.cmd'
endif

" =============================================================
" = Vim.plug =
" =============================================================
call plug#begin(g:nobu_plugins_dir)
    " ======== Essentials ========

    " File explorer
    Plug 'scrooloose/nerdtree'

    " Make commenting easy
    Plug 'scrooloose/nerdcommenter'

    " Make surrounding easy
    Plug 'tpope/vim-surround'

    " Git
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    " Editor Config
    Plug 'editorconfig/editorconfig-vim'

    " Auto close parenthesis
    Plug 'jiangmiao/auto-pairs'

    " Auto-completion
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    " LSP client
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': g:nobu_lsp_opts,
        \ }

    " Fuzzy file finder
    if has('win32')
        Plug 'ctrlpvim/ctrlp.vim'
    else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
    endif

    " Emmet
    Plug 'mattn/emmet-vim'

    " ======== Syntax Highlighting ========
    Plug 'sheerun/vim-polyglot'
    Plug 'thaerkh/vim-indentguides'

    " ======== Themes ========
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'gruvbox-community/gruvbox'
    Plug 'TaDaa/vimade'
call plug#end()

" =============================================================
" = Plugin Options =
" =============================================================

" --- NERDTree Options ---
nnoremap <F3> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinPos='right'
let g:NERDTreeShowHidden=1

" --- Fuzzy Finder Options ---
if has('win32')
    let g:ctrlp_cmd='CtrlP'
    let g:ctrlp_show_hidden=1
    let g:ctrlp_custom_ignore={
        \ 'dir' : '\.git$\|build$\|node_modules$\|dist$\|vendor$\|public$\|target',
        \ }
else
    nnoremap <C-p> :FZF<CR>
endif

" --- Deoplete Options ---
let g:deoplete#enable_at_startup=1

" --- LanguageClient Options ---
let g:LanguageClient_loadSettings=1
let g:LanguageClient_settingsPath=g:nobu_config_dir .'/settings.json'
let g:LanguageClient_rootMarkers={
    \ 'c':          ['Makefile'],
    \ 'cpp':        ['CMakeLists.txt'],
    \ 'rust':       ['cargo.toml'],
    \ 'javascript': ['jsconfig.json'],
    \ 'typescript': ['tsconfig.json'],
    \ }
let g:LanguageClient_serverCommands={
    \ 'c':              ['cquery', '--log-file=/tmp/cq.log'],
    \ 'cpp':            ['clangd'],
    \ 'go':             ['go-langserver', '-gocodecompletion', '-lint-tool', 'golint', '-diagnostics'],
    \ 'rust':           ['rustup', 'run', 'stable', 'rls'],
    \ 'php':            ['intelephense' . g:nobu_npm_wincmd, '--stdio'],
    \ 'javascript':     ['typescript-language-server' . g:nobu_npm_wincmd, '--stdio'],
    \ 'javascript.jsx': ['typescript-language-server' . g:nobu_npm_wincmd, '--stdio'],
    \ 'typescript':     ['typescript-language-server' . g:nobu_npm_wincmd, '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server' . g:nobu_npm_wincmd, '--stdio'],
    \ 'vue':            ['vls' . g:nobu_npm_wincmd],
    \ }
let g:LanguageClient_loggingFile=expand(g:nobu_local_dir . '/LanguageClient.log')
let g:LanguageClient_serverStderr=expand(g:nobu_local_dir . '/LanguageServer.log')

" --- vim-polyglot Options ---
let g:vue_pre_processors=['typescript', 'scss']

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
set signcolumn=auto

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

" Airline options
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='jsformatter'
let g:airline_powerline_fonts=1

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
    nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
    nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
    nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
    nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
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
