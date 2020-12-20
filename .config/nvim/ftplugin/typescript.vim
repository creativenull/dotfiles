let b:ale_linters = ['eslint', 'tsserver']

call deoplete#enable()
call SetLspKeymaps()
setlocal omnifunc=ale#completion#OmniFunc
