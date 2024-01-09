if vim.g.loaded_user_wsl ~= nil then
  return
end

local win_username = 'creativenobu'

vim.api.nvim_create_user_command('WslCopy', function(ev)
  if vim.fn.has('wsl') == 0 then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, ev.line1 - 1, ev.line2, false)
  vim.fn.writefile(lines, string.format('/mnt/c/Users/%s/_wsl_clipboard.txt', win_username))
  vim.print('Copied to Windows')
end, { range = true })

vim.g.loaded_user_wsl = true
