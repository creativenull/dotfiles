local lualine = require('lualine')
local custom_powerline = require('lualine.themes.powerline')
custom_powerline.normal.a = {}
custom_powerline.normal.a.bg = '#047857'
custom_powerline.normal.z = {}
custom_powerline.normal.z.bg = '#444444'
custom_powerline.insert.z = {}
custom_powerline.insert.z.bg = custom_powerline.insert.a.bg
custom_powerline.insert.z.fg = custom_powerline.insert.a.fg

-- Line Info Component
local function line_info_component()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufinfo = vim.fn.getbufinfo(bufnr)
  bufinfo = bufinfo[1]
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

lualine.setup({
  options = {
    icons_enabled = true,
    theme = custom_powerline,
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'TelescopePrompt' },
  },

  sections = {
    lualine_a = { 'filename' },
    lualine_b = { 'branch' },
    lualine_c = {},

    lualine_x = { 'encoding' },
    lualine_y = { line_info_component },
    lualine_z = {
      lsp_ready_component,
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        sections = { 'error', 'warn' },
        diagnostics_color = {
          error = { fg = '#ff6666' },
          warn = { fg = '#eeee99' },
          info = nil,
          hint = nil,
        },
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
