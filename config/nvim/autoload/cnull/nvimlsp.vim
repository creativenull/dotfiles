function! cnull#nvimlsp#LspStatus() abort
  return luaeval('LspInfoStatusline()')
endfunction
