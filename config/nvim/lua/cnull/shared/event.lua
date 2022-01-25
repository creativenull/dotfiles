local M = {
  augroup = {},
  autocmd = {},
}

---Create an auto command, for example:
---
---    autocmd.set('FileType', 'setlocal expandtab', { pattern = 'python' })
---    autocmd.set('BufEnter', 'setlocal colorcolumns', { pattern = '*.js' })
---
---@param event string
---@param command string
---@param opts table
---@return nil
M.autocmd.set = function(event, command, opts)
  opts = opts or { once = nil, nested = nil, pattern = '*' }
  local once = opts.once and '++once' or ''
  local nested = opts.nested and '++nested' or ''
  local pattern = opts.pattern or '*'

  vim.cmd(string.format('autocmd %s %s %s %s %s', event, pattern, once, nested, command))
end

---Create an auto group command that takes autocmd table, for example:
---
---    augroup.set('custom_events', {
---        { 'ColorScheme', 'highlight! Normal guibg=NONE' },
---        { 'FileType', 'setlocal colorcolumn=120', { pattern = 'javascript' } },
---    })
---
---@param name string
---@param autocmds table
---@return nil
M.augroup.set = function(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')

  for _, au in pairs(autocmds) do
    vim.autocmd.set(au[1], au[2], au[3])
  end

  vim.cmd('augroup END')
end

return M
