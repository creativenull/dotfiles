" Emmet
EmmetInstall

" Ultisnips
UltiSnipsAddFiletypes typescript_react

" ALE
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" LSP
call RegisterLsp()
