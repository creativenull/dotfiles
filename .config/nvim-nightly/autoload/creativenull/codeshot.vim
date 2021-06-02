function! creativenull#codeshot#enable() abort
  setlocal nolist nonumber norelativenumber signcolumn=no
endfunction

function! creativenull#codeshot#disable() abort
  setlocal list number relativenumber signcolumn=yes
endfunction
