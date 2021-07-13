" Emmet
packadd emmet-vim
EmmetInstall

" Ultisnips
UltiSnipsAddFiletypes typescript_react

" ALE
let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['prettier']
call RegisterLsp()
