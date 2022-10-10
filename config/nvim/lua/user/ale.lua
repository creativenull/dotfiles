local M = {}

function M.setup()
  -- Vars
  vim.g.ale_disable_lsp = 1
  vim.g.ale_completion_enabled = 0
  vim.g.ale_completion_autoimport = 1
  vim.g.ale_hover_cursor = 0
  vim.g.ale_echo_msg_error_str = 'Err'
  vim.g.ale_sign_error = ' '
  vim.g.ale_echo_msg_warning_str = 'Warn'
  vim.g.ale_sign_warning = ' '
  vim.g.ale_echo_msg_info_str = 'Info'
  vim.g.ale_sign_info = ' '
  vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
  vim.g.ale_linters_explicit = 1
  vim.g.ale_fixers = { ['*'] = { 'remove_trailing_lines', 'trim_whitespace' } }

  -- Keymaps
  vim.keymap.set('n', '<Leader>af', '<Cmd>ALEFix<CR>', { silent = true })
  vim.keymap.set('n', '<Leader>ai', '<Cmd>ALEInfo<CR>', { silent = true })
end

return M
