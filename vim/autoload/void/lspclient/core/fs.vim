vim9script

# Handle converstions between filesystem and the LSP fs protocol

# Convert filepath to URI
export def FileToUri(filepath: string): string
  return printf('file://%s', filepath)
enddef

# Get the project root directory as URI
export def GetProjectRootUri(): string
  return FileToUri(getcwd())
enddef

# Get the current file as URI
export def GetCurrentFileUri(): string
  return FileToUri(expand('%'))
enddef

# Get the file contents from filesystem
export def GetFileContents(filepath: string): string
  return filepath->readfile()->join("\n")
enddef

export def GetBufferContents(buf: number): string
  return buf->getbufline(1, '$')->join("\n")
enddef
