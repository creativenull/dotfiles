" LSP key mappings
function! LSPKeys()
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lr <Plug>(coc-rename)
    nmap <silent> <leader>lf :call CocAction('format')<cr>
    nmap <silent> <leader>lh :call CocAction('doHover')<cr>
    nmap <silent> <leader>l] <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>l[ <Plug>(coc-diagnostic-prev)
endfunction

function! OpenThemeConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/theme.vim')
endfunction

function! OpenBasicConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/basic.vim')
endfunction

function! OpenPluginsConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/plugins.vim')
endfunction
