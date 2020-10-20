" Simple vim plugin to load project specific vimrc/init.vim
" Maintainer: Arnold Chand <creativenull@outlook.com>
" License: MIT
if exists('g:loaded_projectrc') || &cp
    finish
endif

let g:loaded_projectrc = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:projectrc_path')
    let g:projectrc_path = getcwd() . '/.vim/settings.vim'
endif

" Check if key value is set
function! s:has_key() abort
    if exists('g:projectrc_key') && g:projectrc_key != ''
        return 1
    endif

    return 0
endfunction

" Compare the key set with the key in settings.vim
function! s:is_key_match() abort
    if !filereadable(g:projectrc_path)
        return 0
    endif

    let l:file_contents = readfile(g:projectrc_path, '', 1)
    let l:secret_key = split(l:file_contents[0], '=')[1]

    return l:secret_key ==# g:projectrc_key
endfunction

" Only load the project settings, if all checks pass
function! s:load_project_settings() abort
    echom '[PROJECTRC] Settings found!'
    execute 'so ' . g:projectrc_path
endfunction

" Initial checks before loading the project settings
function! s:main() abort
    if <SID>has_key() && <SID>is_key_match()
        call <SID>load_project_settings()
    endif
endfunction

" Manual function to run if not auto-triggered
function! projectrc#start() abort
    call <SID>main()
endfunction

call projectrc#start()

let &cpo = s:save_cpo
unlet s:save_cpo
