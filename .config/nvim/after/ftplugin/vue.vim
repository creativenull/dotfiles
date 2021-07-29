" Common Packages on-demand loading
call LoadCommonFtPackages()

" Emmet
packadd emmet-vim
EmmetInstall

" ALE
let b:ale_linters = ['vls']

" LSP
packadd deoplete.nvim
call RegisterLsp()
