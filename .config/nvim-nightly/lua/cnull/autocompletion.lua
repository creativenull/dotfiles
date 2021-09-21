local ddc = {
  patch_global = vim.fn['ddc#custom#patch_global'],
  enable = vim.fn['ddc#enable'],
  nvim_lsp_doc = {
    enable = vim.fn['ddc_nvim_lsp_doc#enable'],
  },
}

ddc.patch_global('autoCompleteDelay', 250)
ddc.patch_global('sources', {'nvimlsp', 'ultisnips', 'around'})
ddc.patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_full_fuzzy'},
    sorters = {'sorter_rank'},
    ignoreCase = true,
  },
  ultisnips = {
    mark = 'ultisnips',
  },
  nvimlsp = {
    mark = 'lsp',
    forceCompletionPattern = '\\.|:|->',
  },
  around = {
    mark = 'around',
  },
})

-- Enable completion
ddc.nvim_lsp_doc.enable()
ddc.enable()

-- Tab completion
local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.user_tab_completion(default_keybind)
  if vim.fn.pumvisible() == 1 then
    if vim.call('UltiSnips#CanExpandSnippet') == 1 then
      return termcodes('<C-r>=UltiSnips#ExpandSnippet()<CR>')
    else
      return termcodes('<C-y>')
    end
  end

  return termcodes(default_keybind)
end
