" Ultisnips
packadd ultisnips
packadd vim-snippets

" ALE
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" LSP
call RegisterLsp()
