local gl = require 'galaxyline'
local gls = gl.section
gl.short_line_list = { 'TelescopePrompt', 'nnn' }

local diagnostic = require 'galaxyline.provider_diagnostic'
local vcs = require 'galaxyline.provider_vcs'
local fileinfo = require 'galaxyline.provider_fileinfo'
local extension = require 'galaxyline.provider_extensions'
local colors = require 'galaxyline.colors'
local buffer = require 'galaxyline.provider_buffer'
local whitespace = require 'galaxyline.provider_whitespace'
local lspclient = require 'galaxyline.provider_lsp'

local colors = {
  base0 = '#1B2229',
  base1 = '#1c1f24',
  base2 = '#202328',
  base3 = '#23272e',
  base4 = '#3f444a',
  base5 = '#5B6268',
  base6 = '#73797e',
  base7 = '#9ca0a4',
  base8 = '#b1b1b1',

  bg = '#282a36',
  bg1 = '#504945',
  bg_popup = '#3E4556',
  bg_highlight  = '#2E323C',
  bg_visual = '#b3deef',

  fg = '#bbc2cf',
  fg_alt  = '#5B6268',

  red = '#e95678',

  redwine = '#d16d9e',
  orange = '#D98E48',
  yellow = '#f0c674',

  light_green = '#abcf84',
  green = '#afd700',
  dark_green = '#98be65',

  cyan = '#36d0e0',
  blue = '#61afef',
  violet = '#b294bb',
  magenta = '#c678dd',
  teal = '#1abc9c',
  grey = '#928374',
  brown = '#c78665',
  black = '#000000',

  bracket = '#80A0C2',
  currsor_bg = '#4f5b66',
  none = 'NONE',
}

local mode_provider = function()
  local alias = {
    n      = 'NORMAL ',
    i      = 'INSERT ',
    c      = 'COMMAND ',
    cv     = 'COMMAND ',
    ce     = 'COMMAND ',
    v      = 'VISUAL ',
    V      = 'VISUAL-L ',
    [''] = 'VISUAL-B ',
    s      = 'SELECT ',
    S      = 'SELECT-L ',
    [''] = 'SELECT-B ',
    R      = 'REPLACE ',
    Rc     = 'REPLACE ',
    Rv     = 'REPLACE ',
    Rx     = 'REPLACE ',
  }
  return alias[vim.fn.mode()]
end

local space_provider = function()
  return ' '
end

local line_info_provider = function()
  local bufnr = vim.fn.bufnr()
  local bufinfo = vim.fn.getbufinfo(bufnr)
  bufinfo = bufinfo[1]
  local linecount = bufinfo.linecount
  local linenum = bufinfo.lnum
  local col = vim.fn.col('.')
  return string.format('%s/%s:%s', linenum, linecount, col)
end

local lsp_error_provider = function()
  local bufnr = vim.fn.bufnr()
  local errors = vim.lsp.diagnostic.get_count(bufnr, [[Error]])
  if errors ~= 0 then return string.format('E:%s ', errors) end
  return ''
end

local lsp_warning_provider = function()
  local bufnr = vim.fn.bufnr()
  local warnings = vim.lsp.diagnostic.get_count(bufnr, [[Warning]])
  if warnings ~= 0 then return string.format('W:%s ', warnings) end
  return ''
end

local lsp_text_provider = function()
  local clients = vim.lsp.buf_get_clients()
  if vim.tbl_isempty(clients) then return '' end
  return 'LSP'
end

local show_if_buf_exists = function()
  local bufname = vim.fn.expand('%:t')
  if vim.fn.empty(bufname) == 1 then return false end
  return true
end

local function is_insert_mode()
  return vim.fn.mode() == 'i'
end

--[[
-- Active Statusline
--]]
gls.left = {
  -- Vim Mode {{
  {
    VimModeSpaceBeforer = {
      provider = space_provider,
      highlight = { colors.bg, colors.teal },
    },
  },

  {
    VimMode = {
      provider = mode_provider,
      highlight = { colors.bg, colors.teal },
      separator = '',
      separator_highlight = { colors.teal, colors.bg },
    },
  },
  -- }}

  -- Git {{
  {
    GitBranchSpaceBefore = {
      provider = space_provider,
      highlight = { colors.bg, colors.bg },
    },
  },

  {
    GitBranch = {
      provider = vcs.get_git_branch,
      highlight = { colors.fg, colors.bg },
      icon = ' ',
    },
  },

  {
    GitBranchSpaceAfter = {
      provider = space_provider,
      highlight = { colors.fg, colors.bg },
      separator = '',
      separator_highlight = {
        colors.bg,
        function()
          if show_if_buf_exists() then
            return colors.blue
          else
            return colors.bg
          end
        end
      },
    },
  },
  -- }}

  -- File Info {{
  {
    FileInfoSpaceBefore = {
      provider = space_provider,
      condition = show_if_buf_exists,
      highlight = { colors.blue, colors.blue },
    },
  },

  {
    FileIcon = {
      provider = fileinfo.get_file_icon,
      condition = show_if_buf_exists,
      highlight = { colors.bg, colors.blue },
    },
  },

  {
    Filename = {
      provider = fileinfo.get_current_file_name,
      condition = show_if_buf_exists,
      highlight = { colors.bg, colors.blue },
      separator = '',
      separator_highlight = { colors.blue, colors.bg },
    },
  },
  -- }}
}

-- Right Side
gls.right = {
  -- File Encoding/Format {{
  {
    FileEncoding = {
      provider = fileinfo.get_file_encode,
      highlight = { colors.bg, colors.redwine },
      separator = '',
      separator_highlight = { colors.redwine, colors.bg },
    },
  },

  {
    FileEncodingSpaceAfter = {
      provider = space_provider,
      highlight = { colors.redwine, colors.redwine },
    },
  },

  {
    FileFormat = {
      provider = fileinfo.get_file_format,
      highlight = { colors.bg, colors.redwine },
    },
  },

  {
    FileFormatSpaceAfter = {
      provider = space_provider,
      highlight = { colors.redwine, colors.redwine },
    },
  },
  -- }}

  -- Line Info {{
  {
    LineInfoSpaceBefore = {
      provider = space_provider,
      condition = show_if_buf_exists,
      highlight = { colors.bg, colors.bg },
      separator = '',
      separator_highlight = { colors.bg, colors.redwine },
    },
  },

  {
    LineInfo = {
      provider = line_info_provider,
      condition = show_if_buf_exists,
      highlight = { colors.fg, colors.bg },
    },
  },

  {
    LineInfoSpaceAfter = {
      provider = space_provider,
      condition = show_if_buf_exists,
      highlight = { colors.bg, colors.bg },
    },
  },
  -- }}

  -- LSP Status {{
  {
    LspInfoSpaceBefore = {
      provider = space_provider,
      highlight = { colors.fg_alt, colors.fg_alt },
      separator = '',
      separator_highlight = {
        colors.fg_alt,
        function()
          if show_if_buf_exists() then
            return colors.bg
          else
            return colors.redwine
          end
        end
      },
    },
  },

  {
    LspErrorInfo = {
      provider = lsp_error_provider,
      highlight = { colors.red, colors.fg_alt },
    },
  },

  {
    LspWarningInfo = {
      provider = lsp_warning_provider,
      highlight = { colors.yellow, colors.fg_alt },
    },
  },

  {
    LspInfo = {
      provider = lsp_text_provider,
      highlight = { colors.fg, colors.fg_alt },
    },
  },

  {
    LspInfoSpaceAfter = {
      provider = space_provider,
      highlight = { colors.fg_alt, colors.fg_alt },
    },
  },
  -- }}
}

--[[
-- Inactive Statusline
--]]
gls.short_line_left = {
  {
    FileSpaceBefore = {
      provider = space_provider,
      highlight = { colors.blue, colors.blue },
    },
  },

  {
    FileIcon = {
      provider = fileinfo.get_file_icon,
      highlight = { colors.bg, colors.blue },
    },
  },

  {
    Filename = {
      provider = fileinfo.get_current_file_name,
      highlight = { colors.bg, colors.blue },
      separator = '',
      separator_highlight = { colors.blue, colors.bg },
    },
  },
}

gls.short_line_right = {
  -- File Encoding/Format {{
  {
    FileEncoding = {
      provider = fileinfo.get_file_encode,
      highlight = { colors.bg, colors.redwine },
      separator = '',
      separator_highlight = { colors.redwine, colors.bg },
    },
  },

  {
    FileEncodingSpaceAfter = {
      provider = space_provider,
      highlight = { colors.redwine, colors.redwine },
    },
  },

  {
    FileFormat = {
      provider = fileinfo.get_file_format,
      highlight = { colors.bg, colors.redwine },
    },
  },

  {
    FileFormatSpaceAfter = {
      provider = space_provider,
      highlight = { colors.redwine, colors.redwine },
    },
  },
  -- }}
}
