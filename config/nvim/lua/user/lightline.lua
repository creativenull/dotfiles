local M = {}

function M.setup()
  vim.g.lightline = {
    colorscheme = 'tailwind_cnull',
    enable = { statusline = 1, tabline = 1 },
    separator = { left = '', right = '' },
    tabline = { left = { { 'buffers' } }, right = { { 'filetype' } } },
    active = {
      left = { { 'filename' }, { 'gitbranch', 'readonly', 'modified' } },
      right = {
        { 'ale_err', 'ale_warn', 'ale_status', 'nvimlsp_status' },
        { 'filetype', 'fileencoding' },
        { 'lineinfo' },
      },
    },
    inactive = {
      left = { { 'filename' }, {} },
      right = { {}, {}, { 'lineinfo' } },
    },
    component = { lineinfo = ' %l/%L  %c' },
    component_function = {
      gitbranch = 'user#lightline#GitBranch',
      ale_status = 'user#lightline#StlStatus',
      nvimlsp_status = 'user#lightline#LspStatus',
    },
    component_expand = {
      ale_err = 'user#lightline#StlErrComponent',
      ale_warn = 'user#lightline#StlWarnComponent',
      buffers = 'lightline#bufferline#buffers',
    },
    component_type = {
      ale_err = 'error',
      ale_warn = 'warning',
      buffers = 'tabsel',
    },
  }

  vim.api.nvim_create_autocmd('User', {
    group = vim.g.user.event,
    pattern = 'ALEJobStarted',
    command = 'call lightline#update()',
  })
  vim.api.nvim_create_autocmd('User', {
    group = vim.g.user.event,
    pattern = 'ALELintPost',
    command = 'call lightline#update()',
  })
  vim.api.nvim_create_autocmd('User', {
    group = vim.g.user.event,
    pattern = 'ALEFixPost',
    command = 'call lightline#update()',
  })

  -- lightline-bufferline Config
  vim.g['lightline#bufferline#enable_nerdfont'] = 1
end

return M
