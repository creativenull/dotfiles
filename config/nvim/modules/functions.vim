" =============================================================
" = Modular Functions =
" =============================================================
" Configure language server protocol keys for CoC
function! RegisterCocLspKeybindings()
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lr <Plug>(coc-rename)
    nmap <silent> <leader>lf :call CocAction('format')<cr>
    nmap <silent> <leader>lh :call CocAction('doHover')<cr>
    nmap <silent> <leader>l] <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>l[ <Plug>(coc-diagnostic-prev)
endfunction

" Light Theme
function! SetLightTheme()
    let g:gruvbox_contrast_light = 'soft'
    let g:gruvbox_sign_column = 'light0_soft'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'light0_soft'
    let g:indentLine_color_term = 242
    set background=light
endfunction

" Dark Theme
function! SetDarkTheme()
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_sign_column = 'dark0_hard'
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_number_column = 'dark0_hard'
    set background=dark
endfunction

" Configure the theme depending on the time of the day, only if day_night_toggle variable is set
function! RegisterTheme()
    if exists('g:day_night_toggle')
        if g:day_night_toggle == 1
            if strftime("%H") >= 6 && strftime("%H") < 18
                call SetLightTheme()
            else
                call SetDarkTheme()
            endif
        else
            call SetDarkTheme()
        endif
    else
        call SetDarkTheme()
    endif
endfunction

" ======
" Config commands to quickly open config files for theme, base and plugins
function! OpenThemeConfig()
    execute 'edit ' . expand(g:modules_dir . '/theme.vim')
endfunction

function! OpenBasicConfig()
    execute 'edit ' . expand(g:modules_dir . '/basic.vim')
endfunction

function! OpenPluginsConfig()
    execute 'edit ' . expand(g:modules_dir . '/plugins.vim')
endfunction

function! OpenKeysConfig()
    execute 'edit ' . expand(g:modules_dir . '/keybindings.vim')
endfunction

function! OpenGUIConfig()
    execute 'edit ' . expand(g:config_dir . '/ginit.vim')
endfunction

function! OpenFunctions()
    execute 'edit ' . expand(g:modules_dir . '/functions.vim')
endfunction

function! OpenAutoStart()
    execute 'edit ' . expand(g:modules_dir . '/auto_cmds.vim')
endfunction

function! OpenCommands()
    execute 'edit ' . expand(g:modules_dir . '/commands.vim')
endfunction
