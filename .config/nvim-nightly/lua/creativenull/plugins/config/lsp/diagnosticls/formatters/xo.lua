local xo = {
    command = 'xo',
    args = { '--stdin', '--stdin-filename', '%filepath', '--fix' },
    rootPatterns = { 'package.json' }
}

return xo
