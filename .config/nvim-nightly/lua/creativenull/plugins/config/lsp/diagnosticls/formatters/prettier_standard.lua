local prettier_standard = {
    command = 'prettier-standard',
    args = { '--stdin', '--stdin-filepath', '%filepath' },
    rootPatterns = {
        'package.json',
        '.prettierignore'
    }
}

return prettier_standard
