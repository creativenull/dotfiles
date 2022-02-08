" =============================================================================
" Filename: autoload/lightline/colorscheme/tailwind_cnull.vim
" Author: Arnold Chand
" License: MIT License
" =============================================================================

" Colors
let s:light = '#f1f5f9'
let s:dark = '#111827'
let s:softlight = '#cbd5e1'
let s:softdark = '#334155'

let s:text_light = s:light
let s:text_dark = s:dark
let s:text_softlight = s:softlight
let s:text_softdark = s:softdark

let s:bg_light = s:light
let s:bg_dark = s:dark
let s:bg_softlight = s:softlight
let s:bg_softdark = s:softdark

let s:primary = '#0369a1'
let s:indigo = '#4f46e5'
let s:gray = '#1f2937'
let s:darkgray = '#111827'

let s:error = '#881337'
let s:warn = '#c2410c'

" Defaults
let s:middle_section = [ ['NONE', s:dark] ]
let s:right_section = reverse([ [s:text_light, s:darkgray], [s:text_light, s:gray], [s:text_light, s:indigo] ])

" Diagnostics
let s:error_section = [ [s:text_softlight, s:error] ]
let s:warn_section = [ [s:text_softlight, s:warn] ]

" Base
let s:p = {}

" Modes
let s:p.normal = {}
let s:p.normal.left = [ [s:text_softlight, s:primary], [s:text_softlight, s:darkgray] ]
let s:p.normal.middle = s:middle_section
let s:p.normal.right = s:right_section
let s:p.normal.error = s:error_section
let s:p.normal.warn = s:warn_section

let s:insert_primary = '#0c4a6e'
let s:p.insert = {}
let s:p.insert.left = [ [s:text_softlight, s:insert_primary], [s:text_softlight, s:darkgray] ]
let s:p.insert.middle = [ ['NONE', s:insert_primary] ]
let s:p.insert.right = s:right_section

let s:visual_primary = '#92400e'
let s:p.visual = {}
let s:p.visual.left = [ [s:text_softlight, s:visual_primary], [s:text_softlight, s:darkgray] ]
let s:p.visual.middle = [ ['NONE', s:visual_primary] ]
let s:p.visual.right = s:right_section

let s:command_primary = '#94a3b8'
let s:p.command = {}
let s:p.command.left = [ [s:text_softdark, s:command_primary], [s:text_softlight, s:darkgray] ]
let s:p.command.middle = [ ['NONE', s:command_primary] ]
let s:p.command.right = s:right_section

let s:replace_primary = '#94a3b8'
let s:p.replace = {}
let s:p.replace.left = [ [s:text_softlight, s:replace_primary], [s:text_softlight, s:darkgray] ]
let s:p.replace.middle = s:middle_section
let s:p.replace.right = s:right_section

" Inactive
let s:p.inactive = {}
let s:p.inactive.left = [ [s:text_softlight, s:bg_softdark], [s:text_softlight, s:bg_softdark], [s:text_softlight, s:bg_softdark] ]
let s:p.inactive.middle = s:middle_section
let s:p.inactive.right = [ [s:text_softlight, s:bg_softdark], [s:text_softlight, s:bg_softdark], [s:text_softlight, s:bg_softdark] ]

" Tabline
let s:p.tabline = {}
let s:p.tabline.tabsel = [ [s:text_softdark, s:bg_softlight] ]
let s:p.tabline.left = [ [s:text_softlight, s:bg_softdark] ]
let s:p.tabline.right = [ [s:text_softlight, s:bg_softdark] ]

" Register
let g:lightline#colorscheme#tailwind_cnull#palette = lightline#colorscheme#fill(s:p)
