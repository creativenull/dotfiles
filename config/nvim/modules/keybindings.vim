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

" Map Esc, to perform quick switching between Normal and Insert mode
inoremap jk <C-[>

" Map escape from terminal input to Normal mode
tnoremap <C-[> <C-\><C-n>
tnoremap <ESc> <C-\><C-n>

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

" Window maps
" ---
" move to the split in the direction shown, or create a new split
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>

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
nnoremap <leader>vs :so $MYVIMRC<CR>:noh<CR>:EditorConfigReload<CR>
