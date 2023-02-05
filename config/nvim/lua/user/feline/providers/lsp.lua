local M = {}

function M.get_diagnostic_count(attr)
  local buf = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(buf)
  local items = {}

  if attr == 'error' then
    items = vim.tbl_filter(function(item)
      return item.severity == vim.diagnostic.severity.ERROR
    end, diagnostics)
  elseif attr == 'warn' or attr == 'warning' then
    items = vim.tbl_filter(function(item)
      return item.severity == vim.diagnostic.severity.WARN
    end, diagnostics)
  elseif attr == 'info' then
    items = vim.tbl_filter(function(item)
      return item.severity == vim.diagnostic.severity.INFO or item.severity == vim.diagnostic.severity.HINT
    end, diagnostics)
  end

  return #items
end

function M.diagnostic_error_provider(component)
  local key = 'error'
  if component.enabled == nil then
    component.enabled = function()
      return M.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  return string.format(' %s%s ', icon, M.get_diagnostic_count(key))
end

function M.diagnostic_warning_provider(component)
  local key = 'warning'
  if component.enabled == nil then
    component.enabled = function()
      return M.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  return string.format(' %s%s ', icon, M.get_diagnostic_count(key))
end

function M.diagnostic_info_provider(component)
  local key = 'info'
  if component.enabled == nil then
    component.enabled = function()
      return M.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  return string.format(' %s%s ', icon, M.get_diagnostic_count(key))
end

return M
