return {
  command = 'ts-standard',
  args = { '--fix', '--stdin', '--stdin-filename', '%filepath' },
  rootPatterns = { '.git' }
}
