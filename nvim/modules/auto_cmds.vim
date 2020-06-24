" =============================================================
" = AutoStart Scripts =
" =============================================================
augroup web_dev_ftype
    autocmd!
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
augroup END

augroup markdown_spellchecker
    autocmd!
    autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

augroup lsp_keybindings_by_ftype
    autocmd!
    autocmd FileType javascript,javascript.jsx call RegisterCocLspKeybindings()
    autocmd FileType typescript,typescript.tsx call RegisterCocLspKeybindings()
    autocmd FileType vue call RegisterCocLspKeybindings()
    autocmd FileType php call RegisterCocLspKeybindings()
augroup END
