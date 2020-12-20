function! StatusLine#lsp() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'ALE ' : printf(
        \ 'ALE %d 🔴 %d 🟡 ',
        \ all_errors,
        \ all_non_errors,
    \ )
endfunction

function! StatusLine#mode()
    let l:mode_map = {
        \ '': 'V-BLOCK',
        \ 'R':  'REPLACE',
        \ 'Rv': 'V-REPLACE',
        \ 'V':  'V-LINE',
        \ 'c':  'COMMAND',
        \ 'i':  'INSERT',
        \ 'n':  'NORMAL',
        \ 'v':  'VISUAL',
    \}
    let l:current_mode = mode_map[mode()]

    return printf('%s ', l:current_mode)
endfunction

function! StatusLine#git_branch()
    let l:branch = gitbranch#name()
    return branch == '' ? '' : printf('  %s ', branch)
endfunction

function! StatusLine#filename()
    let l:left_sep_line = ""
    let l:buf = expand('%:t')
    return buf == '' ? '' : printf('%s %s ', left_sep_line, buf)
endfunction

function! StatusLine#render() abort
    let l:left_sep = ""
    let l:right_sep = ""
    let l:statusline = [
        \ '%1* %-{StatusLine#mode()}',
        \ '%7*' . left_sep,
        \ '%2*%-{StatusLine#git_branch()}',
        \ '%-{StatusLine#filename()}',
        \ '%8*' . left_sep . ' ',
        \ '%*%-m %-r',
        \ '%=',
        \ '%y  %l/%L ',
        \ '%9*' . right_sep,
        \ '%3* %{StatusLine#lsp()}%*',
        \]

    return join(statusline, '')
endfunction
