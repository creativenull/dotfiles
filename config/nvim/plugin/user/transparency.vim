if exists('g:loaded_user#transparency')
  finish
endif

let g:loaded_user#transparency = 1

if g:user.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * call transparency#setHighlights()
  augroup END
endif
