function! cnull#fern#Setup() abort
  let g:fern#renderer = 'nerdfont'
  let g:fern#hide_cursor = 1

  nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>
endfunction
