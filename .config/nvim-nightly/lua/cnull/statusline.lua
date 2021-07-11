local augroup = require 'cnull.core.event'.augroup

local highlights = {
  red = {
    color = '#ff4488',
    hlgroup = '%#StatusLineLspRedText#',
  },
  yellow = {
    color = '#eedd22',
    hlgroup = '%#StatusLineLspYellowText#',
  },
}

local function highlight_color(hi, colortype)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hi)), colortype)
end

local function lsp_highlights()
  local bg = highlight_color('StatusLine', 'bg') or '#ffffff'
  vim.cmd(string.format('highlight StatusLineLspRedText guifg=%s guibg=%s', highlights.red.color, bg))
  vim.cmd(string.format('highlight StatusLineLspYellowText guifg=%s guibg=%s', highlights.yellow.color, bg))
end

local function get_clientnames(bufnr)
  local clients = vim.lsp.buf_get_clients(bufnr)
  local clientnames_tbl = {}

  for _,v in pairs(clients) do
    if v.name then
      table.insert(clientnames_tbl, v.name)
    end
  end

  return table.concat(clientnames_tbl, ',')
end

local function get_diagnostic_count(bufnr)
  local errors = vim.lsp.diagnostic.get_count(bufnr, [[Error]])
  local warnings = vim.lsp.diagnostic.get_count(bufnr, [[Warning]])
  return errors, warnings
end

local function lsp_status()
  local bufnr = vim.fn.bufnr('')
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(bufnr)) then
    local clientnames = get_clientnames(bufnr)
    local errors, warnings = get_diagnostic_count(bufnr)
    local total = errors + warnings
    if total > 0 then
      return string.format('%sE%d%s %sW%d%s LSP [%s]',
        highlights.red.hlgroup,
        errors,
        '%*',
        highlights.yellow.hlgroup,
        warnings,
        '%*',
        clientnames
      )
    else
      return string.format('LSP [%s]', clientnames)
    end
  end

  return 'NO LSP'
end

function _G.RenderActiveStl()
  local branch = ''
  if vim.fn.exists('g:loaded_gitbranch') == 1 then
    if vim.fn['gitbranch#name']() ~= '' then
      branch = '' .. vim.fn['gitbranch#name']()
    end
  end

  local fileencoding = vim.opt.fileencoding:get()
  local fileformat = vim.opt.fileformat:get()
  return string.format([[ %s | %s | %s %s %s | %s | %s | %s ]],
    '%t%m%r',
    branch,
    '%y',
    '%=',
    fileformat,
    fileencoding,
    '%l/%L:%c',
    lsp_status()
  )
end

function _G.RenderInactiveStl()
  return [[ %t%m%r | %y %= %l/%L:%c ]]
end

augroup('statusline_events', {
  {
    event = { 'WinEnter', 'BufEnter' },
    exec = function()
      vim.opt.statusline = [[%!luaeval("RenderActiveStl()")]]
    end,
  },
  {
    event = { 'WinLeave', 'BufLeave' },
    exec = function()
      vim.opt.statusline = [[%!luaeval("RenderInactiveStl()")]]
    end,
  },
  {
    event = 'ColorScheme',
    exec = lsp_highlights,
  },
})

vim.opt.statusline = [[%!luaeval("RenderActiveStl()")]]
