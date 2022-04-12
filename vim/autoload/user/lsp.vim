vim9script

def RegisterServers(): void
  augroup user_lsp_events

  # Vim
  const vimls = 'vim-language-server'
  g:userLspVimLangServerOptions = {
    name: vimls,
    cmd: [vimls, '--stdio'],
    allowlist: ['vim'],
  }

  if executable(vimls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:userLspVimLangServerOptions)
  endif

  # JS/TS
  const tsserver = 'typescript-language-server'
  g:userLspTsserverOptions = {
    name: tsserver,
    cmd: [tsserver, '--stdio'],
    allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  }

  if executable(tsserver)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:userLspTsserverOptions)
  endif

  # Vue
  const vuels = 'vue-language-server'
  g:userLspVueLangServerOptions = {
    name: vuels,
    cmd: [vuels, '--stdio'],
    allowlist: ['vue'],
  }

  if executable(vuels)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:userLspVueLangServerOptions)
  endif

  # Go
  const gopls = 'gopls'
  g:userLspGoLangServerOptions = {
    name: gopls,
    cmd: [gopls],
    allowlist: ['go'],
  }

  if executable(gopls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:userLspGoLangServerOptions)
  endif
enddef

export def OnAttachedBuffer(): void
  setlocal omnifunc=lsp#complete

  nmap <buffer> <Leader>ld <Plug>(lsp-definition)
  nmap <buffer> <Leader>lf <Plug>(lsp-document-format)
  nmap <buffer> <Leader>lr <Plug>(lsp-rename)
  nmap <buffer> <Leader>lh <Plug>(lsp-hover-float)
  nmap <buffer> <Leader>la <Plug>(lsp-code-action)
  vmap <buffer> <Leader>la <Plug>(lsp-code-action)
  nmap <buffer> <Leader>le <Plug>(lsp-document-diagnostics)
  nmap <buffer> <Leader>ln <Plug>(lsp-next-diagnostic)
  nmap <buffer> <Leader>lp <Plug>(lsp-previous-diagnostic)
enddef

export def Setup(): void
  g:lsp_diagnostics_enabled = 1
  g:lsp_diagnostics_echo_cursor = 0
  g:lsp_diagnostics_float_cursor = 0
  g:lsp_diagnostics_virtual_text_enabled = 0
  g:lsp_document_code_action_signs_enabled = 0
  g:lsp_document_highlight_enabled = 0

  # Use for debugging
  # let g:lsp_log_verbose = 1
  # let g:lsp_log_file = expand('~/.cache/vim/vim-lsp.log')

  RegisterServers()

  # Main setup
  augroup lsp_user_events
    au!
    autocmd User lsp_buffer_enabled call user#lsp#OnAttachedBuffer()
  augroup END
enddef
