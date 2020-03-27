" =============================================================
" = Vim.plug =
" =============================================================
call plug#begin(g:plugins_dir)
    " ======== Core ========
    Plug 'Shougo/context_filetype.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'godlygeek/tabular'
    Plug 'mattn/emmet-vim'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tyru/caw.vim'
    Plug 'psliwka/vim-smoothie'

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
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinPos = 'right'
let g:NERDTreeShowHidden = 1

" --- Fuzzy Finder Options ---
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" --- vim-polyglot Options ---
let g:vue_pre_processors = ['typescript', 'scss']
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" --- Airline Options ---
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#nerdtree_status = 0
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%t'
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = "\uE0A1 %l/%L"

" --- Coc Extensions ---
let g:coc_global_extensions = [
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-marketplace',
    \ 'coc-phpls',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ ]

" --- Emmet ---
let g:user_emmet_leader_key = '<C-z>'
