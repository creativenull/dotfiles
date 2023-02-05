local common = require('user.feline.providers.common')
local gitsigns = require('user.feline.providers.gitsigns')
local lsp = require('user.feline.providers.lsp')
local ale = require('user.feline.providers.ale')
local M = {}

local colors = {
  neutral100 = '#f5f5f5',
  neutral200 = '#e5e5e5',
  neutral300 = '#d4d4d4',
  neutral400 = '#a1a1aa',
  neutral500 = '#737373',
  neutral800 = '#262626',
  neutral900 = '#171717',

  emerald600 = '#059669',
  emerald800 = '#065f46',
  emerald900 = '#064e3b',
  rose500 = '#f43f5e',
  rose900 = '#881337',
  amber300 = '#fcd34d',
  amber800 = '#92400e',

  sky800 = '#075985',

  violet700 = '#6d28d9',
  violet800 = '#5b21b6',

  purple700 = '#7e22ce',
  purple800 = '#6b21a8',

  fuchia700 = '#a21caf',
  fuchia800 = '#86198f',
  fuchia900 = '#701a75',

  red600 = '#dc2626',
  yellow600 = '#ca8a04',
  cyan800 = '#0e7490',

  green700 = '#15803d',

  teal900 = '#134e4a',
}

function M.setup()
  local components = {
    active = { {}, {}, {} },
    inactive = { {}, {} },
  }

  -- Placeholder to darken the statusline
  table.insert(components.active[1], {
    provider = ' ',
    enabled = function()
      return common.is_empty_buffer()
    end,
    hl = { fg = colors.neutral900, bg = colors.neutral900 },
  })

  -- Left
  -- ---
  table.insert(components.active[1], {
    provider = 'filename',
    hl = { fg = colors.neutral900, bg = colors.neutral200 },
    right_sep = {
      str = 'slant_right',
      hl = function()
        if gitsigns.has_branch() then
          return { fg = colors.neutral200, bg = colors.neutral300 }
        end
        return { fg = colors.neutral200, bg = colors.neutral900 }
      end,
    },
  })

  table.insert(components.active[1], {
    provider = 'gitsigns_status',
    hl = { fg = colors.neutral800, bg = colors.neutral300 },
    right_sep = {
      str = 'slant_right',
      hl = function()
        if gitsigns.has_changes('added') or gitsigns.has_changes('removed') or gitsigns.has_changes('changed') then
          return { fg = colors.neutral300, bg = colors.neutral300 }
        end
        return { fg = colors.neutral300, bg = colors.neutral900 }
      end,
    },
  })

  table.insert(components.active[1], {
    provider = 'gitsigns_added',
    hl = { fg = colors.emerald900, bg = colors.neutral300 },
    right_sep = {
      'block',
      {
        str = 'slant_right',
        hl = function()
          if gitsigns.has_changes('changed') or gitsigns.has_changes('removed') then
            return { fg = colors.neutral300, bg = colors.neutral300 }
          end
          return { fg = colors.neutral300, bg = colors.neutral900 }
        end,
      },
    },
  })

  table.insert(components.active[1], {
    provider = 'gitsigns_changed',
    hl = { fg = colors.amber800, bg = colors.neutral300 },
    right_sep = {
      'block',
      {
        str = 'slant_right',
        hl = function()
          if gitsigns.has_changes('removed') then
            return { fg = colors.neutral300, bg = colors.neutral300 }
          end
          return { fg = colors.neutral300, bg = colors.neutral900 }
        end,
      },
    },
  })

  table.insert(components.active[1], {
    provider = 'gitsigns_removed',
    hl = { fg = colors.rose900, bg = colors.neutral300 },
    right_sep = {
      'block',
      {
        str = 'slant_right',
        hl = { fg = colors.neutral300, bg = colors.neutral900 },
      },
    },
  })

  -- Right
  -- ---
  table.insert(components.active[3], {
    provider = function()
      local curpos = vim.fn.getcurpos()
      local lnum = curpos[2]
      local col = curpos[3]
      local total_lunm = vim.fn.line('$')

      return string.format('  %s/%s  %s ', lnum, total_lunm, col)
    end,
    enabled = function()
      return common.is_not_empty_buffer()
    end,
    hl = { fg = colors.neutral100, bg = colors.green700 },
    left_sep = {
      str = 'slant_left',
      hl = { fg = colors.green700, bg = colors.neutral900 },
    },
  })

  table.insert(components.active[3], {
    provider = 'ale_status',
    hl = { fg = colors.neutral100, bg = colors.emerald800 },
    left_sep = {
      str = 'slant_left',
      hl = { fg = colors.emerald800, bg = colors.green700 },
    },
  })

  table.insert(components.active[3], {
    provider = function()
      local count = #vim.lsp.get_active_clients()
      return string.format(' LSP [%s] ', count)
    end,
    enabled = function()
      return #vim.lsp.get_active_clients() > 0
    end,
    hl = { fg = colors.neutral100, bg = colors.teal900 },
    left_sep = {
      str = 'slant_left',
      hl = { fg = colors.teal900, bg = colors.emerald800 },
    },
  })

  table.insert(components.active[3], {
    provider = 'lsp_diagnostic_error',
    hl = { fg = colors.neutral100, bg = colors.red600 },
    left_sep = {
      str = 'slant_left',
      hl = { fg = colors.red600, bg = colors.teal900 },
    },
  })

  table.insert(components.active[3], {
    provider = 'lsp_diagnostic_warning',
    hl = { fg = colors.neutral100, bg = colors.yellow600 },
    left_sep = {
      str = 'slant_left',
      hl = function()
        if lsp.get_diagnostic_count('error') == 0 then
          return { fg = colors.yellow600, bg = colors.teal900 }
        end
        return { fg = colors.yellow600, bg = colors.red600 }
      end,
    },
  })

  table.insert(components.active[3], {
    provider = 'lsp_diagnostic_info',
    hl = { fg = colors.neutral100, bg = colors.sky800 },
    left_sep = {
      str = 'slant_left',
      hl = function()
        if lsp.get_diagnostic_count('error') > 0 and lsp.get_diagnostic_count('warning') == 0 then
          return { fg = colors.sky800, bg = colors.red600 }
        elseif lsp.get_diagnostic_count('error') == 0 and lsp.get_diagnostic_count('warning') > 0 then
          return { fg = colors.sky800, bg = colors.yellow600 }
        elseif lsp.get_diagnostic_count('error') == 0 and lsp.get_diagnostic_count('warning') == 0 then
          return { fg = colors.sky800, bg = colors.teal900 }
        elseif lsp.get_diagnostic_count('error') > 0 and lsp.get_diagnostic_count('warning') > 0 then
          return { fg = colors.sky800, bg = colors.yellow600 }
        end
        return { fg = colors.sky800, bg = colors.teal900 }
      end,
    },
  })

  -- Inactive Left
  -- ---
  table.insert(components.inactive[1], {
    provider = 'filename',
    hl = { fg = colors.neutral900, bg = colors.neutral200 },
    right_sep = {
      str = 'slant_right',
      hl = { fg = colors.neutral200, bg = colors.neutral900 },
    },
  })

  -- Inactive Right
  -- ---
  table.insert(components.inactive[2], {
    provider = function()
      local curpos = vim.fn.getcurpos()
      local lnum = curpos[2]
      local col = curpos[3]
      local total_lunm = vim.fn.line('$')

      return string.format('  %s/%s  %s ', lnum, total_lunm, col)
    end,
    enabled = function()
      return common.is_not_empty_buffer()
    end,
    hl = { fg = colors.neutral100, bg = colors.green700 },
    left_sep = {
      str = 'slant_left',
      hl = { fg = colors.green700, bg = colors.neutral900 },
    },
  })

  require('feline').setup({
    components = components,
    custom_providers = {
      filename = common.filename_provider,

      -- gitsigns
      gitsigns_status = gitsigns.gitsigns_status_provider,
      gitsigns_added = gitsigns.gitsigns_added_provider,
      gitsigns_changed = gitsigns.gitsigns_changed_provider,
      gitsigns_removed = gitsigns.gitsigns_removed_provider,

      -- lsp
      lsp_diagnostic_error = lsp.diagnostic_error_provider,
      lsp_diagnostic_warning = lsp.diagnostic_warning_provider,
      lsp_diagnostic_info = lsp.diagnostic_info_provider,

      -- ALE
      ale_status = ale.status_provider,
      ale_diagnostic_error = ale.diagnostic_error_provider,
      ale_diagnostic_warning = ale.diagnostic_warning_provider,
      ale_diagnostic_info = ale.diagnostic_info_provider,
    },
  })
end

return M
