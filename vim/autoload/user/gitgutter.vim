function! user#gitgutter#Setup() abort
  if g:user.enable_transparent
    augroup gitgutter_user_events
      autocmd!

      autocmd ColorScheme * highlight GitGutterAdd cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
      autocmd ColorScheme * highlight GitGutterChange cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
      autocmd ColorScheme * highlight GitGutterChangeDelete cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
      autocmd ColorScheme * highlight GitGutterDelete cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
    augroup END
  endif
endfunction
