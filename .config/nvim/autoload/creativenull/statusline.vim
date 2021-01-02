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
    \}
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

function! creativenull#statusline#render() abort
    let l:left_sep = ''
    let l:right_sep = ''
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
        \ '%3* ' . <SID>lsp() . '%*',
        \]

    return join(statusline, '')
endfunction
