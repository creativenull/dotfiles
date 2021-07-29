" Common Packages on-demand loading
call LoadCommonFtPackages()

" Emmet
packadd emmet-vim
EmmetInstall

" Ultisnips
UltiSnipsAddFiletypes typescript_react

" ALE
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" LSP
packadd deoplete.nvim
call RegisterLsp()
