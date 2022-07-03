vim9script
# =============================================================================
# Filename: autoload/lightline/colorscheme/tailwind_cnull.vim
# Author: Arnold Chand
# License: MIT License
# =============================================================================

# Colors
const light = '#f1f5f9'
const dark = '#111827'
const softlight = '#cbd5e1'
const softdark = '#334155'

const text_light = light
const text_dark = dark
const text_softlight = softlight
const text_softdark = softdark

const bg_light = light
const bg_dark = dark
const bg_softlight = softlight
const bg_softdark = softdark

const primary = '#0369a1'
const indigo = '#4f46e5'
const gray = '#1f2937'
const darkgray = '#111827'

const error = '#881337'
const warn = '#c2410c'

# Defaults
const middle_section = [ ['NONE', dark] ]
const right_section = reverse([ [text_light, darkgray], [text_light, gray], [text_light, indigo] ])

# Diagnostics
const error_section = [ [text_softlight, error] ]
const warn_section = [ [text_softlight, warn] ]

# Base
const insert_primary = '#0c4a6e'
const visual_primary = '#92400e'
const command_primary = '#94a3b8'
const replace_primary = '#94a3b8'

const p = {
  normal: {
    left: [ [text_softlight, primary], [text_softlight, darkgray] ],
    middle: middle_section,
    right: right_section,
    error: error_section,
    warn: warn_section,
  },

  insert: {
    left: [ [text_softlight, insert_primary], [text_softlight, darkgray] ],
    middle: [ ['NONE', insert_primary] ],
    right: right_section,
  },

  visual: {
    left: [ [text_softlight, visual_primary], [text_softlight, darkgray] ],
    middle: [ ['NONE', visual_primary] ],
    right: right_section,
  },

  command: {
    left: [ [text_softdark, command_primary], [text_softlight, darkgray] ],
    middle: [ ['NONE', command_primary] ],
    right: right_section,
  },

  replace: {
    left: [ [text_softlight, replace_primary], [text_softlight, darkgray] ],
    middle: middle_section,
    right: right_section,
  },

  # Inactive
  inactive: {
    left: [ [text_softlight, bg_softdark], [text_softlight, bg_softdark], [text_softlight, bg_softdark] ],
    middle: middle_section,
    right: [ [text_softlight, bg_softdark], [text_softlight, bg_softdark], [text_softlight, bg_softdark] ],
  },

  # Tabline
  tabline: {
    tabsel: [ [text_softdark, bg_softlight] ],
    left: [ [text_softlight, bg_softdark] ],
    right: [ [text_softlight, bg_softdark] ],
  },
}

# Register
g:lightline#colorscheme#tailwind_cnull#palette = lightline#colorscheme#fill(p->deepcopy())
