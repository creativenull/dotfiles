function! cnull#highlightedyank#Setup() abort
  let g:highlightedyank_highlight_duration = 300

  " Change yank color
  augroup highlightedyank_user_events
    autocmd!

    autocmd! ColorScheme * highlight! default link HighlightedyankRegion IncSearch

  augroup END
endfunction
