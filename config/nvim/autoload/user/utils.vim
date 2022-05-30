" Toggle conceal level of local buffer
" which is enabled by some syntax plugin
function! user#utils#ToggleConcealLevel() abort
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction

" Toggle the view of the editor, for taking screenshots
" or for copying code from the editor w/o using "+ register
" when not accessible, eg from a remote ssh
function! user#utils#ToggleCodeshot() abort
  if &number
    setlocal nonumber signcolumn=no
    execute ':IndentLinesDisable'
  else
    setlocal number signcolumn=yes
    execute ':IndentLinesEnable'
  endif
endfunction

" Indent rules given to a filetype, use spaces if needed
function! user#utils#IndentSize(size, use_spaces) abort
  execute printf('setlocal tabstop=%d softtabstop=%d shiftwidth=0', a:size, a:size)
  if !empty(a:use_spaces) && a:use_spaces
    setlocal expandtab
  else
    setlocal noexpandtab
  endif
endfunction
