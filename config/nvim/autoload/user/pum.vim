function! user#pum#Setup() abort
  inoremap <expr> <C-n> pum#map#insert_relative(+1)
  inoremap <expr> <C-p> pum#map#insert_relative(-1)
  inoremap <expr> <C-y> user#pum#confirm("\<C-y>")
  inoremap <expr> <C-e> pum#map#cancel()

  augroup pum_user_events
    autocmd!
    autocmd ColorScheme * highlight! Pmenu guibg=NONE
  augroup END
endfunction

function! user#pum#confirm(default) abort
  if ddc#map#pum_visible()
    if vsnip#expandable()
      return "\<Plug>(vsnip-expand)"
    else
      return pum#map#confirm()
    endif
  endif

  return a:default
endfunction
