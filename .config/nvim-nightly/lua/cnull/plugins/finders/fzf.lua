local nmap = require('cnull.core.keymap').nmap
local command = require('cnull.core.command')
local M = {}

function M.before()
  vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  vim.env.FZF_DEFAULT_OPTS = '--reverse'
  vim.g.fzf_preview_window = {}
end

function M.after()
  local fzf = {
    vim = {
      grep = vim.fn['fzf#vim#grep'],
      with_preview = vim.fn['fzf#vim#with_preview'],
    },
  }

  function _G.FzfVimGrep(qargs, bang)
    local sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. vim.fn.shellescape(qargs)
    fzf.vim.grep(sh, 1, fzf.vim.with_preview('right:50%', 'ctrl-/'), bang)
  end

  command('Rg', 'lua FzfVimGrep(<q-args>, <bang>0)', {'-nargs=*', '-bang'})

  nmap('<C-p>', '<Cmd>Files<CR>')
  nmap('<C-t>', '<Cmd>Rg<CR>')
end

return M
