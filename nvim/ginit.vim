" =============================================================
" Arnold Chand
" (neo)vim GUI config file
" Cross-platform, runs on Linux, Windows and OS X (maybe?)
" https://github.com/creativenobu
" =============================================================

" neovim-qt config
if exists('g:GuiLoaded')
    set linespace=2

    GuiFont! JetBrainsMono Nerd Font:h11
    GuiTabline 0
    GuiPopupmenu 0
endif

" FVIM config
if exists('g:fvim_loaded')
    set guifont=JetBrainsMono\ Nerd\ Font:h15
    set linespace=2

    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:false

    FVimFontLigature v:false
    FVimFontAntialias v:true
    FVimFontLcdRender v:false

    FVimUIPopupMenu v:false
endif
