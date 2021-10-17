-- bufferline.lua Config
-- ---
require('bufferline').setup({
  options = {
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
})

-- nvim-colorizer.lua Config
-- ---
require('colorizer').setup({ 'css', 'html', 'javascriptreact', 'typescriptreact', 'vim' })
