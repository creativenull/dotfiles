local common = require("user.feline.providers.common")
local colors = common.colors
local gitsigns = require("user.feline.providers.gitsigns")
local lsp = require("user.feline.providers.lsp")
local ale = require("feline.custom_providers.ale")
local M = {}

function M.setup()
  local components = {
    active = { {}, {}, {} },
    inactive = { {}, {} },
  }

  -- Left
  -- ---
  table.insert(components.active[1], {
    provider = "filename",
    hl = { fg = colors.neutral900, bg = colors.neutral200 },
    right_sep = {
      str = "slant_right",
      hl = function()
        if gitsigns.has_branch() then
          return { fg = colors.neutral200, bg = colors.neutral300 }
        end
        return { fg = colors.neutral200, bg = colors.neutral900 }
      end,
    },
  })

  table.insert(components.active[1], {
    provider = "gitsigns_status",
    hl = { fg = colors.neutral800, bg = colors.neutral300 },
    right_sep = {
      str = "slant_right",
      hl = function()
        if gitsigns.has_changes("added") or gitsigns.has_changes("removed") or gitsigns.has_changes("changed") then
          return { fg = colors.neutral300, bg = colors.neutral300 }
        end
        return { fg = colors.neutral300, bg = colors.neutral900 }
      end,
    },
  })

  table.insert(components.active[1], {
    provider = "gitsigns_added",
    hl = { fg = colors.emerald900, bg = colors.neutral300 },
    right_sep = {
      "block",
      {
        str = "slant_right",
        hl = function()
          if gitsigns.has_changes("changed") or gitsigns.has_changes("removed") then
            return { fg = colors.neutral300, bg = colors.neutral300 }
          end
          return { fg = colors.neutral300, bg = colors.neutral900 }
        end,
      },
    },
  })

  table.insert(components.active[1], {
    provider = "gitsigns_changed",
    hl = { fg = colors.amber800, bg = colors.neutral300 },
    right_sep = {
      "block",
      {
        str = "slant_right",
        hl = function()
          if gitsigns.has_changes("removed") then
            return { fg = colors.neutral300, bg = colors.neutral300 }
          end
          return { fg = colors.neutral300, bg = colors.neutral900 }
        end,
      },
    },
  })

  table.insert(components.active[1], {
    provider = "gitsigns_removed",
    hl = { fg = colors.rose900, bg = colors.neutral300 },
    right_sep = {
      "block",
      {
        str = "slant_right",
        hl = { fg = colors.neutral300, bg = colors.neutral900 },
      },
    },
  })

  table.insert(components.active[1], {
    provider = "",
    hl = { bg = colors.neutral900 },
  })

  -- Middle
  -- ---
  -- table.insert(components.active[2], {
  --   provider = function()
  --     local mode = common.get_vim_mode()
  --     return string.format('   %s   ', mode.text)
  --   end,
  --   hl = function()
  --     return common.get_vim_mode().hl
  --   end,
  --   left_sep = {
  --     str = 'slant_right',
  --     hl = function()
  --       return { fg = colors.neutral900, bg = common.get_vim_mode().hl.bg }
  --     end,
  --   },
  --   right_sep = {
  --     str = 'slant_left',
  --     hl = function()
  --       return { fg = colors.neutral900, bg = common.get_vim_mode().hl.bg }
  --     end,
  --   },
  -- })
  -- table.insert(components.active[2], {
  --   provider = function()
  --     return ''
  --   end,
  --   hl = { bg = colors.neutral900 },
  -- })

  -- Right
  -- ---
  table.insert(components.active[3], {
    provider = "line_info",
    hl = { bg = colors.neutral900, fg = colors.neutral100 },
  })

  table.insert(components.active[3], {
    provider = "ale_status",
    hl = { fg = colors.neutral100, bg = colors.emerald800 },
    left_sep = {
      str = "slant_left",
      -- hl = { fg = colors.emerald800, bg = colors.green700 },
      hl = function()
        if common.is_not_empty_buffer() then
          return { fg = colors.emerald800, bg = colors.neutral900 }
        end
        return { fg = colors.emerald800, bg = colors.neutral900 }
      end,
    },
  })

  table.insert(components.active[3], {
    provider = "lsp_status",
    hl = { fg = colors.neutral100, bg = colors.teal900 },
    left_sep = {
      str = "slant_left",
      hl = function()
        if not ale.is_registered() then
          return { fg = colors.teal900, bg = colors.neutral900 }
        end
        return { fg = colors.teal900, bg = colors.emerald800 }
      end,
    },
  })

  table.insert(components.active[3], {
    provider = "nvim_diagnostic_error",
    hl = { fg = colors.neutral100, bg = colors.red600 },
    left_sep = {
      str = "slant_left",
      hl = function()
        if not ale.is_registered() and not lsp.is_registered() then
          return { fg = colors.red600, bg = colors.neutral900 }
        elseif ale.is_registered() and not lsp.is_registered() then
          return { fg = colors.red600, bg = colors.emerald800 }
        end
        return { fg = colors.red600, bg = colors.teal900 }
      end,
    },
  })

  table.insert(components.active[3], {
    provider = "nvim_diagnostic_warning",
    hl = { fg = colors.neutral100, bg = colors.yellow600 },
    left_sep = {
      str = "slant_left",
      hl = function()
        if lsp.get_diagnostic_count("error") == 0 then
          return { fg = colors.yellow600, bg = colors.teal900 }
        end
        return { fg = colors.yellow600, bg = colors.red600 }
      end,
    },
  })

  table.insert(components.active[3], {
    provider = "nvim_diagnostic_info",
    hl = { fg = colors.neutral100, bg = colors.sky800 },
    left_sep = {
      str = "slant_left",
      hl = function()
        if lsp.get_diagnostic_count("error") > 0 and lsp.get_diagnostic_count("warning") == 0 then
          return { fg = colors.sky800, bg = colors.red600 }
        elseif lsp.get_diagnostic_count("error") == 0 and lsp.get_diagnostic_count("warning") > 0 then
          return { fg = colors.sky800, bg = colors.yellow600 }
        elseif lsp.get_diagnostic_count("error") == 0 and lsp.get_diagnostic_count("warning") == 0 then
          return { fg = colors.sky800, bg = colors.teal900 }
        elseif lsp.get_diagnostic_count("error") > 0 and lsp.get_diagnostic_count("warning") > 0 then
          return { fg = colors.sky800, bg = colors.yellow600 }
        end
        return { fg = colors.sky800, bg = colors.teal900 }
      end,
    },
  })

  -- Inactive Left
  -- ---
  table.insert(components.inactive[1], {
    provider = "filename",
    hl = { fg = colors.neutral900, bg = colors.neutral200 },
    right_sep = {
      str = "slant_right",
      hl = { fg = colors.neutral200, bg = colors.neutral900 },
    },
  })

  -- Inactive Right
  -- ---
  table.insert(components.inactive[2], {
    provider = "line_info",
    hl = { fg = colors.neutral100, bg = colors.green700 },
    left_sep = {
      str = "slant_left",
      hl = { fg = colors.green700, bg = colors.neutral900 },
    },
  })

  require("feline").setup({
    components = components,
    custom_providers = {
      filename = common.filename_provider,
      line_info = common.line_info_provider,

      -- gitsigns
      gitsigns_status = gitsigns.gitsigns_status_provider,
      gitsigns_added = gitsigns.gitsigns_added_provider,
      gitsigns_changed = gitsigns.gitsigns_changed_provider,
      gitsigns_removed = gitsigns.gitsigns_removed_provider,

      -- lsp
      lsp_status = lsp.status_provider,
      nvim_diagnostic_error = lsp.diagnostic_error_provider,
      nvim_diagnostic_warning = lsp.diagnostic_warning_provider,
      nvim_diagnostic_info = lsp.diagnostic_info_provider,

      -- ALE
      ale_status = ale.status_provider,
      ale_diagnostic_error = ale.diagnostic_error_provider,
      ale_diagnostic_warning = ale.diagnostic_warning_provider,
      ale_diagnostic_info = ale.diagnostic_info_provider,
    },
  })
end

return M
