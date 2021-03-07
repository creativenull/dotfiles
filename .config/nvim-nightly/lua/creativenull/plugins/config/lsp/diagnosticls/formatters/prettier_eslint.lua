return {
  command = 'prettier-eslint',
  args = { '--stdin', '--stdin-filepath', '%filepath' },
  rootPatterns = { '.git' }
}
