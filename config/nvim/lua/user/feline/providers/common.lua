local M = {}

function M.is_not_empty_buffer()
  return vim.fn.expand('%:t') ~= ''
end

function M.is_empty_buffer()
  return vim.fn.expand('%:t') == ''
end

function M.filename_provider(_, opts)
  local modified_icon = ' 󰲶'
  if opts.modified_icon then
    modified_icon = opts.modified_icon
  end

  local readonly_icon = ' 󰌾'
  if opts.readonly_icon then
    readonly_icon = opts.readonly_icon
  end

  local buf = vim.api.nvim_get_current_buf()
  local modified = vim.bo[buf].modified and modified_icon or ''
  local readonly = vim.bo[buf].readonly and readonly_icon or ''
  local nerdfont = vim.call('nerdfont#find')
  local filename = vim.fn.expand('%:t')

  return string.format(' %s %s%s%s ', nerdfont, filename, modified, readonly)
end

return M
