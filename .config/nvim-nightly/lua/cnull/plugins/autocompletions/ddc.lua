local augroup = require('cnull.core.event').augroup
local imap = require('cnull.core.keymap').imap
local ddc = {
  patch_global = vim.fn['ddc#custom#patch_global'],
  enable = vim.fn['ddc#enable'],
  disable = vim.fn['ddc#disable'],
  nvim_lsp_doc = {
    enable = vim.fn['ddc_nvim_lsp_doc#enable'],
  },
}

ddc.patch_global('sources', {'nvimlsp', 'around', 'ultisnips'})
ddc.patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_fuzzy'},
    sorters = {'sorter_rank'},
  },
  ultisnips = {
    mark = 'UltiSnips',
  },
  nvimlsp = {
    mark = 'LSP',
    forceCompletionPattern = '\\.|:|->',
  },
})

imap('<C-Space>', [=[ddc#manual_complete()]=], { silent = true, expr = true })

ddc.nvim_lsp_doc.enable()

augroup('ddc_user_events', {
  {
    event = {'BufEnter', 'BufNew'},
    exec = function()
      local bufnr = vim.fn.bufnr('')
      local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if ft == 'TelescopePrompt' then
        ddc.disable()
      else
        ddc.enable()
      end
    end,
  },
})
