function! transparency#setHighlights() abort
  " Core highlights to make transparent
  highlight Normal guibg=NONE
  highlight SignColumn guibg=NONE
  highlight LineNr guibg=NONE guifg=#888888
  highlight CursorLineNr guibg=NONE
  highlight EndOfBuffer guibg=NONE
  highlight Visual guibg=#555555

  " Sometimes comments are too dark, affects in tranparent mode
  highlight Comment guifg=#888888

  " Tabline
  highlight TabLineFill guibg=NONE
  highlight TabLine guibg=NONE

  " Float Border
  highlight NormalFloat guibg=NONE
  highlight FloatBorder guibg=NONE guifg=#eeeeee

  " Vertical Line
  highlight ColorColumn guibg=#999999

  " LSP Diagnostics
  highlight ErrorFloat guibg=NONE
  highlight WarningFloat guibg=NONE
  highlight InfoFloat guibg=NONE
  highlight HintFloat guibg=NONE
endfunction
