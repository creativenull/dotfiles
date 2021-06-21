let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = {'typescriptreact': ['prettier_eslint']}
call RegisterLsp()
