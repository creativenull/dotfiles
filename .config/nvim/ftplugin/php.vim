" --- ALE PHP intelephense ---
call ale#linter#Define('php', {
    \   'name': 'intelephense_ftplugin',
    \   'lsp': 'stdio',
    \   'executable': 'intelephense',
    \   'command': '%e --stdio',
    \   'project_root': function('ale_linters#php#langserver#GetProjectRoot')
    \ })
