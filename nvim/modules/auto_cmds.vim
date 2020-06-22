" Set the .h file to be only C specific type
augroup ctype
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

" JS/JSX filetypes
augroup jstype
    autocmd!
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
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
