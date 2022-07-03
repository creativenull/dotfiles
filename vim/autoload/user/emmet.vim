vim9script

export def Setup(): void
  g:user_emmet_leader_key = '<C-q>'
  g:user_emmet_install_global = 0
  g:user_emmet_mode = 'i'

  augroup emmet_user_events
    autocmd!
    autocmd FileType html,vue,astro EmmetInstall
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact EmmetInstall
    autocmd FileType php,blade EmmetInstall
    autocmd FileType twig,html.twig,htmldjango.twig,xml.twig EmmetInstall
  augroup END
enddef
