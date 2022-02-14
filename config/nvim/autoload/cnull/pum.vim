function! cnull#pum#Setup() abort
  let g:enable_custom_pum = v:false

  if g:enable_custom_pum
    call pum#set_option('border', 'rounded')

    inoremap <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
    inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
    inoremap <C-n> <Cmd>call pum#map#insert_relative(+1)<CR>
    inoremap <C-p> <Cmd>call pum#map#insert_relative(-1)<CR>
    inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
    inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

    augroup pum_user_events
      autocmd!
      autocmd ColorScheme * highlight! Pmenu guibg=NONE
    augroup END
  endif
endfunction
