" =============================================================
" = AutoStart Scripts =
" =============================================================
augroup register_filetypes
    au!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    au BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    au BufNewFile,BufRead *.riot set filetype=html
augroup END

augroup enable_spellchecker
    au!
    au FileType markdown setlocal spell spelllang=en_us
augroup END

augroup enable_lsp
    au!
    au FileType javascript,javascript.jsx call RegisterCocLspKeybindings()
    au FileType typescript,typescript.tsx call RegisterCocLspKeybindings()
    au FileType vue call RegisterCocLspKeybindings()
    au FileType php call RegisterCocLspKeybindings()
augroup END
