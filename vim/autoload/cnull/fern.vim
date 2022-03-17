function! cnull#fern#Setup() abort
  let g:fern#renderer = 'nerdfont'
  let g:fern#hide_cursor = 1

  nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

  " Register keymaps specific to the fern buffer and ensure
  " proper highlight color
  augroup fern_user_events
    autocmd!

    autocmd FileType fern call cnull#fern#AddFernKeymaps()
    autocmd ColorScheme * highlight! default link CursorLine Visual

  augroup END
endfunction

function! cnull#fern#AddFernKeymaps() abort
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
endfunction
