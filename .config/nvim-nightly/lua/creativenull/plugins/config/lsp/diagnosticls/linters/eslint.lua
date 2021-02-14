local eslint = {
    sourceName = 'eslint',
    command = 'eslint',
    debounce = 100,
    args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
    parseJson = {
        errorsRoot = '[0].messages',
        line = 'line',
        column = 'column',
        endLine = 'endLine',
        endColumn = 'endColumn',
        message = '${message} [${ruleId}]',
        security = 'severity'
    },
    securities = {
        [2] = 'error',
        [1] = 'warning'
    },
    rootPatterns = {
        'package.json',
        '.eslintrc',
        '.eslintrc.cjs',
        '.eslintrc.js',
        '.eslintrc.json',
        '.eslintrc.yaml',
        '.eslintrc.yml'
    }
}

return eslint
