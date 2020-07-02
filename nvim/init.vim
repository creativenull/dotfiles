" =============================================================
" Arnold Chand
" (neo)vim config file
" Cross-platform, runs on Linux, Windows and OS X (maybe?)
" https://github.com/creativenull
" =============================================================
filetype plugin indent on
set encoding=utf-8

" Global variable to use for config
" ---
" Python host
let g:python3_host_prog = $PYTHON3_HOST_PROG
let g:python_host_prog = $PYTHON_HOST_PROG

" Sort install dir for plugins
let g:config_dir = '~/.config/nvim'
let g:local_dir = '~/.local/share/nvim'
let g:plugins_dir = '~/.local/share/nvim/plugged'
let g:modules_dir = g:config_dir . '/modules'

" Windows specific paths
if has('win32')
    let g:config_dir = '~/AppData/Local/nvim'
    let g:local_dir = g:config_dir
    let g:plugins_dir = '~/AppData/Local/nvim/plugged'
    let g:modules_dir = g:config_dir . '/modules'
endif

" Load core settings
execute 'source ' . expand(g:modules_dir . '/functions.vim')
execute 'source ' . expand(g:modules_dir . '/auto_cmds.vim')
execute 'source ' . expand(g:modules_dir . '/commands.vim')
execute 'source ' . expand(g:modules_dir . '/basic.vim')
execute 'source ' . expand(g:modules_dir . '/keybindings.vim')

" Load Plugins
execute 'source ' . expand(g:modules_dir . '/plugins.vim')

" Load Theme
execute 'source ' . expand(g:modules_dir . '/theme.vim')
