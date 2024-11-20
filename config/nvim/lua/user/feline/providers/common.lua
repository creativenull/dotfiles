local M = {}

local function get_digits(num)
  return #tostring(num)
end

local function get_lpadding(digits)
  local pad = ""
  local i = 0
  while i < digits do
    pad = pad .. " "
    i = i + 1
  end

  return pad
end

M.colors = {
  neutral100 = "#f5f5f5",
  neutral200 = "#e5e5e5",
  neutral300 = "#d4d4d4",
  neutral400 = "#a1a1aa",
  neutral500 = "#737373",
  neutral800 = "#262626",
  neutral900 = "#171717",

  emerald600 = "#059669",
  emerald800 = "#065f46",
  emerald900 = "#064e3b",

  pink700 = "#be185d",

  rose500 = "#f43f5e",
  rose700 = "#be123c",
  rose800 = "#9f1239",
  rose900 = "#881337",

  amber300 = "#fcd34d",
  amber700 = "#b45309",
  amber800 = "#92400e",

  sky700 = "#0369a1",
  sky800 = "#075985",

  violet700 = "#6d28d9",
  violet800 = "#5b21b6",

  purple700 = "#7e22ce",
  purple800 = "#6b21a8",

  fuchia700 = "#a21caf",
  fuchia800 = "#86198f",
  fuchia900 = "#701a75",

  red600 = "#dc2626",
  yellow600 = "#ca8a04",
  cyan800 = "#0e7490",

  green700 = "#15803d",

  teal900 = "#134e4a",

  indigo800 = "#3730a3",
}

function M.is_not_empty_buffer()
  return vim.fn.expand("%:t") ~= ""
end

function M.is_empty_buffer()
  return vim.fn.expand("%:t") == ""
end

function M.get_vim_mode()
  local mode = {
    n = { text = "N", hl = { fg = M.colors.neutral200, bg = M.colors.sky700 } },
    v = { text = "V", hl = { fg = M.colors.neutral200, bg = M.colors.amber700 } },
    V = { text = "V", hl = { fg = M.colors.neutral200, bg = M.colors.amber700 } },
    [""] = { text = "V", hl = { fg = M.colors.neutral200, bg = M.colors.amber700 } },
    i = { text = "I", hl = { fg = M.colors.neutral200, bg = M.colors.rose800 } },
    R = { text = "R", hl = { fg = M.colors.neutral100, bg = M.colors.pink700 } },
    c = { text = "C", hl = { fg = M.colors.neutral200, bg = M.colors.purple700 } },
    t = { text = "T", hl = { fg = M.colors.neutral200, bg = M.colors.indigo800 } },
  }

  local current = vim.api.nvim_get_mode()
  return mode[current.mode]
end

function M.filename_provider(_, opts)
  local modified_icon = " 󰲶"
  if opts.modified_icon then
    modified_icon = opts.modified_icon
  end

  local readonly_icon = " 󰌾"
  if opts.readonly_icon then
    readonly_icon = opts.readonly_icon
  end

  local buf = vim.api.nvim_get_current_buf()
  local modified = vim.bo[buf].modified and modified_icon or ""
  local readonly = vim.bo[buf].readonly and readonly_icon or ""
  local nerdfont = vim.call("nerdfont#find")
  local filename = vim.fn.expand("%:t")

  return string.format(" %s %s%s%s ", nerdfont, filename, modified, readonly)
end

function M.line_info_provider(component)
  if component.enabled == nil then
    component.enabled = function()
      return M.is_not_empty_buffer()
    end
  end

  local curpos = vim.fn.getcurpos()
  local col = curpos[3]
  local lnum = curpos[2]
  local digits = get_digits(lnum)
  local total_lnum = vim.fn.line("$")
  local total_digits = get_digits(total_lnum)
  local padding = get_lpadding(total_digits - digits)

  return string.format("  %s/%s  %s ", padding .. lnum, total_lnum, col)
end

return M
