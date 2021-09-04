local M = {
  plugins = {
    -- nvim-compe
    -- {'hrsh7th/nvim-compe'},

    -- nvim-cmp
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'quangnguyen30192/cmp-nvim-ultisnips'},

    -- coq_nvim
    -- {'ms-jpq/coq_nvim', opt = true, branch = 'coq'},
    -- {'ms-jpq/coq.artifacts', opt = true, branch = 'artifacts'},

    -- ddc.vim
    -- {'Shougo/ddc.vim', requires = {'vim-denops/denops.vim'}},
    -- {'Shougo/ddc-sorter_rank', requires = {'Shougo/ddc.vim'}},
    -- {'matsui54/ddc-matcher_fuzzy', requires = {'Shougo/ddc.vim'}},
    -- {'Shougo/ddc-around', requires = {'Shougo/ddc.vim'}},
    -- {'Shougo/ddc-nvim-lsp', requires = {'Shougo/ddc.vim'}},
    -- {'matsui54/ddc-ultisnips', requires = {'Shougo/ddc.vim'}},
    -- {'matsui54/ddc-nvim-lsp-doc', requires = {'Shougo/ddc.vim'}},
  },
}

function M.after()
  -- ddc.vim Config
  -- ---
  -- require('cnull.plugins.autocompletions.ddc')

  -- compe.nvim Config
  -- ---
  -- require('cnull.plugins.autocompletions.compe')

  -- nvim-cmp Config
  -- ---
  require('cnull.plugins.autocompletions.cmp')
end

return M
