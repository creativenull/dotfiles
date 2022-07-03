vim9script

# Push from git repo, notify user since this is async
def GinPushOrign(): void
  const cmd = printf('Gin push origin %s', gitbranch#name())

  execute printf('echo "%s"', cmd)
  execute cmd
enddef

# Pull from git repo, notify user since this is async
def GinPullOrigin(): void
  const cmd = printf('Gin pull origin %s', gitbranch#name())

  execute printf('echo "%s"', cmd)
  execute cmd
enddef

export def Setup(): void
  nnoremap <Leader>gs <Cmd>GinStatus<CR>
  nnoremap <Leader>gp <ScriptCmd>GinPushOrign()<CR>
  nnoremap <Leader>gpp :Gin push origin 
  nnoremap <Leader>gl <ScriptCmd>GinPullOrigin()<CR>
  nnoremap <Leader>gll :Gin pull origin 
  nnoremap <Leader>gb <Cmd>GinBranch<CR>
  nnoremap <Leader>gc <Cmd>Gin commit<CR>
enddef
