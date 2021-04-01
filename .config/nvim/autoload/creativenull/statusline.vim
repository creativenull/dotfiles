" Name: Arnold Chand
" Github: https://github.com/creativenull
" Statusline Functions
" =============================================================================

" Color Vars
let s:text_color_black = '#1C1B19'
let s:text_color_white = '#D0BFA1'
let s:cursor_colors = {
    \ 'normal':  { 'bg': '#519F50', 'fg': s:text_color_black, 'hl': 'StatusLineCursorNormal' },
    \ 'insert':  { 'bg': '#EF2F27', 'fg': s:text_color_white, 'hl': 'StatusLineCursorInsert' },
    \ 'visual':  { 'bg': '#FBB829', 'fg': s:text_color_black, 'hl': 'StatusLineCursorVisual' },
    \ 'replace': { 'bg': '#FBB829', 'fg': s:text_color_black, 'hl': 'StatusLineCursorReplace' },
    \ 'command': { 'bg': '#2C78BF', 'fg': s:text_color_white, 'hl': 'StatusLineCursorCommand' },
\ }

function! s:cursor_mode() abort
    if mode() == 'n'
        return '%#'. s:cursor_colors.normal.hl .'# NORMAL %*'
    elseif mode() == 'i'
        return '%#'. s:cursor_colors.insert.hl .'# INSERT %*'
    elseif mode() == 'c'
        return '%#'. s:cursor_colors.command.hl .'# COMMAND %*'
    elseif mode() == 'v' || mode() == 'V' || mode() == ''
        return '%#'. s:cursor_colors.visual.hl .'# VISUAL %*'
    elseif mode() == 'R' || mode() == 'Rv' || mode() == 'Rx'
        return '%#'. s:cursor_colors.replace.hl .'# REPLACE %*'
    endif

    return ':('
endfunction

function! s:git_branch()
    if exists('g:loaded_gitbranch')
        return gitbranch#name() == '' ? '' : printf('%s', gitbranch#name())
    endif

    return ':('
endfunction

function! s:filename()
    return expand('%:t')
endfunction

function! s:lsp_statusline() abort
    let l:lsp_hl = '%#StatusLineLSP#'
    if exists('g:loaded_ale')
        let l:counts = ale#statusline#Count(bufnr(''))
        let l:all_errors = counts.error + counts.style_error
        let l:all_non_errors = counts.total - all_errors
        return counts.total == 0 ? lsp_hl . ' ALE ' : printf(
            \ '%s ALE %d 🔴 %d 🟡 ',
            \ lsp_hl,
            \ all_errors,
            \ all_non_errors,
        \ )
    endif

    return lsp_hl . ' :( '
endfunction

function! creativenull#statusline#highlights()
    " Cursor Mode
    exe printf('hi! %s guibg=%s guifg=%s',
        \ s:cursor_colors.normal.hl, s:cursor_colors.normal.bg, s:cursor_colors.normal.fg)
    exe printf('hi! %s guibg=%s guifg=%s',
        \ s:cursor_colors.insert.hl, s:cursor_colors.insert.bg, s:cursor_colors.insert.fg)
    exe printf('hi! %s guibg=%s guifg=%s',
        \ s:cursor_colors.visual.hl, s:cursor_colors.visual.bg, s:cursor_colors.visual.fg)
    exe printf('hi! %s guibg=%s guifg=%s',
        \ s:cursor_colors.replace.hl, s:cursor_colors.replace.bg, s:cursor_colors.replace.fg)
    exe printf('hi! %s guibg=%s guifg=%s',
        \ s:cursor_colors.command.hl, s:cursor_colors.command.bg, s:cursor_colors.command.fg)

    " Filename
    hi! StatusLineFilename guifg=#0AAEB3

    " LSP
    hi! StatusLineLSP guibg=#53FDE9 guifg=#1C1B19

    " Not current window
    hi! StatusLineNC gui=underline
endfunction

function! creativenull#statusline#render() abort
    return s:cursor_mode() .
        \ ' ' . s:git_branch() .
        \ ' ' . s:filename() .
        \ ' %m %=%l/%L:%c ' .
        \ s:lsp_statusline()
endfunction
