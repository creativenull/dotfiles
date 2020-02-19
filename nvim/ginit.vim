" =============================================================
" Arnold Chand
" (neo)vim GUI config file
" Cross-platform, runs on Linux, Windows and OS X (maybe?)
" https://github.com/creativenobu
" =============================================================

if exists('g:GuiLoaded')
    Guifont! JetBrainsMono Nerd Font:h10.5
    GuiTabline 0
    GuiPopupmenu 0
endif

" Disable transparent bg
hi Normal ctermbg=NONE guibg=#282828
