local xo = {
    command = 'xo',
    args = { '--fix', '--stdin', '--stdin-filename', '%filepath' },
    rootPatterns = { 'package.json' }
}

return xo
