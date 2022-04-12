function! user#fern#Setup() abort
  let g:fern#renderer = 'nerdfont'
  let g:fern#hide_cursor = 1

  nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

  augroup fern_user_events
    au!
    autocmd ColorScheme * highlight CursorLine guibg=#EEEEEE guifg=#222222
  augroup END
endfunction
