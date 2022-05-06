local commands = {
  'conceal',
  'codeshot',
  'config',
  'todo',
}

for _, command in pairs(commands) do
  local ok, e = pcall(require, string.format('user.commands.%s', command))

  if not ok then
    vim.notify(e, vim.log.levels.ERROR)
  end
end
