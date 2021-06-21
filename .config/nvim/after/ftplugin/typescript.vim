let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = {'typescript': ['prettier_eslint']}
call RegisterLsp()
