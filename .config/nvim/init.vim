" Name: Arnold Chand
" Github: https://github.com/creativenull
" File: .vimrc/init.vim
" Description: My vimrc, pre-requisites:
"              + vim-plug
"              + ripgrep
"              + Set environment variables: $PYTHON3_HOST_PROG,
"                $NVIMRC_PLUGINS_DIR, $NVIMRC_CONFIG_DIR
"
"              Currently, tested on a Linux machine.
" =============================================================================

filetype plugin indent on

" Global variable to use for config
" ---
let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG
let g:plugins_dir = $NVIMRC_PLUGINS_DIR
let g:config_dir = $NVIMRC_CONFIG_DIR

" =============================================================================
" = Plugin Global Options =
" =============================================================================

" --- ProjectRC Options ---
let g:projectrc_key = '<custom-key-here>'

" --- deoplete Options ---
let g:deoplete#enable_at_startup = 1

" --- UltiSnips Options ---
let g:UltiSnipsExpandTrigger = '<C-z>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" --- vim-polyglot Options ---
let g:vue_pre_processors = ['typescript', 'scss']

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'

" --- Lightline Options ---
let g:lightline = {
    \   'colorscheme': 'gruvbox',
    \   'component': { 'line': 'LN %l/%L' },
    \   'component_function': {
    \       'gitbranch': 'gitbranch#name',
    \       'lsp': 'LSP_StatusLine',
    \   },
    \   'active': {
    \       'left': [ [ 'mode', 'paste' ], [ 'gitbranch' ] ],
    \       'right': [ [ 'lsp' ], [ 'line' ], [ 'filetype' ] ],
    \   },
    \ }

" --- vim-buftabline Options ---
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" --- fzf Options ---
let $FZF_DEFAULT_COMMAND='rg --files --hidden --iglob !.git'
nnoremap <C-p> :Files<CR>
nnoremap <C-t> :Rg<CR>

" --- ALE Options ---
let g:ale_completion_autoimport = 1

let g:ale_hover_cursor = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_fix_on_save = 1
let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }

let g:ale_linters_explicit = 1
let g:ale_linters = {
   \   'css': ['stylelint'],
   \   'javascript': ['eslint', 'tsserver'],
   \   'javascriptreact': ['eslint', 'tsserver'],
   \   'php': ['intelephense', 'phpcs', 'phan'],
   \   'scss': ['stylelint'],
   \   'typescript': ['eslint', 'tsserver'],
   \   'typescriptreact': ['eslint', 'tsserver'],
   \   'vue': ['vls'],
   \ }

let g:ale_php_phan_use_client = 1

" --- vim-startify Options ---
let g:startify_change_to_dir = 0
let g:startify_lists = [
    \   { 'type': 'dir',       'header': ['   MRU '. getcwd()]  },
    \   { 'type': 'sessions',  'header': ['   Sessions']        },
    \   { 'type': 'bookmarks', 'header': ['   Bookmarks']       },
    \   { 'type': 'commands',  'header': ['   Commands']        },
    \ ]

" =============================================================================
" = Plugin Manager =
" =============================================================================

call plug#begin(g:plugins_dir)

" Core
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'SirVer/ultisnips'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/context_filetype.vim'
Plug 'tyru/caw.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Theme, Syntax
Plug 'ap/vim-buftabline'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'sheerun/vim-polyglot'
Plug 'yggdroot/indentline'
Plug 'ryym/vim-riot'
Plug 'mhinz/vim-startify'

call plug#end()

" =============================================================================
" = Plugin Function Options =
" =============================================================================

" --- deoplete ---
call deoplete#custom#option('sources', { '_': ['ale', 'ultisnips'] })
call deoplete#custom#option('auto_complete_delay', 100)
call deoplete#custom#option('smart_case', v:true)

" =============================================================================
" = General =
" =============================================================================

set nocompatible
set encoding=utf8

" Completion options
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Search options
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

" Indent options
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
set smartindent

" Line options
set showmatch
set linebreak
set showbreak=+++
set textwidth=120
set colorcolumn=120
set scrolloff=3

" No backups or swapfiles needed
set nobackup
set nowritebackup
set noswapfile

" Lazy redraw
set lazyredraw

" Undo history
set undolevels=1000

" Buffers/Tabs/Windows
set hidden

" update time to 300ms
set updatetime=300

" Set spelling
set nospell

" For git
set signcolumn=yes

" Mouse support
set mouse=a

" File format type
set fileformats=unix

" no sounds
set visualbell t_vb=

" backspace behaviour
set backspace=indent,eol,start

" Status line
set noshowmode
set laststatus=2

" Tab line
set showtabline=2

" Better display
set cmdheight=2

" Auto reload file if changed outside vim, or just :e!
set autoread

" =============================================================================
" = Functions =
" =============================================================================

function! ThemeSetDark() abort
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_sign_column = 'dark0_hard'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'dark0_hard'
    set background=dark
endfunction

function! ThemeSetLight() abort
    let g:gruvbox_contrast_light='soft'
    let g:gruvbox_sign_column='light0_soft'
    let g:gruvbox_invert_selection=0
    let g:gruvbox_number_column='light0_soft'
    let g:indentLine_color_term=242
    set background=light
endfunction

function! MDToggleConceal() abort
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

" Language Server Protocol setup
" ---
function! LSP_StatusLine() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'ale 🟢' : printf(
        \   'ale %d 🔴 %d 🟡',
        \   all_errors,
        \   all_non_errors,
        \ )
endfunction

function! LSP_RegisterKeys() abort
    nmap <silent> <leader>ld :ALEGoToDefinition<CR>
    nmap <silent> <leader>lr :ALEFindReferences<CR>
    nmap <silent> <leader>lh :ALEHover<CR>
    nmap <silent> <F2> :ALERename<CR>
    nmap <silent> <leader>le :lopen<CR>
endfunction

" =============================================================================
" = Auto Commands (single/groups) =
" =============================================================================

" =============================================================================
" = Key Bindings =
" =============================================================================

" Unbind default bindings for arrow keys, trust me this is for your own good
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <ESC>

" Map escape from terminal input to Normal mode
tnoremap <ESC> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>

" Copy/Paste from the system clipboard
vnoremap <C-i> "+y<CR>
nnoremap <C-o> "+p<CR>

" File explorer
noremap <F3> :Ex<CR>

" Manual completion
imap <C-Space> <C-x><C-o>

" Leader Map
let mapleader=' '

" Disable highlights
nnoremap <leader><CR> :noh<CR>

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

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
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

" Edit vimrc and gvimrc
nnoremap <leader>ve :e $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <leader>vs :so $MYVIMRC<CR>:noh<CR>:EditorConfigReload<CR>

" Reload file
nnoremap <leader>r :e!<CR>

" LSP key mappings
call LSP_RegisterKeys()

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! MDToggleConceal call MDToggleConceal()

" =============================================================================
" = Theming and Looks =
" =============================================================================

syntax on
set number
set termguicolors
set relativenumber

call ThemeSetDark()
colorscheme gruvbox
