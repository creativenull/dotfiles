filetype plugin indent on

" Pack
set packpath-=~/.config/nvim
set packpath-=~/.config/nvim/after
set packpath-=~/.local/share/nvim/site
set packpath-=~/.local/share/nvim/site/after
set packpath-=/etc/xdg/nvim
set packpath-=/etc/xdg/nvim/after
set packpath-=/usr/local/share/nvim/site
set packpath-=/usr/local/share/nvim/site/after
set packpath-=/usr/share/nvim/site
set packpath-=/usr/share/nvim/site/after

set packpath^=~/.config/nvim-nightly
set packpath+=~/.config/nvim-nightly/after
set packpath^=~/.local/share/nvim-nightly/site
set packpath+=~/.local/share/nvim-nightly/site/after

" Runtime
set runtimepath-=~/.config/nvim
set runtimepath-=~/.config/nvim/after
set runtimepath-=~/.local/share/nvim/site
set runtimepath-=~/.local/share/nvim/site/after
set runtimepath-=/etc/xdg/nvim
set runtimepath-=/etc/xdg/nvim/after
set runtimepath-=/usr/share/nvim/site
set runtimepath-=/usr/share/nvim/site/after
set runtimepath-=/usr/local/share/nvim/site
set runtimepath-=/usr/local/share/nvim/site/after

set runtimepath+=~/.config/nvim-nightly/after
set runtimepath^=~/.config/nvim-nightly
set runtimepath+=~/.local/share/nvim-nightly/site/after
set runtimepath^=~/.local/share/nvim-nightly/site

" =============================================================================
" = Project Key =
" =============================================================================

let g:projectrc_key = $NVIMRC_PROJECT_KEY

" =============================================================================
" = Plugin Manager =
" =============================================================================

function! MinPacInit() abort
    packadd minpac

    call minpac#init()
    call minpac#add('k-takata/minpac', { 'type': 'opt' })

    " Core
    call minpac#add('creativenull/projectcmd.nvim', { 'type': 'opt' })
    call minpac#add('editorconfig/editorconfig-vim')
    call minpac#add('jiangmiao/auto-pairs')
    call minpac#add('tpope/vim-surround')
    call minpac#add('Shougo/context_filetype.vim')
    call minpac#add('tyru/caw.vim')
    call minpac#add('lewis6991/gitsigns.nvim', { 'type': 'opt' })
    
    " LSP
    call minpac#add('neovim/nvim-lspconfig', { 'type': 'opt' })
    call minpac#add('nvim-lua/completion-nvim', { 'type': 'opt' })
    call minpac#add('nvim-lua/lsp-status.nvim', { 'type': 'opt' })
    call minpac#add('nvim-lua/popup.nvim', { 'type': 'opt' })
    call minpac#add('nvim-lua/plenary.nvim', { 'type': 'opt' })
    call minpac#add('nvim-telescope/telescope.nvim', { 'type': 'opt' })
    
    " Theme
    call minpac#add('gruvbox-community/gruvbox')
    call minpac#add('itchyny/lightline.vim')
    call minpac#add('itchyny/vim-gitbranch')
    call minpac#add('yggdroot/indentline')
    call minpac#add('ap/vim-buftabline')
    call minpac#add('nvim-treesitter/nvim-treesitter', { 'type': 'opt' })
endfunction

" Lua Plugins
packadd gitsigns.nvim
packadd projectcmd.nvim

packadd nvim-lspconfig
packadd completion-nvim
packadd lsp-status.nvim
packadd popup.nvim
packadd plenary.nvim
packadd telescope.nvim
packadd nvim-treesitter

" =============================================================================
" = Plugin Options =
" =============================================================================

" --- LSP Config ---
lua require('init')

" --- Telescope ---
nnoremap <C-p> <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <C-t> <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>

" --- Lightline ---
let g:lightline = {
    \   'enable': { 'tabline': 0 },
    \   'colorscheme': 'gruvbox',
    \   'component': { 'line': '%l/%L' },
    \   'component_function': {
    \       'gitbranch': 'gitbranch#name',
    \       'lsp': 'LSP_StatusLine',
    \   },
    \   'active': {
    \       'left': [ [ 'mode', 'paste' ], [ 'gitbranch' ] ],
    \       'right': [ [ 'lsp' ], [ 'line' ], [ 'filetype' ] ],
    \   },
    \ }

" --- vim-buftabline ---
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" =============================================================================
" = Auto Commands =
" =============================================================================

" =============================================================================
" = Functions =
" =============================================================================

" Display LSP diagnostics to statusline
function! LSP_StatusLine() abort
    " let l:diagnostics = luaeval("require('lsp-status').diagnostics()")
    let l:diagnostics = { 'errors': 0, 'warnings': 0 }
    let l:errors = l:diagnostics.errors
    let l:warnings = l:diagnostics.warnings

    if l:errors > 0 || l:warnings > 0
        return printf('LSP %d 🔴 %d 🟡', l:errors, l:warnings)
    endif

    return ''
endfunction

" Register LSP keys
function! LSP_RegisterKeys()
    nmap <silent> <F2>       <cmd>lua vim.lsp.buf.rename()<CR>
    nmap <silent> <leader>lm <cmd>lua vim.lsp.diagnostic.code_action()<CR>
    nmap <silent> <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
    nmap <silent> <leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>
    nmap <silent> <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
    nmap <silent> <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
    nmap <silent> <leader>le <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
endfunction

function! ToggleConceal()
    if &conceallevel == 0
        set conceallevel=2
    elseif &conceallevel == 2
        set conceallevel=0
    endif
endfunction

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

" Reload file
nnoremap <leader>r :e!<CR>

" =============================================================================
" = Commands =
" =============================================================================
command! PackUpdate source $MYVIMRC | call MinPacInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call MinPacInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

command! Config edit $MYVIMRC
command! ConfigLua edit $HOME/.config/nvim-nightly/lua/init.lua
command! ConfigReload source $MYVIMRC | noh

command! ToggleConceal call ToggleConceal()

" =============================================================================
" = Theming and Looks =
" =============================================================================

syntax on
set number
set termguicolors
set relativenumber
set background=dark

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_sign_column = 'dark0_hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_number_column = 'dark0_hard'

colorscheme gruvbox
