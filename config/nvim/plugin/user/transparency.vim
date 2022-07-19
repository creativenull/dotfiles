if exists('g:loaded_user#transparency')
  finish
endif

if g:user.transparent
  augroup transparent_user_events
    autocmd!
    autocmd ColorScheme * call transparency#setHighlights()
  augroup END
endif

let g:loaded_user#transparency = 1
