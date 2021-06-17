function! creativenull#codeshot#enable() abort
  setlocal nonumber norelativenumber signcolumn=no mouse=
endfunction

function! creativenull#codeshot#disable() abort
  setlocal number relativenumber signcolumn=yes mouse=a
endfunction
