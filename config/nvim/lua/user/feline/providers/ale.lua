local lsp = require('user.feline.providers.lsp')
local M = {}

function M.has_ale_linters()
  return vim.fn.exists('b:ale_linters') == 1
end

function M.has_ale_fixers()
  return vim.fn.exists('b:ale_fixers') == 1
end

M.status_provider = function(component, opts)
  if component.enabled == nil then
    component.enabled = function()
      return M.has_ale_linters() or M.has_ale_fixers()
    end
  end

  local linter_icon = ' 󰓠'
  if opts.linter_icon then
    linter_icon = ' ' .. opts.linter_icon
  end

  local fixer_icon = ' 󱌢'
  if opts.fixer_icon then
    fixer_icon = ' ' .. opts.fixer_icon
  end

  local text = 'ALE'
  if opts.text then
    text = opts.text
  end

  local linter_attached_icon = M.has_ale_linters() and linter_icon or ''
  local fixer_attached_icon = M.has_ale_fixers() and fixer_icon or ''

  return string.format(' %s%s%s ', text, linter_attached_icon, fixer_attached_icon)
end

function M.diagnostic_error_provider(component)
  local key = 'error'
  if component.enabled == nil then
    component.enabled = function()
      return lsp.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  if vim.g.ale_use_neovim_diagnostics_api then
    return string.format(' %s%s ', icon, lsp.get_diagnostic_count(key))
  else
    local diagnostic = vim.call('ale#statusline#Count', vim.api.nvim_get_current_buf())
    return string.format(' %s ', icon, diagnostic[key] or 0)
  end
end

function M.diagnostic_warning_provider(component)
  local key = 'warning'
  if component.enabled == nil then
    component.enabled = function()
      return lsp.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  if vim.g.ale_use_neovim_diagnostics_api then
    return string.format(' %s%s ', icon, lsp.get_diagnostic_count(key))
  else
    local diagnostic = vim.call('ale#statusline#Count', vim.api.nvim_get_current_buf())
    return string.format(' %s ', icon, diagnostic[key] or 0)
  end
end

function M.diagnostic_info_provider(component)
  local key = 'info'
  if component.enabled == nil then
    component.enabled = function()
      return lsp.get_diagnostic_count(key) > 0
    end
  end

  local icon = ''
  if component.icon then
    icon = component.icon
  end

  if vim.g.ale_use_neovim_diagnostics_api then
    return string.format(' %s%s ', icon, lsp.get_diagnostic_count(key))
  else
    local diagnostic = vim.call('ale#statusline#Count', vim.api.nvim_get_current_buf())
    return string.format(' %s ', icon, diagnostic[key] or 0)
  end
end

return M
