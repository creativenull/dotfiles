local M = {}

function M.set_hls()
  -- Core highlights to make transparent
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE', fg = '#888888' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'Visual', { bg = '#555555' })

  -- Sometimes comments are too dark, affects in tranparent mode
  vim.api.nvim_set_hl(0, 'Comment', { fg = '#888888' })

  -- Tabline
  vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })

  -- Float Border
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', fg = '#eeeeee' })

  -- Vertical Line
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#999999' })

  -- LSP Diagnostics
  vim.api.nvim_set_hl(0, 'ErrorFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'WarningFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'InfoFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'HintFloat', { bg = 'NONE' })
end

return M
