" Name: Arnold Chand
" Github: https://github.com/creativenull
" My vimrc, pre-requisites:
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

let mapleader = ' '
let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG
let g:undodir = expand('~/.cache/nvim/undo')

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

function! s:options_init() abort
    if isdirectory(g:undodir) == v:false
        let s:cmd = printf('!mkdir -p %s', g:undodir)
        execute s:cmd
    endif
endfunction

function! LspStatus()
    if exists('g:loaded_ale')
        let l:counts = ale#statusline#Count(bufnr(''))
        let l:all_errors = counts.error + counts.style_error
        let l:all_non_errors = counts.total - all_errors
        return counts.total == 0 ? 'ALE' : printf(' %d 🔴 %d 🟡 ALE', all_errors, all_non_errors)
    endif

    return ''
endfunction

function! RegisterLsp() abort
    " --- Deoplete Options ---
    call deoplete#enable()
    call deoplete#custom#option('sources', { '_': ['ale', 'ultisnips'] })
    call deoplete#custom#option('auto_complete_delay', 50)
    call deoplete#custom#option('smart_case', v:true)
    call deoplete#custom#option('ignore_case', v:true)
    call deoplete#custom#option('max_list', 10)

    " --- ALE Keymaps ---
    nnoremap <silent> <F2> <cmd>ALERename<CR>
    nnoremap <silent> <leader>ld <cmd>ALEGoToDefinition<CR>
    nnoremap <silent> <leader>lr <cmd>ALEFindReferences<CR>
    nnoremap <silent> <leader>lf <cmd>ALEFix<CR>
    nnoremap <silent> <leader>lh <cmd>ALEHover<CR>
    nnoremap <silent> <leader>le <cmd>lopen<CR>
endfunction

function! s:codeshot_enable() abort
    setlocal nolist nonumber norelativenumber signcolumn=no
endfunction

function! s:codeshot_disable() abort
    setlocal list number relativenumber signcolumn=yes
endfunction

" =============================================================================
" = Auto Command Groups =
" =============================================================================

augroup fzf_state
    au!
    au FileType fzf setlocal laststatus=0 noruler | au BufLeave <buffer> setlocal laststatus=2 ruler
augroup end

augroup set_invisible_chars
    au!
    au FileType help setlocal nolist
    au FileType fzf setlocal nolist
augroup end

augroup netrw_opts
    au!
    au FileType netrw setl bufhidden=delete
    au FileType netrw nnoremap <buffer> <Esc> <cmd>Rex<CR>
augroup end

augroup colorscheme_opts
    au!
    au ColorScheme * highlight default link HighlightedyankRegion Search
augroup end

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
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []
nnoremap <C-p> <cmd>Files<CR>
nnoremap <C-t> <cmd>Rg<CR>

" --- ALE Options ---
let g:ale_hover_cursor = 0
let g:ale_completion_autoimport = 1
" let g:ale_floating_preview = 1
" let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
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

" --- hlyank Options ---
let g:highlightedyank_highlight_duration = 500

" --- buftabline Options ---
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1

" --- lightline Options ---
let g:lightline = {}
let g:lightline.colorscheme = 'srcery'
let g:lightline.component = { 'lineinfo': 'L:%l/%L C:%c' }
let g:lightline.active = {
    \ 'left': [ ['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified'] ],
    \ 'right': [ ['lspstatus'], ['lineinfo'], ['filetype', 'fileencoding'] ],
\ }
let g:lightline.component_function = {
    \ 'gitbranch': 'gitbranch#name',
    \ 'lspstatus': 'LspStatus'
\ }

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! PackagerInit(opts) abort
    packadd vim-packager
    call packager#init(a:opts)
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

    " Core
    call packager#add('creativenull/projectcmd.vim')
    call packager#add('dense-analysis/ale')
    call packager#add('airblade/vim-gitgutter')
    call packager#add('editorconfig/editorconfig-vim')
    call packager#add('mattn/emmet-vim')
    call packager#add('tpope/vim-surround')
    call packager#add('SirVer/ultisnips')
    call packager#add('Shougo/deoplete.nvim')
    call packager#add('godlygeek/tabular')
    call packager#add('Shougo/context_filetype.vim')
    call packager#add('tyru/caw.vim')
    call packager#add('junegunn/fzf', { 'do': './install --bin' })
    call packager#add('junegunn/fzf.vim')

    " Theme, Syntax
    call packager#add('itchyny/lightline.vim')
    call packager#add('ap/vim-buftabline')
    call packager#add('itchyny/vim-gitbranch')
    call packager#add('mhinz/vim-startify')
    call packager#add('sheerun/vim-polyglot')
    call packager#add('jwalton512/vim-blade')
    call packager#add('srcery-colors/srcery-vim')
    call packager#add('machakann/vim-highlightedyank')
endfunction

" Package manager bootstrapping strategy
let s:manager_path = stdpath('data') . '/site/pack/packager/opt/vim-packager'
let s:manager_git = 'https://github.com/kristijanhusak/vim-packager.git'
let s:manager_opts = { 'dir': stdpath('data') . '/site/pack/packager' }
if isdirectory(s:manager_path) == v:false
    let s:cli = printf('!git clone %s %s', s:manager_git, s:manager_path)
    execute s:cli

    " Setup the manager and install plugins
    call PackagerInit(s:manager_opts)
    call packager#install()
endif

command! -nargs=* -bar PackagerInstall call PackagerInit(s:manager_opts) | call packager#install(<args>)
command! -nargs=* -bar PackagerUpdate call PackagerInit(s:manager_opts) | call packager#update(<args>)
command! -bar PackagerClean call PackagerInit(s:manager_opts) | call packager#clean()
command! -bar PackagerStatus call PackagerInit(s:manager_opts) | call packager#status()

" =============================================================================
" = Plugin Function Options =
" =============================================================================

" --- fzf Options ---
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview('right:50%', 'ctrl-/'),
    \ <bang>0
    \ )

" =============================================================================
" = Theming and Looks =
" =============================================================================

set number
set termguicolors
colorscheme srcery

" =============================================================================
" = Options =
" =============================================================================

call s:options_init()

" Completion options
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set updatetime=250

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

" No backups and swapfiles but undo tree
set nobackup
set noswapfile
set undofile
let &undodir=g:undodir
set undolevels=10000
set history=10000

" Performance gainzzz
set lazyredraw

" Hide a buffer when abandoned using :bd
set hidden

" Spelling only for markdown
set nospell

" For git signs
set signcolumn=yes

" No mouse support, who uses that? They were definitely NOT in my previous commits xD
set mouse=

" Hide the `-- INSERT --` on the command line below
set noshowmode

" Always show the tabline on top
set showtabline=2

" Show 2 lines of command output on the command line below
set cmdheight=2

" Show invisible characters for code
set list
set listchars=tab:▸\ ,trail:·,space:·

" Show block cursor in all modes except on replace and command
set guicursor=n-v-c-ci-sm-ve-i:block,r-cr-o:hor20

" =============================================================================
" = Keybindings =
" =============================================================================

" Unbind default bindings for arrow keys, trust me this is for your own good
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
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
" Close the current buffer, and more?
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
nnoremap <leader>vs <cmd>ConfigReload<CR>

" Reload file
nnoremap <leader>r <cmd>edit!<CR>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | noh | execute ':EditorConfigReload'
command! ToggleConceal call <SID>toggle_conceal()

command! Codeshot call <SID>codeshot_enable()
command! NoCodeshot call <SID>codeshot_disable()

" I can't release my shift key fast enough :')
command! -nargs=* W w
command! -nargs=* Wq wq
command! -nargs=* WQ wq
command! -nargs=* Q q
command! -nargs=* Qa qa
command! -nargs=* QA qa
