" =============================================================================
" Filename: autoload/lightline/colorscheme/onedarkpro.vim
" Author: Arnold Chand
" License: MIT License
"
" let s:p.{mode}.{where} = [ [ {guifg}, {guibg}, {ctermfg}, {ctermbg} ], ... ]
" =============================================================================

let s:colors = luaeval('require"onedarkpro".get_colors(vim.g.onedarkpro_theme)')

let s:p = {}

let s:p.normal = {}
let s:p.normal.left = [ [s:colors.bg, s:colors.green], [s:colors.green, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline] ]
let s:p.normal.middle = [ ['NONE', 'NONE'] ]
let s:p.normal.right = [ [s:colors.bg, s:colors.green], [s:colors.green, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline] ]
let s:p.normal.error = [ [s:colors.bg, s:colors.red] ]
let s:p.normal.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.insert = {}
let s:p.insert.left = [ [s:colors.bg, s:colors.blue], [s:colors.blue, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline] ]
let s:p.insert.middle = [ ['NONE', 'NONE'] ]
let s:p.insert.right = [ [s:colors.bg, s:colors.blue], [s:colors.blue, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.insert.error = [ [s:colors.bg, s:colors.red] ]
let s:p.insert.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.command = {}
let s:p.command.left = [ [s:colors.bg, s:colors.purple], [s:colors.purple, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.command.middle = [ ['NONE', 'NONE'] ]
let s:p.command.right = [ [s:colors.bg, s:colors.purple], [s:colors.purple, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.command.error = [ [s:colors.bg, s:colors.red] ]
let s:p.command.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.visual = {}
let s:p.visual.left = [ [s:colors.bg, s:colors.yellow], [s:colors.yellow, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.visual.middle = [ ['NONE', 'NONE'] ]
let s:p.visual.right = [ [s:colors.bg, s:colors.yellow], [s:colors.yellow, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.visual.error = [ [s:colors.bg, s:colors.red] ]
let s:p.visual.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.replace = {}
let s:p.replace.left = [ [s:colors.bg, s:colors.red], [s:colors.red, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.replace.middle = [ ['NONE', 'NONE'] ]
let s:p.replace.right = [ [s:colors.bg, s:colors.red], [s:colors.red, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.replace.error = [ [s:colors.bg, s:colors.red] ]
let s:p.replace.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.replace = {}
let s:p.replace.left = [ [s:colors.bg, s:colors.red], [s:colors.red, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.replace.middle = [ ['NONE', 'NONE'] ]
let s:p.replace.right = [ [s:colors.bg, s:colors.red], [s:colors.red, s:colors.fg_gutter], [s:colors.fg, s:colors.bg_statusline]  ]
let s:p.replace.error = [ [s:colors.bg, s:colors.red] ]
let s:p.replace.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.inactive = {}
let s:p.inactive.left = [ [s:colors.blue, s:colors.color_column], [s:colors.fg_gutter, s:colors.color_column], [s:colors.fg_gutter, s:colors.color_column] ]
let s:p.inactive.middle = [ ['NONE', 'NONE'] ]
let s:p.inactive.right = [ [s:colors.blue, s:colors.color_column], [s:colors.fg_gutter, s:colors.color_column], [s:colors.fg_gutter, s:colors.color_column] ]
let s:p.inactive.error = [ [s:colors.bg, s:colors.red] ]
let s:p.inactive.warning = [ [s:colors.bg, s:colors.yellow] ]

let s:p.tabline = {}
let s:p.tabline.tabsel = [ [s:colors.bg, s:colors.purple] ]
let s:p.tabline.left = [ [s:colors.fg, s:colors.bg] ]
let s:p.tabline.middle = [ ['NONE', 'NONE'] ]
let s:p.tabline.right = [ [s:colors.green, s:colors.fg_gutter] ]

let g:lightline#colorscheme#onedarkpro#palette = lightline#colorscheme#fill(s:p)
