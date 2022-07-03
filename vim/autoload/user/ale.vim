vim9script

def SetTransparentHighlights()
  # Transparent colors for code highlight by ALE
  highlight! ALEError cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=LightRed
  highlight! ALEWarning cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=Yellow
  highlight! ALEInfo cterm=underline ctermbg=NONE gui=underline guibg=NONE guifg=LightBlue

  # Transparent colors for signs by ALE
  highlight! ALEErrorSign ctermbg=NONE guibg=NONE guifg=LightRed
  highlight! ALEWarningSign ctermbg=NONE guibg=NONE guifg=Yellow
  highlight! ALEInfoSign ctermbg=NONE guibg=NONE guifg=LightBlue
enddef

export def Setup()
  g:ale_completion_enabled = 0
  g:ale_disable_lsp = 1
  g:ale_hover_cursor = 0
  g:ale_echo_msg_error_str = 'Err'
  g:ale_sign_error = ' '
  g:ale_echo_msg_warning_str = 'Warn'
  g:ale_sign_warning = ' '
  g:ale_echo_msg_info_str = 'Info'
  g:ale_sign_info = ' '
  g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  g:ale_linters_explicit = 1
  g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

  nnoremap <silent> <Leader>ai <Cmd>ALEInfo<CR>
  nnoremap <silent> <Leader>af <Cmd>ALEFix<CR>
  nnoremap <silent> <Leader>al <Cmd>lopen<CR>

  # Update lightline whenever ALE lints or formats the code
  augroup ale_lightline_user_events
    autocmd!
    autocmd User ALEJobStarted call lightline#update()
    autocmd User ALELintPost call lightline#update()
    autocmd User ALEFixPost call lightline#update()
  augroup END

  if g:user.enable_transparent
    augroup ale_transparent_user_events
      autocmd!
      autocmd ColorScheme * SetTransparentHighlights()
    augroup END
  endif
enddef
