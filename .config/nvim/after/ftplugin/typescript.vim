" Common Packages on-demand loading
call LoadCommonFtPackages()

" ALE
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

" LSP
packadd deoplete.nvim
call RegisterLsp()
