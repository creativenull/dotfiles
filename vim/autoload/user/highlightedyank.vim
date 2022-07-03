vim9script

export def Setup(): void
  g:highlightedyank_highlight_duration = 300

  # Link to search highlight
  augroup highlightedyank_user_events
    autocmd!
    autocmd ColorScheme * highlight! default link HighlightedyankRegion IncSearch
  augroup END
enddef
