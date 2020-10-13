" Simple vim plugin to load project specific vimrc/init.vim
" Maintainer: Arnold Chand <creativenull@outlook.com>
" License: MIT
if exists('g:loaded_projectrc') || &cp
    finish
endif

let g:loaded_projectrc = 1

let s:save_cpo = &cpo
set cpo&vim

let s:default_settings_path = '/.vim/settings.vim'

" Retrieve the settings filepath relative to the root project path
function! s:get_settings_path() abort
    return exists('g:projectrc_path') ? getcwd() . g:projectrc_path : getcwd() . s:default_settings_path
endfunction

" Check if the file exists
function! s:settings_exists() abort
    return filereadable(<SID>get_settings_path())
endfunction

" Check if key value is set
function! s:has_key() abort
    if exists('g:projectrc_key') && g:projectrc_key != ''
        return 1
    endif

    return 0
endfunction

" Compare the key set with the key in settings.vim
function! s:is_key_match() abort
    if !<SID>settings_exists()
        return 0
    endif

    let l:file_contents = readfile(<SID>get_settings_path(), '', 1)
    let l:secret_key = split(l:file_contents[0], '=')[1]

    return l:secret_key ==# g:projectrc_key
endfunction

" Only load the project settings, if all checks pass
function! s:load_project_settings() abort
    echom '[projectrc] Settings found!'
    execute 'so ' . <SID>get_settings_path()
endfunction

" Initial checks before loading the project settings
function! s:run_projectrc() abort
    if <SID>has_key() && <SID>is_key_match()
        call <SID>load_project_settings()
    endif
endfunction

call <SID>run_projectrc()

let &cpo = s:save_cpo
unlet s:save_cpo
