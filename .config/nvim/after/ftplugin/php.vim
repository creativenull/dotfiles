let b:ale_linters = ['intelephense', 'phpcs', 'phpstan', 'php']
call deoplete#enable()
call SetLspKeymaps()
setlocal omnifunc=ale#completion#OmniFunc
