" Name: Arnold Chand
" Github: https://github.com/creativenull
" Description: My vimrc, pre-requisites:
" + vim-plug
" + ripgrep
" + Environment variables:
"    $PYTHON3_HOST_PROG
"    $NVIMRC_PLUGINS_DIR
"    $NVIMRC_CONFIG_DIR
"    $NVIMRC_PROJECTCMD_KEY
"
" Currently, tested on a Linux machine.
" =============================================================================

let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG
let g:plugins_dir = $NVIMRC_PLUGINS_DIR
let g:config_dir = $NVIMRC_PLUGINS_DIR

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
let g:polyglot_disabled = ['php', 'autoindent', 'sensible']

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'

" --- fzf Options ---
let $FZF_DEFAULT_COMMAND='rg --files --hidden --iglob !.git'
let g:fzf_preview_window = []
nnoremap <C-p> <cmd>Files<CR>
nnoremap <C-t> <cmd>Rg<CR>

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
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'godlygeek/tabular'
Plug 'Shougo/context_filetype.vim'
Plug 'tyru/caw.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Theme, Syntax
Plug 'ap/vim-buftabline'
Plug 'itchyny/vim-gitbranch'
Plug 'mhinz/vim-startify'
Plug 'sheerun/vim-polyglot'
Plug 'srcery-colors/srcery-vim'

call plug#end()

" =============================================================================
" = Plugin Function Options =
" =============================================================================

" --- deoplete ---
call deoplete#custom#option('sources', { '_': ['ale', 'ultisnips'] })
call deoplete#custom#option('auto_complete_delay', 50)
call deoplete#custom#option('smart_case', v:true)
call deoplete#custom#option('ignore_case', v:true)
call deoplete#custom#option('max_list', 10)

" --- fzf Options ---
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview('up:50%', 'ctrl-/'),
    \ <bang>0
    \ )

" =============================================================================
" = Functions =
" =============================================================================

function! s:toggle_conceal() abort
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

function! SetLspKeymaps() abort
    nnoremap <silent> <F2> <cmd>ALERename<CR>
    nnoremap <silent> <leader>ld <cmd>ALEGoToDefinition<CR>
    nnoremap <silent> <leader>lr <cmd>ALEFindReferences<CR>
    nnoremap <silent> <leader>lf <cmd>ALEFix<CR>
    nnoremap <silent> <leader>lh <cmd>ALEHover<CR>
    nnoremap <silent> <leader>le <cmd>lopen<CR>
endfunction

function! s:cursor_mode() abort
    if mode() == 'n'
        return '%#StatusLineCursorNormal# NORMAL %*'
    elseif mode() == 'i'
        return '%#StatusLineCursorInsert# INSERT %*'
    elseif mode() == 'c'
        return '%#StatusLineCursorCommand# COMMAND %*'
    elseif mode() == 'v' || mode() == 'V' || mode() == ''
        return '%#StatusLineCursorVisual# VISUAL %*'
    elseif mode() == 'R' || mode() == 'Rv' || mode() == 'Rx'
        return '%#StatusLineCursorReplace# REPLACE %*'
    endif
endfunction

function! s:lsp_statusline() abort
    if exists('g:loaded_ale')
        let l:lsp_hl = '%#StatusLineLSP#'
        let l:counts = ale#statusline#Count(bufnr(''))
        let l:all_errors = l:counts.error + l:counts.style_error
        let l:all_non_errors = l:counts.total - l:all_errors
        return l:counts.total == 0 ? lsp_hl . ' ALE ' : printf(
            \ '%s ALE %d 🔴 %d 🟡 ',
            \ lsp_hl,
            \ all_errors,
            \ all_non_errors,
        \ )
    endif

    return lsp_hl . ' NONE '
endfunction

function! s:lsp_hl()
    hi! StatusLineLSP guibg=#53FDE9 guifg=#1C1B19
endfunction

function! s:statusline_hl()
    let l:text_color_black = '#1C1B19'
    let l:text_color_white = '#D0BFA1'
    let l:statusline_highlights = [
        \ printf('hi! StatusLineCursorNormal  guibg=#519F50 guifg=%s', text_color_black),
        \ printf('hi! StatusLineCursorInsert  guibg=#EF2F27 guifg=%s', text_color_white),
        \ printf('hi! StatusLineCursorVisual  guibg=#FBB829 guifg=%s', text_color_black),
        \ printf('hi! StatusLineCursorReplace guibg=#FBB829 guifg=%s', text_color_black),
        \ printf('hi! StatusLineCursorCommand guibg=#2C78BF guifg=%s', text_color_white),
    \ ]
    for statusline_hl in statusline_highlights
        execute statusline_hl
    endfor
endfunction

function! StatusLineRender() abort
  return s:cursor_mode() . ' %{gitbranch#name()} %{expand("%:t")} %m %=%l/%L ' . s:lsp_statusline()
endfunction

" =============================================================================
" = Auto Commands (single/groups) =
" =============================================================================

au! FileType fzf set laststatus=0 noruler | au BufLeave <buffer> set laststatus=2 ruler

augroup set_invisible_chars
    au!
    au FileType help set nolist
    au FileType fzf set nolist
augroup end

" =============================================================================
" = Theming and Looks =
" =============================================================================

set number
set relativenumber
set termguicolors

colorscheme srcery
call s:statusline_hl()
call s:lsp_hl()

" =============================================================================
" = Options =
" =============================================================================

" Completion options
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Search options
set ignorecase
set smartcase

" Indent options
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smartindent

" Line options
set showmatch
set linebreak
set showbreak=+++
set textwidth=120
set colorcolumn=120
set scrolloff=5

" Backups and swapfile
set dir=~/.cache/nvim
set backup
set backupdir=~/.cache/nvim
set undofile
set undodir=~/.cache/nvim
set undolevels=10000
set history=10000

" Performance
set lazyredraw

" Buffers/Tabs/Windows
set hidden

" spelling
set nospell

" For git
set signcolumn=yes

" Mouse support
set mouse=a

" File format type
set fileformats=unix

" backspace behaviour
set backspace=indent,eol,start

" Status line
set noshowmode
set statusline=%!StatusLineRender()

" Tabline
set showtabline=2

" Better display
set cmdheight=2

" Invisible chars
set list
set listchars=tab:▸\ ,trail:·,space:·

" =============================================================================
" = Keybindings =
" =============================================================================

let mapleader = ' '

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

" File explorer
noremap <F3> <cmd>Ex<CR>

" Manual completion
imap <C-Space> <C-x><C-o>

" Disable highlights
nnoremap <leader><CR> <cmd>noh<CR>

" Buffer maps
" ---
" List all buffers
nnoremap <leader>bl <cmd>buffers<CR>
" Go to next buffer
nnoremap <C-l> <cmd>bnext<CR>
" Go to previous buffer
nnoremap <C-h> <cmd>bprevious<CR>
" Close the current buffer
nnoremap <leader>bd <cmd>bp<BAR>sp<BAR>bn<BAR>bd<CR>

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
nnoremap <up>    <cmd>resize +2<CR>
nnoremap <down>  <cmd>resize -2<CR>
nnoremap <left>  <cmd>vertical resize -2<CR>
nnoremap <right> <cmd>vertical resize +2<CR>

" Text maps
" ---
" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Edit vimrc and gvimrc
nnoremap <leader>ve <cmd>edit $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <leader>vs <cmd>execute ':ConfigReload'<CR>

" Reload file
nnoremap <leader>r <cmd>edit!<CR>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | noh | execute ':EditorConfigReload'
command! ToggleConceal call <SID>toggle_conceal()
command! SetLspKeymaps call SetLspKeymaps()

" I can't release my shift key fast enough :')
command! -nargs=* W w
command! -nargs=* Wq wq
command! -nargs=* WQ wq
command! -nargs=* Q q
command! -nargs=* Qa qa
command! -nargs=* QA qa
