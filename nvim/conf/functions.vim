" Configure language server protocol keys for CoC
function! LSPKeys()
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lr <Plug>(coc-rename)
    nmap <silent> <leader>lf :call CocAction('format')<cr>
    nmap <silent> <leader>lh :call CocAction('doHover')<cr>
    nmap <silent> <leader>l] <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>l[ <Plug>(coc-diagnostic-prev)
endfunction

" Theme (Light theme during the day - 6am to 6pm, Dark theme at night - 6pm to 6am)
function! SetupThemeBackground()
    if strftime("%H") >= 6 && strftime("%H") < 18
        " Light theme
        let g:gruvbox_contrast_light='soft'
        let g:gruvbox_sign_column='light0_soft'
        let g:gruvbox_invert_selection=0
        let g:gruvbox_number_column='light0_soft'
        let g:indentLine_color_term=242

        set background=light
    else
        " Dark theme
        let g:gruvbox_contrast_dark='hard'
        let g:gruvbox_sign_column='dark0_hard'
        let g:gruvbox_invert_selection=0
        let g:gruvbox_number_column='dark0_hard'

        set background=dark
    endif
endfunction

" Config commands to quickly open config files for theme, base and plugins
function! OpenThemeConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/theme.vim')
endfunction

function! OpenBasicConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/basic.vim')
endfunction

function! OpenPluginsConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/plugins.vim')
endfunction

function! OpenKeysConfig()
    execute 'edit ' . expand(g:local_conf_dir . '/keybindings.vim')
endfunction
