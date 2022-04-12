" Strip sign column, number line, etc to be able
" to copy and paste from a vim instance that has
" mouse disabled, or not able to use `"+y`.
"
" Example of such and instance is running vim in WSL2
function! user#utils#ToggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
    execute ':IndentLinesDisable'
  else
    setlocal number signcolumn=yes
    execute ':IndentLinesEnable'
  endif
endfunction

" Toggle the conceallevel, should any syntax plugin overtake
" and hide/conceal words
function! user#utils#ToggleConcealLevel() abort
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction

" Check if the vim instance is running on a WSL vm
" Ref: https://github.com/neovim/neovim/issues/12642#issuecomment-658944841
function! user#utils#IsWSL() abort
  let l:proc_version = '/proc/version'

  return filereadable(l:proc_version)
    \  ? !empty(filter(readfile(l:proc_version, '', 1), { _, val -> val =~? 'microsoft' }))
    \  : v:false
  ))
endfunction
