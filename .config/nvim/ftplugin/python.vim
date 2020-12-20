let b:ale_linters = ['pyls']

call deoplete#enable()
call SetLspKeymaps()
setlocal omnifunc=ale#completion#OmniFunc
