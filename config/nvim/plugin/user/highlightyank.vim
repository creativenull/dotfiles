if exists('g:loaded_user#highlightyank')
  finish
endif

augroup highlightyank_user_events
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
augroup END

let g:loaded_user#highlightyank = 1
