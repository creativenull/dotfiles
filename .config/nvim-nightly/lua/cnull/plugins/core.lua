local M = {
  plugins = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-lua/popup.nvim'},
    {'steelsojka/pears.nvim'},
    {'vim-denops/denops.vim'},
    {'creativenull/projectlocal-vim'},
    {'editorconfig/editorconfig-vim'},
    {'kevinhwang91/nvim-bqf'},
    {'mcchrish/nnn.vim', opt = true},
    {'antoinemadec/FixCursorHold.nvim', opt = true},
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
    if vim.fn.exists('g:nnn#loaded') ~= 1 then
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
    end

    vim.cmd([[NnnPicker %:p:h]])
  end

  function _G.FernLoad()
    if vim.fn.exists('g:loaded_fern') ~= 1 and vim.fn.exists('g:loaded_fix_cursorhold_nvim ') ~= 1 then
      vim.cmd('packadd FixCursorHold.nvim')
      vim.cmd('packadd fern.vim')
    end

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
