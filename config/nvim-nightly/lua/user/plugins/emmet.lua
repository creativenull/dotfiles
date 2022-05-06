vim.g.user_emmet_leader_key = '<C-q>'
vim.g.user_emmet_install_global = 0

local loaded = false

local lazyLoadEmmetPluginGroup = vim.api.nvim_create_augroup('lazyLoadEmmetPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable emmet by filetype only',
  group = lazyLoadEmmetPluginGroup,
  pattern = { 'html', 'blade', 'php', 'vue', 'javascriptreact', 'typescriptreact' },

  callback = function()
    if not loaded then
      vim.cmd('packadd emmet-vim')
      loaded = true
    end

    vim.cmd('EmmetInstall')
  end,
})
