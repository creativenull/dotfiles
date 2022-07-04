vim9script

# JS/TS
const tsserver = 'typescript-language-server'
const tsserverOpts = {
  name: tsserver,
  cmd: [tsserver, '--stdio'],
  allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
}

const denols = 'deno'
const denolsOpts = {
  name: denols,
  cmd: [denols, 'lsp'],
  workspace_config: { deno: { enable: true, lint: true } },
  allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
}

# Vue
const vuels = 'vue-language-server'
const vuelsOpts = {
  name: vuels,
  cmd: [vuels, '--stdio'],
  allowlist: ['vue'],
}

# Go
const gopls = 'gopls'
const goplsOpts = {
  name: gopls,
  cmd: [gopls],
  allowlist: ['go'],
}

# PHP
const phpls = 'intelephense'
const phplsOpts = {
  name: phpls,
  cmd: [phpls, '--stdio'],
  allowlist: ['php'],
}

# Register LSP servers assuming they are installed in the system
# within a custom user autocmd group.
def RegisterServers(): void
  augroup user_lsp_events

  # JS/TS
  if executable(tsserver) && filereadable(getcwd() .. '/package.json')
    autocmd user_lsp_events User lsp_setup call lsp#register_server(tsserverOpts->copy())
  endif

  if executable(denols) && filereadable(getcwd() .. '/deno.json') || filereadable(getcwd() .. '/deno.jsonc')
    autocmd user_lsp_events User lsp_setup call lsp#register_server(denolsOpts->copy())
  endif

  # Vue
  if executable(vuels)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(vuelsOpts->copy())
  endif

  # Go
  if executable(gopls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(goplsOpts->copy())
  endif

  # PHP
  if executable(phpls)
    autocmd user_lsp_events User lsp_setup call lsp#register_server(phplsOpts->copy())
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
