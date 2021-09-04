local M = {
  plugins = {
    {'steelsojka/pears.nvim'},
    {'creativenull/projectlocal-vim', requires = 'vim-denops/denops.vim'},
    {'editorconfig/editorconfig-vim'},
    {'kevinhwang91/nvim-bqf'},
    {'mcchrish/nnn.vim', opt = true},
    {'lambdalisue/fern.vim', opt = true},
    {'tpope/vim-abolish', opt = true},
    {'tpope/vim-surround', opt = true},
    {'tpope/vim-repeat', opt = true},
  },
}

function M.before()
  vim.g.projectlocal = {
    projectConfig = '.vim/init.lua',
  }
end

function M.after()
  local nmap = require('cnull.core.keymap').nmap

  -- nnn.vim/fern.vim Config
  -- ---
  function _G.NnnLoad()
    vim.cmd('packadd nnn.vim')
    require('nnn').setup({
      set_default_mappings = false,
      layout = {
        window = {
          width = 0.9,
          height = 0.6,
          highlight = 'Debug',
        },
      },
    })

    vim.cmd([[NnnPicker %:p:h]])
  end

  function _G.FernLoad()
    vim.cmd('packadd fern.vim')
    vim.cmd([[Fern . -reveal=%]])
  end

  if vim.fn.has('win32') == 1 then
    nmap('<Leader>ff', [[<Cmd>lua FernLoad()<CR>]])
  else
    nmap('<Leader>ff', [[<Cmd>lua NnnLoad()<CR>]])
  end

  -- pears.nvim Config
  -- ---
  require('pears').setup()
end

return M
