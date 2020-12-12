local xo = {
    sourceName = 'xo',
    command = 'xo',
    debounce = 100,
    args = {
        '--reporter',
        'json',
        '--stdin',
        '--stdin-filename',
        '%filepath',
    },
    parseJson = {
        errorsRoot = '[0].messages',
        line = 'line',
        column = 'column',
        endLine = 'endLine',
        endColumn = 'endColumn',
        message = '${message} [${ruleId}]',
        security = 'severity',
    },
    securities = {
        [2] = 'error',
        [1] = 'warning'
    },
    rootPatterns = {
        'package.json',
    },
}

return xo
