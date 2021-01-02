function! s:get_tail(tail)
    if empty(a:tail)
        return ''
    endif

    let l:tail_arr = split(a:tail, '/')
    let l:end_file = tail_arr[len(tail_arr) - 1]
    let l:tag_dir = tail_arr[len(tail_arr) - 2]
    let l:filename = tag_dir . '/' . end_file

    return filename
endfunction

function! creativenull#tabline#switch_buf(minwid, clicks, btn, modifiers) abort
    execute 'buffer ' . a:minwid
endfunction

function! creativenull#tabline#render() abort
    let l:sep = ''
    let l:bufnums = range(1, bufnr('$'))
    let l:current = bufname()
    let l:result = []

    for i in bufnums
        if bufexists(i) == 1 && buflisted(i) == 1
            " If item first AND current, then separator on right
            " If item middle or end AND current, then separator on left and right
            let l:filename = <SID>get_tail(bufname(i))
            if current == bufname(i)
                " ain't no way i == 1,
                " cuz first buffer can be any number
                if len(result) == 0
                    call add(result, '%#TabLineSel# %M' . filename .
                            \' %#TabLineSelLeftSep#' . sep . '%0*')
                else
                    call add(result, '%#TabLineSelRightSep#' . sep .
                            \'%#TabLineSel# %M' . filename .
                            \' %#TabLineSelLeftSep#' . sep . '%0*')
                endif
            else
                call add(result, '%' . i . '@creativenull#tabline#switch_buf@' . '%#TabLine# ' . filename . ' %T%0*')
            endif
        endif
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    call add(result, '%#TabLineFill#')

    let l:tablinelist = join(result, '')

    return tablinelist
endfunction
