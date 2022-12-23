function! user#lightline#StlErrComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let errors = info.error
    if errors > 0
      return printf('%d', errors)
    endif
  endif

  return ''
endfunction

function! user#lightline#StlWarnComponent() abort
  if exists('g:loaded_ale')
    let info = ale#statusline#Count(bufnr(''))
    let warnings = info.warning
    if warnings > 0
      return printf('%d', warnings)
    endif
  endif

  return ''
endfunction

function! user#lightline#StlStatus()
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
endfunction

function! user#lightline#GitBranch() abort
  if gitbranch#name() != ''
    return printf(' %s', gitbranch#name())
  endif

  return ''
endfunction

function! user#lightline#LspStatus() abort
  return luaeval('LspInfoStatusline()')
endfunction
