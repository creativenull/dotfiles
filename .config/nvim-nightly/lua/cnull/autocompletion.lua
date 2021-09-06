--[[ require('compe').setup({
  source = {
    nvim_lsp  = true,
    ultisnips = true,
  },
}) ]]

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
    mark = 'US',
  },
  nvimlsp = {
    mark = 'LSP',
    forceCompletionPattern = '\\.|:|->',
  },
  around = {
    mark = 'A',
  },
})

ddc.nvim_lsp_doc.enable()
