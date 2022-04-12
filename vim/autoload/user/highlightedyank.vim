function! user#highlightedyank#Setup() abort
  let g:highlightedyank_highlight_duration = 300

  augroup highlightedyank_user_events
    autocmd!

    " Link to search highlight
    autocmd ColorScheme * highlight! default link HighlightedyankRegion IncSearch
  augroup END
endfunction
