local ts_standard_fixer = {
  command = 'ts-standard',
  args = { '--fix', '--stdin', '--stdin-filename', '%filepath' },
  rootPatterns = { '.git', '.gitignore' }
}

return ts_standard_fixer
