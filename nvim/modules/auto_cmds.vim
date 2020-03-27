" Set the .h file to be only C specific type
augroup ctype
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

" LSP auto commands
augroup lsp
    autocmd!
    autocmd FileType javascript,javascript.jsx call LSPKeys()
    autocmd FileType typescript,typescript.tsx call LSPKeys()
    autocmd FileType vue call LSPKeys()
    autocmd FileType php call LSPKeys()
augroup END

" Spell checker for .md files
augroup spell
    autocmd!
    autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

" Support transparent background if possible
" augroup transparent_support
"     autocmd!
"     autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
" augroup END
