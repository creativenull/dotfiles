function! cnull#pum#Setup() abort
  let g:enable_custom_pum = v:false

  if g:enable_custom_pum
    call pum#set_option('border', 'rounded')

    inoremap <expr> <C-n> pum#map#insert_relative(+1)
    inoremap <expr> <C-p> pum#map#insert_relative(-1)
    inoremap <expr> <C-y> pum#map#confirm()
    inoremap <expr> <C-e> pum#map#cancel()

    augroup pum_user_events
      autocmd!
      autocmd ColorScheme * highlight! Pmenu guibg=NONE
    augroup END
  endif
endfunction
