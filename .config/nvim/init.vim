" Name: Arnold Chand
" Github: https://github.com/creativenull
" My vimrc, pre-requisites:
" + python
" + nnn
" + ripgrep
" + Environment variables:
"    $PYTHON3_HOST_PROG
"
" Currently, tested on a Linux machine
" =============================================================================

let g:mapleader = ' '
let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:undodir = expand('~/.cache/nvim/undo')
let g:cnull#enable_transparent = v:false

if executable('python3') == v:false || exists('$PYTHON3_HOST_PROG') == v:false
  echoerr '`python3` not installed, please install it via your OS software manager, and set $PYTHON_HOST_PROG env'
  finish
endif

if executable('rg') == v:false
  echoerr '`ripgrep` not installed, please install it via your OS software manager'
  finish
endif

if executable('nnn') == v:false
  echoerr '`nnn` not installed, please install it via your OS software manager'
  finish
endif

" =============================================================================
" = Functions =
" =============================================================================

function! s:options_init() abort
  if isdirectory(g:undodir) == v:false
    execute printf('!mkdir -p %s', g:undodir)
  endif
endfunction

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
  nnoremap <silent> <F2>       <Cmd>ALERename<CR>
  nnoremap <silent> <leader>ld <Cmd>ALEGoToDefinition<CR>
  nnoremap <silent> <leader>lr <Cmd>ALEFindReferences<CR>
  nnoremap <silent> <leader>lf <Cmd>ALEFix<CR>
  nnoremap <silent> <leader>lh <Cmd>ALEHover<CR>
  nnoremap <silent> <leader>le <Cmd>lopen<CR>
endfunction

function! RenderStatusline()
  let s:filename = expand('%:t')
  let s:branchname = gitbranch#name()
  let s:lsp = LspStatus()
  return ' ' . s:filename . ' | ' . s:branchname . ' %= %l/%L:%c ' . s:lsp . ' '
endfunction

function! s:codeshot_enable() abort
  setlocal nonumber signcolumn=no mouse=
endfunction

function! s:codeshot_disable() abort
  setlocal number signcolumn=yes mouse=a
endfunction

" =============================================================================
" = Auto Command Groups =
" =============================================================================

if g:cnull#enable_transparent == v:true
  augroup transparent_bg
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=NONE
    autocmd ColorScheme * highlight SignColumn guibg=NONE
    autocmd ColorScheme * highlight LineNr guibg=NONE
    autocmd ColorScheme * highlight CursorLineNr guibg=NONE
  augroup end
endif

" =============================================================================
" = Plugin Config - before loading plugins =
" =============================================================================

" --- ProjectCMD Options ---
let g:projectcmd_key = $NVIMRC_PROJECTCMD_KEY

" --- UltiSnips Options ---
let g:UltiSnipsExpandTrigger = '<C-z>.'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
autocmd! FileType javascriptreact UltiSnipsAddFiletypes javascript_react
autocmd! FileType typescriptreact UltiSnipsAddFiletypes typescript_react

" --- vim-polyglot Options ---
let g:vue_pre_processors = ['typescript', 'scss']
let g:polyglot_disabled = ['php', 'autoindent', 'sensible']

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'

" --- fzf Options ---
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_preview_window = []
autocmd! FileType fzf setlocal laststatus=0 noruler | autocmd! BufLeave <buffer> setlocal laststatus=2 ruler
nnoremap <C-p> <Cmd>Files<CR>
nnoremap <C-t> <Cmd>Rg<CR>

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
autocmd! ColorScheme * highlight default link HighlightedyankRegion Search

" --- buftabline Options ---
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1

" --- lightline Options ---
" let g:lightline = {}
" let g:lightline.colorscheme = 'tokyonight'
" let g:lightline.component = { 'lineinfo': '%l/%L:%c' }
" let g:lightline.active = {}
" let g:lightline.active.left = [ ['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified'] ]
" let g:lightline.active.right = [ ['lspstatus'], ['lineinfo'], ['filetype', 'fileencoding'] ]
" let g:lightline.component_function = {}
" let g:lightline.component_function.gitbranch = 'gitbranch#name'
" let g:lightline.component_function.lspstatus = 'LspStatus'

" --- nnn.vim Options ---
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
nmap <silent> <F3> <Cmd>NnnPicker %:p:h<CR>

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! PackagerInit(opts) abort
  packadd vim-packager
  call packager#init(a:opts)
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " Core
  call packager#add('creativenull/projectcmd.vim', { 'frozen': v:true })
  call packager#add('dense-analysis/ale')
  call packager#add('airblade/vim-gitgutter')
  call packager#add('editorconfig/editorconfig-vim')
  call packager#add('mattn/emmet-vim', { 'type': 'opt' })
  call packager#add('tpope/vim-surround')
  call packager#add('SirVer/ultisnips')
  call packager#add('honza/vim-snippets')
  call packager#add('Shougo/deoplete.nvim')
  call packager#add('godlygeek/tabular')
  call packager#add('Shougo/context_filetype.vim')
  call packager#add('tyru/caw.vim')
  call packager#add('junegunn/fzf', { 'do': './install --bin' })
  call packager#add('junegunn/fzf.vim')
  call packager#add('cohama/lexima.vim')
  call packager#add('mcchrish/nnn.vim')

  " Theme, Syntax
  call packager#add('ap/vim-buftabline')
  call packager#add('itchyny/vim-gitbranch')
  call packager#add('mhinz/vim-startify')
  call packager#add('Yggdroot/indentLine')
  call packager#add('sheerun/vim-polyglot')
  call packager#add('jwalton512/vim-blade')
  call packager#add('machakann/vim-highlightedyank')
  call packager#add('ghifarit53/tokyonight-vim')
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
" = Plugin Options - after loading plugins =
" =============================================================================

" --- fzf Options ---
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview('right:50%', 'ctrl-/'),
  \ <bang>0
  \ )

" --- emmet Options ---
autocmd! FileType html,javascript,javascriptreact,typescript,typescriptreact packadd emmet-vim

" =============================================================================
" = Theming and Looks =
" =============================================================================

set number
set termguicolors
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

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
set smarttab

" Line options
set showmatch
set nowrap
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
set mouse=a

" Show 2 lines of command output on the command line below
set cmdheight=2

" Render custom statusline
set statusline=%!RenderStatusline()

" Always show the tabline on top
set showtabline=2

" Use system/OS clipboard by default
set clipboard=unnamedplus

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

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <Esc>

" Map escape from terminal input to Normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>


" Manual completion
imap <C-Space> <C-x><C-o>

" Disable highlights
nnoremap <Leader><CR> <Cmd>noh<CR>

" Buffer maps
" ---
" List all buffers
nnoremap <Leader>bl <Cmd>buffers<CR>
" Go to next buffer
nnoremap <C-l> <Cmd>bnext<CR>
" Go to previous buffer
nnoremap <C-h> <Cmd>bprevious<CR>
" Close the current buffer, and more?
nnoremap <Leader>bd <Cmd>bp<BAR>sp<BAR>bn<BAR>bd<CR>

" Resize window panes, we can use those arrow keys
" to help use resize windows - at least we give them some purpose
nnoremap <Up>    <Cmd>resize +2<CR>
nnoremap <Down>  <Cmd>resize -2<CR>
nnoremap <Left>  <Cmd>vertical resize -2<CR>
nnoremap <Right> <Cmd>vertical resize +2<CR>

" Text maps
" ---
" Move a line of text Alt+[j/k]
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Edit vimrc and gvimrc
nnoremap <Leader>ve <Cmd>edit $MYVIMRC<CR>

" Source the vimrc to reflect changes
nnoremap <Leader>vs <Cmd>ConfigReload<CR>

" Reload file
nnoremap <Leader>r <Cmd>edit!<CR>

" =============================================================================
" = Commands =
" =============================================================================

command! Config edit $MYVIMRC
command! ConfigReload source $MYVIMRC | noh | execute ':EditorConfigReload'
command! ToggleConceal call <SID>toggle_conceal()

command! CodeshotEnable call <SID>codeshot_enable()
command! CodeshotDisable call <SID>codeshot_disable()

" I can't release my shift key fast enough :')
command! -nargs=* W w
command! -nargs=* Wq wq
command! -nargs=* WQ wq
command! -nargs=* Q q
command! -nargs=* Qa qa
command! -nargs=* QA qa
