local standard = {
  sourceName = 'standard',
  command = 'standard',
  debounce = 100,
  args = { '--stdin' },
  offsetLine = 0,
  offsetColumn = 0,
  formatLines = 1,
  formatPattern = {
    [[^\s*<\w+>:(\d+):(\d+):\s+(.*)(\r|\n)*$]],
    {
      line = 1,
      column = 2,
      message = 3
    }
  },
  rootPatterns = { '.git', '.gitignore' }
}

return standard
