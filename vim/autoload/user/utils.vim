vim9script

# Strip sign column, number line, etc to be able
# to copy and paste from a vim instance that has
# mouse disabled, or not able to use `"+y`.
#
# Example of such and instance is running vim in WSL2
export def ToggleCodeshot(): void
  if &number
    setlocal nonumber signcolumn=no
    execute ':IndentLinesDisable'
  else
    setlocal number signcolumn=yes
    execute ':IndentLinesEnable'
  endif
enddef

# Toggle the conceallevel, should any syntax plugin overtake
# and hide/conceal words
export def ToggleConcealLevel(): void
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
enddef

# Check if the vim instance is running on a WSL vm
# Ref: https://github.com/neovim/neovim/issues/12642#issuecomment-658944841
export def IsWSL(): bool
  const proc_version = '/proc/version'

  if !filereadable(proc_version)
    return false
  endif

  const procFile = readfile(proc_version, '', 1)
  return !procFile->filter((_, val) => val =~? 'microsoft')->empty()
enddef

# Indent rules given to a filetype, use spaces if needed
export def IndentSize(size: number, useSpaces: bool = false): void
  execute printf('setlocal tabstop=%d softtabstop=%d shiftwidth=0', size, size)

  if useSpaces
    setlocal expandtab
  else
    setlocal noexpandtab
  endif
enddef
