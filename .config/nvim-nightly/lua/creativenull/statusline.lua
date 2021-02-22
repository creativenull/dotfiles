local lsp_status = require 'lsp-status'
local M = {}

local function set_cursor_mode_hi(fg, bg)
  local left_bg = '#3A3A3A'
  local cursor_mode_hi = string.format('hi! StatusLineCursorMode guifg=%s guibg=%s', fg, bg)
  local cursor_mode_sep_hi = string.format('hi! StatusLineCursorModeSep guifg=%s guibg=%s', bg, left_bg)

  vim.cmd(cursor_mode_hi)
  vim.cmd(cursor_mode_sep_hi)
end

local function cursor_mode()
  local mode_map = {
    ['n']  = 'N',
    ['v']  = 'V',
    ['V']  = 'V',
    [''] = 'V',
    ['i']  = 'I',
    ['ic'] = 'I',
    ['ix'] = 'I',
    ['R']  = 'R',
    ['Rv'] = 'R',
    ['c']  = 'C',
  }

  local mode_colors = {
    ['N']  = { fg = '#FCE8C3', bg = '#585858' },
    ['V']  = { fg = '#262626', bg = '#FBB829' },
    ['I']  = { fg = '#FCE8C3', bg = '#EF2F27' },
    ['R'] = { fg = '#FCE8C3', bg = '#EF2F27' },
    ['C'] = { fg = '#FCE8C3', bg = '#2C78BF' },
  }

  local m = vim.api.nvim_get_mode()
  local current_mode = mode_map[m.mode]
  local current_mode_color = mode_colors[current_mode]
  local seperator = ''
  local cursor_mode_hi = '%#StatusLineCursorMode#'
  local cursor_mode_sep_hi = '%#StatusLineCursorModeSep#'

  set_cursor_mode_hi(current_mode_color.fg, current_mode_color.bg)
  return string.format('%s %s %s%s%s', cursor_mode_hi, current_mode, cursor_mode_sep_hi, seperator, '%*')
end

local function set_git_branch_hi(fg, bg)
  local git_branch_hi = string.format('hi! StatusLineGitBranch guifg=%s guibg=%s', fg, bg)
  local git_branch_sep_hi = string.format('hi! StatusLineGitBranchSep guifg=%s guibg=%s', bg, '#585858')

  vim.cmd(git_branch_hi)
  vim.cmd(git_branch_sep_hi)
end

-- Get the current git branch
-- inspired from github.com/galaxyline/provider_vcs.lua
local function git_branch()
  local git_branch_hi = '%#StatusLineGitBranch#'
  local git_branch_sep_hi = '%#StatusLineGitBranchSep#'
  local separator = ''

  set_git_branch_hi('#FCE8C3', '#3A3A3A')

  local fp = io.open(vim.fn.getcwd() .. '/.git/HEAD')
  if fp == nil then
    return string.format('%s %s%s%s', git_branch_hi, git_branch_sep_hi, separator, '%*')
  end

  local head = fp:read()
  fp:close()

  local branch = head:match('ref: refs/heads/(.+)')
  if branch == '' then
    return string.format('%s %s%s%s', git_branch_hi, git_branch_sep_hi, separator, '%*')
  end

  return string.format('%s  %s %s%s%s', git_branch_hi, branch, git_branch_sep_hi, separator, '%*')
end

local function set_filename_hi(fg, bg)
  local statusline_bg = vim.fn.synIDattr(vim.fn.hlID('StatusLine'), 'bg#')
  local filename_hi = string.format('hi! StatusLineFilename guifg=%s guibg=%s', fg, bg)
  local filename_sep_hi = string.format('hi! StatusLineFilenameSep guifg=%s guibg=%s', bg, statusline_bg)

  vim.cmd(filename_hi)
  vim.cmd(filename_sep_hi)
end

local function filename()
  local separator = ''
  local filename_hi = '%#StatusLineFilename#'
  local filename_sep_hi = '%#StatusLineFilenameSep#'
  local bufname = vim.fn.expand('%:t')

  set_filename_hi('#FCE8C3', '#585858')
  if bufname == '' then
    return string.format('%s %s%s%s', filename_hi, filename_sep_hi, separator, '%*')
  end

  return string.format('%s %s %s%s%s', filename_hi, bufname, filename_sep_hi, separator, '%*')
end

local function set_lsp_hi(fg, bg)
  local statusline_bg = vim.fn.synIDattr(vim.fn.hlID('StatusLine'), 'bg#')
  local lsp_hi = string.format('hi! StatusLineLsp guifg=%s guibg=%s', fg, bg)
  local lsp_sep_hi = string.format('hi! StatusLineLspSep guifg=%s guibg=%s', bg, statusline_bg)

  vim.cmd(lsp_hi)
  vim.cmd(lsp_sep_hi)
end

local function lsp()
  local lsp_hi = '%#StatusLineLsp#'
  local lsp_sep_hi = '%#StatusLineLspSep#'
  local separator = ""
  local lsp_status_sep = string.format('%s%s%s', lsp_sep_hi, separator, lsp_hi)
  local diagnostics = lsp_status.diagnostics()

  if diagnostics.errors > 0 or diagnostics.warnings > 0 then
    set_lsp_hi('#121212', '#FF5C8F')
    return string.format('%s LSP %d 🔴 %d 🟡 ', lsp_status_sep, diagnostics.errors, diagnostics.warnings)
  else
    set_lsp_hi('#121212', '#519F50')
    return string.format('%s LSP ', lsp_status_sep)
  end
end

function M.set_highlights()
  local statusline_hi = string.format('hi! StatusLine guifg=%s guibg=%s', '#FCE8C3', '#262626')
  local statusline_nc_hi = string.format('hi! StatusLineNC gui=NONE guifg=%s guibg=%s', '#FCE8C3', '#121212')

  vim.cmd(statusline_hi)
  vim.cmd(statusline_nc_hi)
end

-- Render the statusline
function M.render()
  -- Feeling Hacky? Use this
  -- local left_sep = vim.fn.eval([[printf("\uE0B8")]])
  -- local right_sep = vim.fn.eval([[printf("\uE0BA")]])
  local status = ''

  -- left side
  status = status .. '%*'
  status = status .. cursor_mode()
  status = status .. git_branch()
  status = status .. filename()
  status = status .. '%* %-m %-r'

  -- right side
  status = status .. '%='
  status = status .. ' %l/%L '
  status = status .. lsp() .. '%*'

  return status
end

function M.get_statusline()
  return [[%!luaeval("require'creativenull.statusline'.render()")]]
end

function M.setlocal_active_statusline()
  vim.api.nvim_win_set_option(0, 'statusline', M.get_statusline())
end

function M.setlocal_inactive_statusline()
  vim.api.nvim_win_set_option(0, 'statusline', '^^^%=^^^')
end

return M
