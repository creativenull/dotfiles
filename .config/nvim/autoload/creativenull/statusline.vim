" Statusline functions
" ====================
function! s:cursor_mode()
    let l:mode_map = {
        \ '': 'VB',
        \ 'R':  'R',
        \ 'Rv': 'VR',
        \ 'V':  'VL',
        \ 'c':  'C',
        \ 'i':  'I',
        \ 'n':  'N',
        \ 'v':  'V',
    \ }
    let l:current_mode = mode_map[mode()]

    return printf('%s ', l:current_mode)
endfunction

function! s:git_branch()
    let l:branch = gitbranch#name()
    return branch == '' ? '' : printf('  %s ', branch)
endfunction

function! s:filename()
    let l:left_sep_line = ''
    let l:buf = expand('%:t')
    return buf == '' ? '' : printf('%s %s ', left_sep_line, buf)
endfunction

function! s:lsp() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'ALE ' : printf(
        \ 'ALE %d 🔴 %d 🟡 ',
        \ all_errors,
        \ all_non_errors,
    \ )
endfunction

function! creativenull#statusline#set_hl() abort
    let l:st_bg = synIDattr(hlID('StatusLine'), 'bg')
    let l:is_reverse = synIDattr(hlID('StatusLine'), 'reverse', 'gui')
    if is_reverse == 1
        let l:st_bg = synIDattr(hlID('StatusLine'), 'fg')
    endif

    let l:text_color = '#1d2021'
    let l:blue = '#458588'
    let l:aqua = '#689d6a'
    let l:purple = '#b16286'

    let l:cursor_bg = blue
    let l:filename_git_bg = aqua
    let l:lsp_bg = purple
    let l:cursor_filename_sep_fg = blue
    let l:cursor_filename_sep_bg = aqua
    let l:filename_st_fg = aqua
    let l:filename_st_bg = st_bg
    let l:lsp_st_fg = purple
    let l:lsp_st_bg = st_bg

    " CursorMode
    execute printf('hi User1 guifg=%s guibg=%s', text_color, cursor_bg)
    " Git,Filename
    execute printf('hi User2 guifg=%s guibg=%s', text_color, filename_git_bg)
    " LSPStatus
    execute printf('hi User3 guifg=%s guibg=%s', text_color, lsp_bg)

    " Seperators
    " bluefg -> aquabg
    execute printf('hi User7 guifg=%s guibg=%s', cursor_filename_sep_fg, cursor_filename_sep_bg)
    " aquafg -> statuslinebg
    execute printf('hi User8 guifg=%s guibg=%s', filename_st_fg, filename_st_bg)
    " statuslinebg -> purplefg
    execute printf('hi User9 guifg=%s guibg=%s', lsp_st_fg, lsp_st_bg)
endfunction

function! creativenull#statusline#render() abort
    let l:left_sep = ''
    let l:right_sep = ''
                "\ '%3* ' . <SID>lsp() . '%*',
    let l:statusline = [
        \ '%1* ' . <SID>cursor_mode(),
        \ '%7*' . left_sep,
        \ '%2*' . <SID>git_branch(),
        \ <SID>filename(),
        \ '%8*' . left_sep . ' ',
        \ '%*%-m %-r',
        \ '%=',
        \ '  %l/%L ',
        \ '%9*' . right_sep,
    \ ]

    return join(statusline, '')
endfunction
