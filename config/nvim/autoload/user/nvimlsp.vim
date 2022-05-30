function! user#nvimlsp#LspStatus() abort
  return luaeval('LspInfoStatusline()')
endfunction
