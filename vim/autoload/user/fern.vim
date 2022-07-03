vim9script

def FernKeymaps(): void
  nnoremap <buffer> <nowait> q <Cmd>bd<CR>
  nmap <buffer> D <Plug>(fern-action-remove)
enddef

export def Setup(): void
  g:fern#renderer = 'nerdfont'
  g:fern#hide_cursor = 1

  nnoremap <silent> <Leader>ff <Cmd>Fern . -reveal=%<CR>

  augroup fern_user_events
    autocmd!
    autocmd FileType fern call FernKeymaps()
    autocmd ColorScheme * highlight CursorLine guibg=#EEEEEE guifg=#222222
  augroup END
enddef
