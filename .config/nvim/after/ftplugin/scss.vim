" Common Packages on-demand loading
call LoadCommonFtPackages()

" ALE
let b:ale_linters = ['stylelint']

" LSP
packadd deoplete.nvim
call RegisterLsp()
