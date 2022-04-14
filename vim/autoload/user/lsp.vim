vim9script

# Register LSP servers assuming they are installed in the system
# within a custom user autocmd group.
def RegisterServers(): void
  g:user#lsp_opts = {}

  augroup user_lsp_events

  # Vim
  const vimls = 'vim-language-server'
  g:user#lsp_opts.vim = {
    name: vimls,
    cmd: [vimls, '--stdio'],
    allowlist: ['vim'],
  }

  if executable(vimls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user#lsp_opts.vim)
  endif

  # JS/TS
  const tsserver = 'typescript-language-server'
  g:user#lsp_opts.tsserver = {
    name: tsserver,
    cmd: [tsserver, '--stdio'],
    allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  }

  if executable(tsserver)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user#lsp_opts.tsserver)
  endif

  # Vue
  const vuels = 'vue-language-server'
  g:user#lsp_opts.vue = {
    name: vuels,
    cmd: [vuels, '--stdio'],
    allowlist: ['vue'],
  }

  if executable(vuels)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user#lsp_opts.vue)
  endif

  # Go
  const gopls = 'gopls'
  g:user#lsp_opts.go = {
    name: gopls,
    cmd: [gopls],
    allowlist: ['go'],
  }

  if executable(gopls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user#lsp_opts.go)
  endif

  # PHP
  const phpls = 'intelephense'
  g:user#lsp_opts.php = {
    name: phpls,
    cmd: [phpls, '--stdio'],
    allowlist: ['php'],
  }

  if executable(phpls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(g:user#lsp_opts.php)
  endif
enddef

export def SetLspBorderHighlights(): void
  highlight UserLspFloatBorder guibg=NONE guifg=#eeeeee
  highlight UserLspFloat guibg=NONE
enddef

export def SetLspPopupOptions(): void
  popup_setoptions(lsp#ui#vim#output#getpreviewwinid(), {
    highlight: 'UserLspFloat',
    borderhighlight: ['UserLspFloatBorder'],
    borderchars: ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
    border: [1, 1, 1, 1],
    padding: [0, 1, 0, 1],
  })
enddef

export def OnAttachedBuffer(): void
  setlocal omnifunc=lsp#complete

  nmap <buffer> <Leader>ld <Plug>(lsp-definition)
  nmap <buffer> <Leader>lf <Plug>(lsp-document-format)
  nmap <buffer> <Leader>lr <Plug>(lsp-rename)
  nmap <buffer> <Leader>lh <Plug>(lsp-hover)
  nmap <buffer> <Leader>la <Plug>(lsp-code-action)
  vmap <buffer> <Leader>la <Plug>(lsp-code-action)
  nmap <buffer> <Leader>le <Plug>(lsp-document-diagnostics)
  nmap <buffer> <Leader>ln <Plug>(lsp-next-diagnostic)
  nmap <buffer> <Leader>lp <Plug>(lsp-previous-diagnostic)
enddef

export def Setup(): void
  g:lsp_completion_documentation_enabled = 0
  g:lsp_document_code_action_signs_enabled = 0
  g:lsp_document_highlight_enabled = 0
  g:lsp_hover_ui = 'float'

  # Use for debugging
  # g:lsp_log_verbose = 1
  # g:lsp_log_file = expand('~/.cache/vim/vim-lsp.log')

  # Manually register user-defined servers
  RegisterServers()

  # Main setup
  augroup lsp_user_events
    au!
    autocmd User lsp_buffer_enabled call user#lsp#OnAttachedBuffer()
    autocmd ColorScheme * call user#lsp#SetLspBorderHighlights()
    # autocmd User lsp_float_opened call user#lsp#SetLspPopupOptions()
  augroup END
enddef
