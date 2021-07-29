" Common Packages on-demand loading
call LoadCommonFtPackages()

" Emmet
packadd emmet-vim
EmmetInstall

" Ultisnips
UltiSnipsAddFiletypes javascript_react

" ALE
let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['prettier']

" LSP
packadd deoplete.nvim
call RegisterLsp()
