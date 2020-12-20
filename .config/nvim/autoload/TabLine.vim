function! TabLine#get_tail(tail)
    if empty(a:tail)
        return ''
    endif

    let l:tail_arr = split(a:tail, '/')
    let l:end_file = tail_arr[len(tail_arr) - 1]
    let l:tag_dir = tail_arr[len(tail_arr) - 2]
    let l:filename = tag_dir . '/' . end_file

    return filename
endfunction

function! TabLine#render() abort
    let l:sep = ""
    let l:bufnums = range(1, bufnr('$'))
    let l:current = bufname()
    let l:result = []

    for i in bufnums
        if bufexists(i) == 1 && buflisted(i) == 1
            " If item first AND current, then separator on right
            " If item middle or end AND current, then separator on left and right
            let l:filename = TabLine#get_tail(bufname(i))
            if current == bufname(i)
                " ain't no way i == 1,
                " cuz first buffer can be any number
                if len(result) == 0
                    call add(result, '%#TabLineSel# ' . filename .
                            \' %#TabLineSelLeftSep#' . sep . '%0*')
                else
                    call add(result, '%#TabLineSelRightSep#' . sep .
                            \'%#TabLineSel# ' . filename .
                            \' %#TabLineSelLeftSep#' . sep . '%0*')
                endif
            else
                call add(result, '%#TabLine# ' . filename . ' %0*')
            endif
        endif
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    call add(result, '%#TabLineFill#')

    return join(result, '')
endfunction
