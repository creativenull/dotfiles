vim9script

const lsp_servers = [
  {
    name: 'typescript-language-server',
    cmd: ['typescript-language-server', '--stdio'],
    allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
    condition: filereadable(getcwd() .. '/package.json') || 1,
  },
  {
    name: 'deno',
    cmd: ['deno', 'lsp'],
    workspace_config: { deno: { enable: true, lint: true } },
    allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
    condition: filereadable(getcwd() .. '/deno.json') || filereadable(getcwd() .. '/deno.jsonc'),
  },
  {
    name: 'vue-language-server',
    cmd: ['vue-language-server', '--stdio'],
    allowlist: ['vue'],
  },
  {
    name: 'intelephense',
    cmd: ['intelephense', '--stdio'],
    allowlist: ['php'],
  },
]

# Register LSP servers assuming they are installed in the system
# within a custom user autocmd group.
def RegisterServers(): void
  augroup UserLspRegisterGroup

  for lsp_server in lsp_servers
    if executable(lsp_server.name)
      if has_key(lsp_server, 'condition')
        if lsp_server.condition
          execute printf("autocmd UserLspRegisterGroup User lsp_setup call lsp#register_server(%s)", string(lsp_server))
        endif

        continue
      endif

      execute printf("autocmd UserLspRegisterGroup User lsp_setup call lsp#register_server(%s)", string(lsp_server))
    endif
  endfor
enddef

export def SetLspBorderHighlights(): void
  highlight UserLspFloatBorder guibg=NONE guifg=#eeeeee
  highlight UserLspFloat guibg=NONE
enddef

export def SetLspPopupOptions(): void
  popup_setoptions(lsp#document_hover_preview_winid(), {
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
  augroup UserLspSetupGroup
    au!
    autocmd User lsp_buffer_enabled call OnAttachedBuffer()
    autocmd ColorScheme * call SetLspBorderHighlights()
    autocmd User lsp_float_opened call SetLspPopupOptions()
  augroup END
enddef
