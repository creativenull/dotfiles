local M = {}

local HI_TABLINE_SEL = '%#TabLineSel#'
local HI_TABLINE_SEL_LEFT_SEP = '%#TabLineSelLeftSep#'
local HI_TABLINE_SEL_RIGHT_SEP = '%#TabLineSelRightSep#'
local HI_TABLINE_FILL = '%#TabLineFill#'
local HI_TABLINE = '%#TabLine#'
local HI_CLEAR = '%0*'

local function format_buf_selected_first(filename, sep)
    return string.format('%s %s %s%s%s',
        HI_TABLINE_SEL,
        filename,
        HI_TABLINE_SEL_LEFT_SEP,
        sep,
        HI_CLEAR
    )
end

local function format_buf_selected(filename, left_sep, right_sep)
    return string.format('%s%s%s %s %s%s%s',
        HI_TABLINE_SEL_RIGHT_SEP,
        left_sep,
        HI_TABLINE_SEL,
        filename,
        HI_TABLINE_SEL_LEFT_SEP,
        right_sep,
        HI_CLEAR
    )
end

local function format_buf(filename)
    return string.format('%s %s %s', HI_TABLINE, filename, HI_CLEAR)
end

function M.set_highlights()
    local tb_fill_bg = vim.fn.synIDattr(vim.fn.hlID('TabLineFill'), 'bg#')
    local tb_fill_fg = vim.fn.synIDattr(vim.fn.hlID('TabLineFill'), 'fg#')
    local text_color = '#1d2021'
    local blue = '#458588'

    vim.cmd(string.format('hi TabLine gui=NONE guifg=%s guibg=%s', tb_fill_fg, tb_fill_bg))
    vim.cmd(string.format('hi TabLineSel guifg=%s guibg=%s', text_color, blue))
    vim.cmd(string.format('hi TabLineSelLeftSep guifg=%s guibg=%s', blue, tb_fill_bg))
    vim.cmd(string.format('hi TabLineSelRightSep gui=reverse guifg=%s guibg=%s', blue, tb_fill_bg))
end

local function get_tail(tail)
    if tail == '' or tail == nil then return '' end

    local tail_arr = vim.fn.split(tail, '/')
    local file = tail_arr[#tail_arr]
    local dir = tail_arr[#tail_arr - 1]

    if dir == nil then return string.format('%s', file) end

    return string.format('%s/%s', dir, file)
end

function M.render()
    local sep = ""
    local buffers = vim.fn.bufnr('$')
    local current = vim.fn.bufname()
    local filename = ''
    local tabline = {}

    for i = 1, buffers do
        if vim.fn.bufexists(i) == 1 and vim.fn.buflisted(i) == 1 then
            -- If item first AND current, then separator on right
            -- If item middle or end AND current, then separator on left and right
            filename = get_tail(vim.fn.bufname(i))
            if current == vim.fn.bufname(i) then
                -- ain't no way i == 1,
                -- cuz first buffer can be any number :(
                if table.maxn(tabline) == 0 then
                    table.insert(tabline, format_buf_selected_first(filename, sep))
                else
                    table.insert(tabline, format_buf_selected(filename, sep, sep))
                end
            else
                table.insert(tabline, format_buf(filename))
            end
        end
    end

    -- after the last tab fill with TabLineFill and reset tab page nr
    table.insert(tabline, HI_TABLINE_FILL)

    return table.concat(tabline, '')
end

return M
