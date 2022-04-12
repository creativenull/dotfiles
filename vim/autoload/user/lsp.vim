vim9script

def RegisterServers(): void
  augroup user_lsp_events

  # Vim
  const vimls = 'vim-language-server'
  g:user_lsp_vimlsOpts = {
    name: vimls,
    cmd: (serverInfo) => [vimls, '--stdio'],
    allowlist: ['vim'],
  }

  if executable(vimls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user_lsp_vimlsOpts)
  endif

  # JS/TS
  const tsserver = 'typescript-language-server'
  g:user_lsp_tsserverOpts = {
    name: tsserver,
    cmd: (serverInfo) => [tsserver, '--stdio'],
    allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  }

  if executable(tsserver)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user_lsp_tsserverOpts)
  endif

  # Vue
  const vuels = 'vue-language-server'
  g:user_lsp_vuelsOpts = {
    name: vuels,
    cmd: (serverInfo) => [vuels, '--stdio'],
    allowlist: ['vue'],
  }

  if executable(vuels)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user_lsp_vuelsOpts)
  endif

  # Go
  const gopls = 'gopls'
  g:user_lsp_goplsOpts = {
    name: gopls,
    cmd: (serverInfo) => [gopls],
    allowlist: ['go'],
  }

  if executable(gopls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user_lsp_goplsOpts)
  endif
enddef

export def LspOnAttach(): void
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
  # Plugin config
  g:lsp_diagnostics_enabled = 0
  g:lsp_document_highlight_enabled = 0

  # Use for debugging
  # let g:lsp_log_verbose = 1
  # let g:lsp_log_file = expand('~/.cache/vim/vim-lsp.log')

  # Keymaps
  imap <C-@> <Plug>(asyncomplete_force_refresh)
  inoremap <expr> <Tab> pumvisible() ? asyncomplete#close_popup() : "\<Tab>"
  inoremap <expr> <CR>  pumvisible() ? asyncomplete#close_popup() : "\<CR>"

  # Register LSP servers
  RegisterServers()

  # LSP specific settings
  augroup lsp_user_events
    au!
    autocmd User lsp_buffer_enabled call cnull#lsp#LspOnAttach()
  augroup END
enddef
