" Name: Arnold Chand
" Github: https://github.com/creativenull
" Statusline Functions
" =============================================================================

" Color Vars
let s:text_color_black = '#1C1B19'
let s:text_color_white = '#D0BFA1'
let s:cursor_colors = {
    \ 'normal':  { 'bg': '#519F50', 'fg': s:text_color_black },
    \ 'insert':  { 'bg': '#EF2F27', 'fg': s:text_color_white },
    \ 'visual':  { 'bg': '#FBB829', 'fg': s:text_color_black },
    \ 'replace': { 'bg': '#FBB829', 'fg': s:text_color_black },
    \ 'command': { 'bg': '#2C78BF', 'fg': s:text_color_white },
\ }

function! s:cursor_mode() abort
    if mode() == 'n'
        return '%#StatusLineCursorNormal# NORMAL %*'
    elseif mode() == 'i'
        return '%#StatusLineCursorInsert# INSERT %*'
    elseif mode() == 'c'
        return '%#StatusLineCursorCommand# COMMAND %*'
    elseif mode() == 'v' || mode() == 'V' || mode() == ''
        return '%#StatusLineCursorVisual# VISUAL %*'
    elseif mode() == 'R' || mode() == 'Rv' || mode() == 'Rx'
        return '%#StatusLineCursorReplace# REPLACE %*'
    endif
endfunction

function! s:git_branch()
    return gitbranch#name() == '' ? '' : printf('%s', gitbranch#name())
endfunction

function! s:filename()
    return expand('%:t')
endfunction

function! s:lsp_statusline() abort
    if exists('g:loaded_ale')
        let l:lsp_hl = '%#StatusLineLSP#'
        let l:counts = ale#statusline#Count(bufnr(''))
        let l:all_errors = l:counts.error + l:counts.style_error
        let l:all_non_errors = l:counts.total - l:all_errors
        return l:counts.total == 0 ? lsp_hl . ' ALE ' : printf(
            \ '%s ALE %d 🔴 %d 🟡 ',
            \ lsp_hl,
            \ all_errors,
            \ all_non_errors,
        \ )
    endif

    return lsp_hl . ' NONE '
endfunction

function! creativenull#statusline#highlights()
    " Cursor Mode
    exe printf('hi! StatusLineCursorNormal  guibg=%s guifg=%s', s:cursor_colors.normal.bg, s:cursor_colors.normal.fg)
    exe printf('hi! StatusLineCursorInsert  guibg=%s guifg=%s', s:cursor_colors.insert.bg, s:cursor_colors.insert.fg)
    exe printf('hi! StatusLineCursorVisual  guibg=%s guifg=%s', s:cursor_colors.visual.bg, s:cursor_colors.visual.fg)
    exe printf('hi! StatusLineCursorReplace guibg=%s guifg=%s', s:cursor_colors.replace.bg, s:cursor_colors.replace.fg)
    exe printf('hi! StatusLineCursorCommand guibg=%s guifg=%s', s:cursor_colors.command.bg, s:cursor_colors.command.fg)

    " Filename
    hi! StatusLineFilename guifg=#0AAEB3

    " LSP
    hi! StatusLineLSP guibg=#53FDE9 guifg=#1C1B19
endfunction

function! creativenull#statusline#render() abort
    return s:cursor_mode() .
        \ ' ' . s:git_branch() .
        \ ' ' . s:filename() .
        \ ' %m %=%l/%L:%c ' .
        \ s:lsp_statusline()
endfunction
