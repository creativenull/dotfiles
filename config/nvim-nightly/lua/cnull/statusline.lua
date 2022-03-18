local base_colors = {
  light = '#f1f5f9',
  dark = '#111827',
  softlight = '#cbd5e1',
  softdark = '#334155',
}

local colors = {
  text_light = base_colors.light,
  text_dark = base_colors.dark,
  text_softlight = base_colors.softlight,
  text_softdark = base_colors.softdark,

  bg_light = base_colors.light,
  bg_dark = base_colors.dark,
  bg_softlight = base_colors.softlight,
  bg_softdark = base_colors.softdark,

  primary = '#0369a1',
  indigo = '#4f46e5',
  gray = '#1f2937',
  darkgray = '#111827',

  insert_primary = '#0c4a6e',
  visual_primary = '#92400e',
  command_primary = '#94a3b8',
  replace_primary = '#94a3b8',

  error = '#881337',
  warn = '#fdba74',
}

local theme = {
  normal = {
    a = { fg = colors.text_softlight, bg = colors.primary },
    b = { fg = colors.text_softlight, bg = colors.darkgray },
    c = { fg = 'NONE', bg = colors.bg_dark },
    x = { fg = colors.text_light, bg = colors.darkgray },
    y = { fg = colors.text_light, bg = colors.gray },
    z = { fg = colors.text_light, bg = colors.indigo },
  },
  insert = {
    a = { fg = colors.text_softlight, bg = colors.insert_primary },
    b = { fg = colors.text_softlight, bg = colors.darkgray },
    c = { fg = 'NONE', bg = colors.insert_primary },
    x = { fg = colors.text_light, bg = colors.insert_primary },
    y = { fg = colors.text_light, bg = colors.gray },
    z = { fg = colors.text_light, bg = colors.indigo },
  },
  visual = {
    a = { fg = colors.text_softlight, bg = colors.visual_primary },
    b = { fg = colors.text_softlight, bg = colors.darkgray },
    c = { fg = 'NONE', bg = colors.visual_primary },
    x = { fg = colors.text_light, bg = colors.visual_primary },
    y = { fg = colors.text_light, bg = colors.gray },
    z = { fg = colors.text_light, bg = colors.indigo },
  },
  command = {
    a = { fg = colors.text_softdark, bg = colors.command_primary },
    b = { fg = colors.text_softlight, bg = colors.darkgray },
    c = { fg = 'NONE', bg = colors.command_primary },
    x = { fg = colors.text_dark, bg = colors.command_primary },
    y = { fg = colors.text_light, bg = colors.gray },
    z = { fg = colors.text_light, bg = colors.indigo },
  },
  replace = {
    a = { fg = colors.text_softdark, bg = colors.replace_primary },
    b = { fg = colors.text_softlight, bg = colors.darkgray },
    c = { fg = 'NONE', bg = colors.replace_primary },
    x = { fg = colors.text_dark, bg = colors.replace_primary },
    y = { fg = colors.text_light, bg = colors.gray },
    z = { fg = colors.text_light, bg = colors.indigo },
  },
  inactive = {
    a = { fg = colors.text_softlight, bg = colors.bg_softdark },
    b = { fg = colors.text_softlight, bg = colors.bg_softdark },
    c = { fg = 'NONE', bg = colors.bg_dark },
    x = { fg = colors.text_softlight, bg = colors.bg_softdark },
    y = { fg = colors.text_softlight, bg = colors.bg_softdark },
    z = { fg = colors.text_softlight, bg = colors.bg_softdark },
  },
}

-- Line Info Component
local function line_info_component()
  local bufinfo = vim.fn.getbufinfo(vim.api.nvim_get_current_buf())[1]

  -- Get the counts on the current buffer
  local linecount = bufinfo.linecount
  local linenum = bufinfo.lnum
  local col = vim.fn.col('.')

  return string.format(' %s/%s  %s', linenum, linecount, col)
end

local function lsp_ready_component()
  if not vim.lsp.buf.server_ready() then
    return ''
  else
    return 'LSP'
  end
end

local function err_diagnostic_component()
  local bufnr = vim.api.nvim_get_current_buf()
  local severity = vim.diagnostic.severity.ERROR
  local diagnostics = vim.diagnostic.get(bufnr, { severity = severity })

  return vim.tbl_count(diagnostics)
end

local function is_err_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local severity = vim.diagnostic.severity.ERROR
  local diagnostics = vim.diagnostic.get(bufnr, { severity = severity })

  return vim.tbl_count(diagnostics) > 0
end

local function warn_diagnostic_component()
  local bufnr = vim.api.nvim_get_current_buf()
  local severity = vim.diagnostic.severity.WARN
  local diagnostics = vim.diagnostic.get(bufnr, { severity = severity })

  return vim.tbl_count(diagnostics)
end

local function is_warn_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local severity = vim.diagnostic.severity.WARN
  local diagnostics = vim.diagnostic.get(bufnr, { severity = severity })

  return vim.tbl_count(diagnostics) > 0
end

local function nvim_nightly_build_component()
  return 'nightly'
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = theme,
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'TelescopePrompt' },
    globalstatus = true,
  },

  sections = {
    lualine_a = { 'filename' },
    lualine_b = { 'branch' },
    lualine_c = {},

    lualine_x = { nvim_nightly_build_component, 'encoding' },
    lualine_y = { line_info_component },
    lualine_z = {
      lsp_ready_component,
      {
        err_diagnostic_component,
        cond = is_err_diagnostic,
        separator = { left = '' },
        color = { fg = colors.text_softlight, bg = colors.error }
      },
      {
        warn_diagnostic_component,
        cond = is_warn_diagnostic,
        separator = { left = '' },
        color = { fg = colors.text_softdark, bg = colors.warn }
      },
    },
  },

  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},

    lualine_x = {},
    lualine_y = { line_info_component },
    lualine_z = { 'encoding' },
  },
})
