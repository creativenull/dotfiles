local imap = require('cnull.core.keymap').imap

local function get_termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.TabCompletionExpr(default_key)
  if vim.fn.pumvisible() == 1 then
    return get_termcode('<C-y>')
  else
    return get_termcode(default_key)
  end
end

imap('<Tab>', [=[v:lua.TabCompletionExpr('<Tab>')]=] , { expr = true, silent = true })

vim.cmd('COQnow')
