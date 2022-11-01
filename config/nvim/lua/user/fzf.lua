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

function M.setup()
  vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  vim.env.FZF_DEFAULT_OPTS = table.concat({
    '--reverse',
    '--color=border:#aaaaaa,gutter:-1,bg+:-1',
  }, ' ')
  vim.g.fzf_preview_window = {}

  vim.api.nvim_create_user_command('Rg', function(arg)
    vim_grep(arg.qargs, arg.bang)
  end, { bang = true, nargs = '*' })

  vim.keymap.set('n', '<C-p>', '<Cmd>Files<CR>')
  vim.keymap.set('n', '<C-t>', '<Cmd>Rg<CR>')

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.g.user.event,
    pattern = 'fzf',
    callback = fzf_window_setup,
    desc = '(fzf.vim) Adjust settings on enter fzf window',
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, 'fzf1', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'fzf2', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'fzf3', { bg = 'NONE' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = vim.g.user.event,
    pattern = 'FzfStatusLine',
    callback = function(args)
      vim.wo[vim.fn.bufwinid(args.buf)].statusline = '%#fzf1# > %#fzf2#fz%#fzf3#f'
    end,
    desc = '(fzf.vim) Custom highlights',
  })
end

return M
