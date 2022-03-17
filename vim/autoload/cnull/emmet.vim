function! cnull#emmet#Setup() abort
  let g:user_emmet_leader_key = '<C-q>'
  let g:user_emmet_install_global = 0
  let g:user_emmet_mode = 'i'

  augroup emmet_user_events
    autocmd!

    autocmd FileType html EmmetInstall
    autocmd FileType blade EmmetInstall
    autocmd FileType php EmmetInstall
    autocmd FileType javascriptreact EmmetInstall
    autocmd FileType typescriptreact EmmetInstall
    autocmd FileType vue EmmetInstall

  augroup END
endfunction
