" Emmet
packadd emmet-vim
EmmetInstall

" Ultisnips
packadd ultisnips
packadd vim-snippets
UltiSnipsAddFiletypes javascript_react

" ALE
let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['prettier']

" LSP
call RegisterLsp()
