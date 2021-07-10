" Emmet
EmmetInstall

" ALE
let b:ale_linters = ['intelephense', 'phpcs', 'phpstan', 'php']
let b:ale_fixers = ['phpcbf']

" LSP
call RegisterLsp()
