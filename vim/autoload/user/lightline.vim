vim9script

export def Setup(): void
  g:lightline = {
    colorscheme: 'tailwind_cnull',
    enable: {
      statusline: 1,
      tabline: 1,
    },

    tabline: {
      left: [ ['buffers'] ],
      right: [ ['filetype'] ],
    },

    component: { 'lineinfo': ' %l/%L  %c' },

    separator: {
      left: '',
      right: '',
    },

    active: {
      left: [ ['filename'], ['gitbranch', 'readonly', 'modified'] ],
      right: [ ['ale_err', 'ale_warn', 'ale_status'], ['filetype', 'fileencoding'], ['lineinfo'] ],
    },

    inactive: {
      left: [ ['filename'], ['gitbranch', 'modified'] ],
      right: [ [], [], ['lineinfo'] ],
    },

    component_function: {
      gitbranch: 'FugitiveHead',
      ale_status: 'user#lightline#AleStatus',
    },

    component_expand: {
      ale_err: 'user#lightline#AleErrComponent',
      ale_warn: 'user#lightline#AleWarnComponent',
      buffers: 'lightline#bufferline#buffers',
    },

    component_type: {
      ale_err: 'error',
      ale_warn: 'warning',
      buffers: 'tabsel',
    },
  }
enddef

export def AleErrComponent(): string
  if exists('g:loaded_ale')
    let l:info = ale#statusline#Count(bufnr(''))
    let l:errors = l:info.error

    if l:errors > 0
      return printf('%d', l:errors)
    endif
  endif

  return ''
enddef

export def AleWarnComponent(): string
  if exists('g:loaded_ale')
    let l:info = ale#statusline#Count(bufnr(''))
    let l:warnings = l:info.warning

    if l:warnings > 0
      return printf('%d', l:warnings)
    endif
  endif

  return ''
enddef

export def AleStatus(): string
  if exists('g:loaded_ale')
    return 'ALE'
  endif

  return ''
enddef
