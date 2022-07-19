if exists('g:loaded_user#qflist')
  finish
endif

" Close quickfix list or location list
function! s:setqflistMap()
  if !empty(getqflist())
    nnoremap <CR> <CR>:cclose<CR>
  else
    nnoremap <CR> <CR>:lclose<CR>
  endif
endfunction

augroup quickfix_user_events
  autocmd!
  autocmd FileType qf call s:setqflistMap()
augroup END

let g:loaded_user#qflist = 1
