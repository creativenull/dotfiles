function! cnull#utils#ToggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
    execute ':IndentLinesDisable'
  else
    setlocal number signcolumn=yes
    execute ':IndentLinesEnable'
  endif
endfunction

function! cnull#utils#ToggleConcealLevel() abort
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction
