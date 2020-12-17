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
" = Functions =
" =============================================================================

function! SetDarkTheme() abort
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_sign_column = 'dark0_hard'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'dark0_hard'
    let g:ayucolor='mirage'
    set background=dark
endfunction

function! SetLightTheme() abort
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
function! RegisterLspKeymaps() abort
    nmap <silent> <F2>       :ALERename<CR>
    nmap <silent> <leader>ld :ALEGoToDefinition<CR>
    nmap <silent> <leader>lr :ALEFindReferences<CR>
    nmap <silent> <leader>lf :ALEFix<CR>
    nmap <silent> <leader>lh :ALEHover<CR>
    nmap <silent> <leader>le :lopen<CR>
endfunction

" Status Line
" ---
function! LSPStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'ALE ' : printf(
        \ 'ALE %d 🔴 %d 🟡 ',
        \ all_errors,
        \ all_non_errors,
    \ )
endfunction

function! CursorMode()
    let l:mode_map = {
        \ '': 'V-BLOCK',
        \ 'R':  'REPLACE',
        \ 'Rv': 'V-REPLACE',
        \ 'V':  'V-LINE',
        \ 'c':  'COMMAND',
        \ 'i':  'INSERT',
        \ 'n':  'NORMAL',
        \ 'v':  'VISUAL',
    \}
    let l:current_mode = mode_map[mode()]

    return printf('%s ', l:current_mode)
endfunction

function! GitBranch()
    let l:branch = gitbranch#name()
    return branch == '' ? ' ' : printf('  %s ', branch)
endfunction

function! BufferName()
    let l:buf = expand('%:t')
    return buf == '[No Name]' ? '' : printf('%s ', buf)
endfunction

function! StatusLineRender()
    let l:left_sep = "\uE0B8"
    let l:right_sep = "\uE0BA"
    let l:statusline = [
        \ '%1* %-{CursorMode()}',
        \ '%7*' . left_sep,
        \ '%2*%-{GitBranch()}',
        \ '%-{BufferName()}',
        \ '%8*' . left_sep . ' ',
        \ '%*%-m %-r',
        \ '%=',
        \ '%y LN %l/%L ',
        \ '%9*' . right_sep,
        \ '%3* %{LSPStatus()}%*',
        \]

    return join(statusline, '')
endfunction

" =============================================================================
" = Auto Commands (single/groups) =
" =============================================================================

" FZF statusline hide
autocmd! FileType fzf set laststatus=0 noruler | autocmd BufLeave <buffer> set laststatus=2 ruler

" LSP Keymap Register
augroup lsp_setup
    autocmd!
    autocmd FileType javascript,javascriptreact call RegisterLspKeymaps()
    autocmd FileType typescript,typescriptreact call RegisterLspKeymaps()
    autocmd FileType vue call RegisterLspKeymaps()
    autocmd FileType php call RegisterLspKeymaps()
augroup END

" =============================================================================
" = Plugin Options =
" =============================================================================

" --- ProjectCMD Options ---
let g:projectcmd_key = $NVIMRC_PROJECTCMD_KEY

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

" --- vim-buftabline Options ---
let g:buftabline_show = 1
let g:buftabline_indicators = 1
let g:buftabline_numbers = 2

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
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ }

let g:ale_linters_explicit = 1
let g:ale_linters = {
    \ 'css': ['stylelint'],
    \ 'javascript': ['eslint', 'tsserver'],
    \ 'javascriptreact': ['eslint', 'tsserver'],
    \ 'php': ['intelephense_ftplugin', 'phpcs', 'phpstan'],
    \ 'scss': ['stylelint'],
    \ 'typescript': ['eslint', 'tsserver'],
    \ 'typescriptreact': ['eslint', 'tsserver'],
    \ 'vue': ['vls'],
\ }

" --- vim-startify Options ---
let g:startify_change_to_dir = 0
let g:startify_lists = [
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()]  },
    \ { 'type': 'sessions',  'header': ['   Sessions']        },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']       },
    \ { 'type': 'commands',  'header': ['   Commands']        },
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
Plug 'ap/vim-buftabline'
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
call deoplete#custom#option('auto_complete_delay', 100)
call deoplete#custom#option('smart_case', v:true)

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
set statusline=%!StatusLineRender()

" Tab line
set showtabline=2

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

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigDir edit $NVIMRC_CONFIG_DIR
command! ConfigReload so $MYVIMRC
command! MDToggleConceal call MDToggleConceal()
command! LSPRegisterKeymaps call RegisterLspKeymaps()

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

" Buftabline
hi BufTabLineCurrent ctermfg=235 ctermbg=72 guifg=#1d2021 guibg=#689d6a

" Blue
hi User1 ctermfg=235 ctermbg=66 guifg=#1d2021 guibg=#458588
" Aqua
hi User2 ctermfg=235 ctermbg=72 guifg=#1d2021 guibg=#689d6a
" Purple
hi User3 ctermfg=235 ctermbg=132 guifg=#1d2021 guibg=#b16286

" Seperator colors
" bluefg -> aquabg
hi User7 cterm=reverse ctermfg=72 ctermbg=66 gui=reverse guifg=#689d6a guibg=#458588
" bluefg -> statuslinebg
hi User8 cterm=reverse ctermfg=239 ctermbg=72 gui=reverse guifg=#504945 guibg=#689d6a
" statuslinebg -> purplefg
hi User9 cterm=reverse ctermfg=239 ctermbg=132 gui=reverse guifg=#504945 guibg=#b16286
