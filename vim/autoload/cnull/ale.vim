function! cnull#ale#stl_err_component() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let errors = info.error
    if errors > 0
      return printf('%d', errors)
    endif
  endif

  return ''
endfunction

function! cnull#ale#stl_warn_component() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let warnings = info.warning
    if warnings > 0
      return printf('%d', warnings)
    endif
  endif

  return ''
endfunction

function! cnull#ale#stl_status() abort
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
endfunction
