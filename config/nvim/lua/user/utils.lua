local M = {}

---Toggle conceal level of local buffer
---which is enabled by some syntax plugin
---@return nil
function M.toggle_conceal_level()
  local win = vim.api.nvim_get_current_win()
  local cl = vim.api.nvim_win_get_option(win, "conceallevel")

  if cl == 2 then
    vim.wo[win].conceallevel = 0
  else
    vim.wo[win].conceallevel = 2
  end
end

---Toggle the view of the editor, for taking screenshots
---or for copying code from the editor w/o using "+ register
---when not accessible, eg from a remote ssh or WSL
---@return nil
function M.toggle_codeshot()
  local win = vim.api.nvim_get_current_win()
  local num = vim.api.nvim_win_get_option(win, "number")

  if num then
    vim.opt.number = false
    vim.opt.signcolumn = "no"
    vim.cmd("IBLDisable")
  else
    vim.opt.number = true
    vim.opt.signcolumn = "yes"
    vim.cmd("IBLEnable")
  end
end

---Reload the config and lua scope
---@return nil
function M.reload_config(ns)
  ns = ns or "user"

  for name, _ in pairs(package.loaded) do
    if name:match("^" .. ns) then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

---Horizontally resize window, if there are more than one window
---@param amount number
---@return nil
function M.resize_win_hor(amount)
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd(string.format("resize %s%d", amount > 0 and "+" or "", amount))
  end
end

---Vertically resize window, if there are more than one window
---@param amount number
---@return nil
function M.resize_win_vert(amount)
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd(string.format("vertical resize %s%d", amount > 0 and "+" or "", amount))
  end
end

---Set the highlights for transparent background,
---to be used inside an autocmd
---@return nil
function M.set_transparent_bg()
  -- Core highlights to make transparent
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", fg = "#888888" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#555555" })

  -- Sometimes comments are too dark, affects in tranparent mode
  vim.api.nvim_set_hl(0, "Comment", { fg = "#888888" })

  -- Tabline
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })

  -- Float Border
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#eeeeee" })

  -- Vertical Line
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#999999" })

  -- LSP Diagnostics
  vim.api.nvim_set_hl(0, "ErrorFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WarningFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "InfoFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "HintFloat", { bg = "NONE" })
end

return M
