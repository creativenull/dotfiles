function! cnull#ale#Setup() abort
  let g:ale_completion_enabled = 0
  let g:ale_disable_lsp = 1
  let g:ale_hover_cursor = 0
  let g:ale_echo_msg_error_str = ''
  let g:ale_echo_msg_warning_str = ''
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_linters_explicit = 1
  let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

  nnoremap <silent> <Leader>ai <Cmd>ALEInfo<CR>
  nnoremap <silent> <Leader>af <Cmd>ALEFix<CR>
  nnoremap <silent> <Leader>al <Cmd>lopen<CR>

  augroup ale_lightline_user_events
    autocmd!

    " Update lightline whenever ALE lints or formats the code
    autocmd User ALEJobStarted call lightline#update()
    autocmd User ALELintPost call lightline#update()
    autocmd User ALEFixPost call lightline#update()
  augroup END

  if g:user.enable_transparent
    augroup ale_transparent_user_events
      autocmd!

      " Transparent colors for code highlight by ALE
      autocmd ColorScheme * highlight ALEError cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=LightRed
      autocmd ColorScheme * highlight ALEWarning cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=Yellow
      autocmd ColorScheme * highlight ALEInfo cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=LightBlue

      " Transparent colors for signs by ALE
      autocmd ColorScheme * highlight ALEErrorSign ctermbg=NONE guibg=NONE guifg=LightRed
      autocmd ColorScheme * highlight ALEWarningSign ctermbg=NONE guibg=NONE guifg=Yellow
      autocmd ColorScheme * highlight ALEInfoSign ctermbg=NONE guibg=NONE guifg=LightBlue
    augroup END
  endif
endfunction
