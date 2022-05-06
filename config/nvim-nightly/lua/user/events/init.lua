local events = {
  'indent_rules',
  'last_position',
  'transparent',
  'winseparator',
  'yank',
}

for _, event in pairs(events) do
  local ok, e = pcall(require, string.format('user.events.%s', event))

  if not ok then
    vim.notify(e, vim.log.levels.ERROR)
  end
end
