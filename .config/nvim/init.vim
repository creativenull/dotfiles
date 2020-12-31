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

let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG
let g:plugins_dir = $NVIMRC_PLUGINS_DIR
let g:config_dir = $NVIMRC_CONFIG_DIR

" =============================================================================
" = Functions =
" =============================================================================

function! SetDarkTheme()
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_sign_column = 'dark0_hard'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'dark0_hard'
    set background=dark
endfunction

function! SetLightTheme()
    let g:gruvbox_contrast_light = 'soft'
    let g:gruvbox_sign_column = 'light0_soft'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'light0_soft'
    let g:indentLine_color_term = 242
    set background=light
endfunction

function! ToggleConceal()
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

function! SetLspKeymaps()
    nmap <silent> <F2>       :ALERename<CR>
    nmap <silent> <leader>ld :ALEGoToDefinition<CR>
    nmap <silent> <leader>lr :ALEFindReferences<CR>
    nmap <silent> <leader>lf :ALEFix<CR>
    nmap <silent> <leader>lh :ALEHover<CR>
    nmap <silent> <leader>le :lopen<CR>
endfunction

function! SetCustomHighlights()
    let l:st_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'fg')
    let l:tb_text_color = '#a89984'
    let l:tb_bg = '#3c3836'
    let l:text_color = '#1d2021'
    let l:blue = '#458588'
    let l:aqua = '#689d6a'
    let l:purple = '#b16286'

    " TabLine
    execute printf('hi TabLine gui=NONE guibg=%s guifg=%s', tb_bg, tb_text_color)
    execute printf('hi TabLineSel guifg=%s guibg=%s', text_color, aqua)
    execute printf('hi TabLineSelLeftSep guifg=%s guibg=%s', aqua, tb_bg)
    execute printf('hi TabLineSelRightSep gui=reverse guifg=%s guibg=%s', aqua, tb_bg)

    " StatusLine
    " CursorMode - Bluebg
    execute printf('hi User1 guifg=%s guibg=%s', text_color, blue)
    " Git,Filename - Aquabg
    execute printf('hi User2 guifg=%s guibg=%s', text_color, aqua)
    " LSPStatus - Purplebg
    execute printf('hi User3 guifg=%s guibg=%s', text_color, purple)

    " Seperator colors
    " bluefg -> aquabg
    execute printf('hi User7 guifg=%s guibg=%s', blue, aqua)
    " aquafg -> statuslinebg
    execute printf('hi User8 guifg=%s guibg=%s', aqua, st_bg)
    " statuslinebg -> purplefg
    execute printf('hi User9 guifg=%s guibg=%s', purple, st_bg)
endfunction

" =============================================================================
" = Auto Commands (single/groups) =
" =============================================================================

" FZF statusline hide
autocmd! FileType fzf set laststatus=0 tabline=FZF noruler
    \| autocmd BufLeave <buffer> set laststatus=2 tabline=%!creativenull#tabline_render() ruler

" =============================================================================
" = General =
" =============================================================================

set nocompatible
set encoding=utf8

" Completion options
set completeopt=menuone,noinsert,noselect
set shortmess+=wc

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
set statusline=%!creativenull#statusline#render()

" Tab line
set showtabline=2
" set tabline=%!TabLine#render()
set tabline=%!creativenull#tabline_render()

" Better display
set cmdheight=2

" Auto reload file if changed outside vim, or just :e!
set autoread

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
let mapleader = ' '

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

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigDir edit $NVIMRC_CONFIG_DIR
command! ConfigReload so $MYVIMRC | noh | exe ':EditorConfigReload'
command! ToggleConceal call ToggleConceal()
command! SetLspKeymaps call SetLspKeymaps()

" =============================================================================
" = Plugin Options =
" =============================================================================

" --- ProjectCMD Options ---
let g:projectcmd_key = $NVIMRC_PROJECTCMD_KEY

" --- UltiSnips Options ---
let g:UltiSnipsExpandTrigger = '<C-z>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" --- vim-polyglot Options ---
let g:vue_pre_processors = ['typescript', 'scss']

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'

" --- fzf Options ---
let $FZF_DEFAULT_COMMAND='rg --files --hidden --iglob !.git'
nnoremap <C-p> :Files<CR>
nnoremap <C-t> :Rg<CR>

" --- ALE Options ---
let g:ale_hover_cursor = 0

let g:ale_completion_autoimport = 1

let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_linters_explicit = 1
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

" --- vim-startify Options ---
let g:startify_change_to_dir = 0
let g:startify_lists = [
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ ]

" =============================================================================
" = Plugin Manager =
" =============================================================================

call plug#begin(g:plugins_dir)

" Core
Plug 'creativenull/projectcmd.vim'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'creativenull/ale'
Plug 'SirVer/ultisnips'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/context_filetype.vim'
Plug 'tyru/caw.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Theme, Syntax
Plug 'itchyny/vim-gitbranch'
Plug 'sheerun/vim-polyglot'
Plug 'yggdroot/indentline'
Plug 'mhinz/vim-startify'
Plug 'gruvbox-community/gruvbox'
Plug 'aonemd/kuroi.vim'
Plug 'srcery-colors/srcery-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

call plug#end()

" =============================================================================
" = Plugin Function Options =
" =============================================================================

" --- deoplete ---
call deoplete#custom#option('sources', { '_': ['ale', 'ultisnips'] })
call deoplete#custom#option('auto_complete_delay', 300)
call deoplete#custom#option('smart_case', v:true)

" =============================================================================
" = Theming and Looks =
" =============================================================================

syntax on
set number
set relativenumber
set t_Co=256
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

call SetDarkTheme()
colorscheme gruvbox
call SetCustomHighlights()
