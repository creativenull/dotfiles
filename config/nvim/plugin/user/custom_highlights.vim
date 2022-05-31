if exists('g:loaded_user#highlights')
  finish
endif

let g:loaded_user#highlights = 1

augroup customhl_user_events
  autocmd!
  " Don't want any bold or underlines on the tabline
  autocmd ColorScheme * highlight Tabline gui=NONE
  " Show different color in substitution mode aka `:substitute` / `:s`
  autocmd ColorScheme * highlight IncSearch gui=NONE guibg=#103da5 guifg=#eeeeee
augroup END
