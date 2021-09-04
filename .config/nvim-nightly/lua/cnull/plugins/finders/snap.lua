local snap = require('snap')

local file = snap.config.file:with({ reverse = true, suffix = ' >', consumer = 'fzy' })
local vimgrep = snap.config.vimgrep:with({ reverse = true, suffix = ' >', limit = 50000 })
snap.maps({
  {'<C-p>', file({ producer = 'ripgrep.file' })},
  {'<C-t>', vimgrep({})},
})
