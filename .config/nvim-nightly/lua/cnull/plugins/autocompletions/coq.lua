local augroup = require('cnull.core.event').augroup

vim.g.coq_settings = {
  ['auto_start'] = false,
  ['keymap.recommended'] = false,
  ['keymap.jump_to_mark'] = '<C-j>',
  ['clients.tmux.enabled'] = false,
  ['clients.tree_sitter.enabled'] = false,
  ['clients.tags.enabled'] = false,
  ['display.preview.positions'] = {
    east = 1,
    north = 3,
    south = 4,
    west = 2,
  },
}

augroup('coq_user_events', {
  {
    event = 'FileType',
    exec = function()
      vim.cmd('packadd coq_nvim')
      vim.cmd('packadd coq.artifacts')
      vim.cmd('COQnow')
    end,
  },
})

