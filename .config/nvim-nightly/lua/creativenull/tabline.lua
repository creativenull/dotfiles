local HI_TABLINE_SEL = '%#TabLineSel#'
local HI_TABLINE_SEL_LEFT_SEP = '%#TabLineSelLeftSep#'
local HI_TABLINE_SEL_RIGHT_SEP = '%#TabLineSelRightSep#'
local HI_TABLINE_FILL = '%#TabLineFill#'
local HI_TABLINE = '%#TabLine#'
local HI_CLEAR = '%0*'
local M = {}

-- Filename format for the selected buffer
-- If this is the first buffer opened
local function format_buf_selected_first(filename, sep)
  return string.format('%s %s%s %s%s%s',
    HI_TABLINE_SEL,
    '%M',
    filename,
    HI_TABLINE_SEL_RIGHT_SEP,
    sep,
    HI_CLEAR
  )
end

-- Filename format for the selected buffer
-- For all other buffers except the first
local function format_buf_selected(filename, left_sep, right_sep)
  return string.format('%s%s%s %s%s %s%s%s',
    HI_TABLINE_SEL_LEFT_SEP,
    left_sep,
    HI_TABLINE_SEL,
    '%M',
    filename,
    HI_TABLINE_SEL_RIGHT_SEP,
    right_sep,
    HI_CLEAR
  )
end

-- Unselected buffer in the tabline
-- Also adds the switch to buffer on mouse click
local function format_buf(bufnr, filename)
  local bufnr_str = '%' .. bufnr .. '@creativenull#tabline#switch_buf@'
  local end_bufnr = '%T'
  return string.format('%s%s %s %s%s', bufnr_str, HI_TABLINE, filename, end_bufnr, HI_CLEAR)
end

function M.set_highlights()
  local tb_fill_bg = vim.fn.synIDattr(vim.fn.hlID('TabLineFill'), 'bg#')
  local tb_fill_fg = vim.fn.synIDattr(vim.fn.hlID('TabLineFill'), 'fg#')
  local tb_sel_bg = vim.fn.synIDattr(vim.fn.hlID('TabLineSel'), 'bg#')
  local tb_sel_fg = vim.fn.synIDattr(vim.fn.hlID('TabLineSel'), 'fg#')

  vim.cmd(string.format('hi TabLineSelLeftSep guifg=%s guibg=%s', tb_fill_bg, tb_sel_bg))
  vim.cmd(string.format('hi TabLineSelRightSep guifg=%s guibg=%s', tb_sel_bg, tb_fill_bg))
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
  -- local sep = ""
  local buffers = vim.fn.bufnr('$')
  local current = vim.fn.bufname()
  local filename = ''
  local bufferline = {}

  for i = 1, buffers do
    if vim.fn.bufexists(i) == 1 and vim.fn.buflisted(i) == 1 then
      -- If item first AND current, then separator on right
      -- If item middle or end AND current, then separator on left and right
      filename = get_tail(vim.fn.bufname(i))
      if current == vim.fn.bufname(i) then
        -- ain't no way i == 1,
        -- cuz first buffer can be any number :(
        if table.maxn(bufferline) == 0 then
          table.insert(bufferline, format_buf_selected_first(filename, sep))
        else
          table.insert(bufferline, format_buf_selected(filename, sep, sep))
        end
      else
        table.insert(bufferline, format_buf(i, filename))
      end
    end
  end

  -- TODO
  -- Find out a way to truncate the tabline, if there are too many
  -- buffers open. Show only the highlighted on

  -- after the last tab fill with TabLineFill and reset tab page nr
  table.insert(bufferline, HI_TABLINE_FILL)

  return table.concat(bufferline, '')
end

function M.get_tabline()
  return [[%!luaeval("require'creativenull.tabline'.render()")]]
end

return M
