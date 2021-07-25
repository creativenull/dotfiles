" Emmet
packadd emmet-vim
EmmetInstall

" Ultisnips
packadd ultisnips
packadd vim-snippets
UltiSnipsAddFiletypes typescript_react

" ALE
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" LSP
call RegisterLsp()
