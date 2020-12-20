" --- intelephense ---
call ale#linter#Define('php', {
    \   'name': 'intelephense_php',
    \   'lsp': 'stdio',
    \   'executable': 'intelephense',
    \   'command': '%e --stdio',
    \   'project_root': function('ale_linters#php#langserver#GetProjectRoot')
    \ })

let b:ale_linters = ['intelephense_php', 'phpcs', 'phpstan']

call deoplete#enable()
call SetLspKeymaps()
setlocal omnifunc=ale#completion#OmniFunc
