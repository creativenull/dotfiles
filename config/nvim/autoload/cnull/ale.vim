function! cnull#ale#Setup() abort
  let g:ale_disable_lsp = 1
  let g:ale_completion_enabled = 0
  let g:ale_completion_autoimport = 1
  let g:ale_hover_cursor = 0
  let g:ale_echo_msg_error_str = 'Err'
  let g:ale_sign_error = 'E'
  let g:ale_echo_msg_warning_str = 'Warn'
  let g:ale_sign_warning = 'W'
  let g:ale_echo_msg_info_str = 'Info'
  let g:ale_sign_info = 'I'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_linters_explicit = 1
  let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

  " Keymaps
  nnoremap <silent> <Leader>af <Cmd>ALEFix<CR>
  nnoremap <silent> <Leader>ai <Cmd>ALEInfo<CR>
endfunction

function! cnull#ale#StlErrComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let errors = info.error
    if errors > 0
      return printf('%d', errors)
    endif
  endif

  return ''
endfunction

function! cnull#ale#StlWarnComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let warnings = info.warning
    if warnings > 0
      return printf('%d', warnings)
    endif
  endif

  return ''
endfunction

function! cnull#ale#StlStatus()
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
endfunction
