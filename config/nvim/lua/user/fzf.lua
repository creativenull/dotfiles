local M = {}

local function vim_grep(qargs, bang)
  local query = '""'
  if qargs ~= nil then
    query = vim.fn.shellescape(qargs)
  end

  local sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. query
  vim.call('fzf#vim#grep', sh, 1, vim.call('fzf#vim#with_preview', 'right:50%', 'ctrl-/'), bang)
end

local function fzf_window_setup()
  local buf = vim.api.nvim_get_current_buf()
  vim.opt.ruler = false

  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    callback = function()
      vim.opt.ruler = true
    end,
  })
end

function M.Setup()
  -- Vars
  vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  vim.env.FZF_DEFAULT_OPTS = '--reverse'
  vim.g.fzf_preview_window = {}

  -- Commands
  vim.api.nvim_create_user_command('Rg', function(arg)
    vim_grep(arg.qargs, arg.bang)
  end, { bang = true, nargs = '*' })

  -- Keymaps
  vim.keymap.set('n', '<C-p>', '<Cmd>Files<CR>')
  vim.keymap.set('n', '<C-t>', '<Cmd>Rg<CR>')

  -- Events
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.g.user.event,
    pattern = 'fzf',
    callback = fzf_window_setup,
    desc = 'Configure fzf window before it is viewed',
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, 'fzfBorder', { fg = '#aaaaaa' })
    end,
    desc = 'Change the highlight of fzf border line',
  })
end

return M
