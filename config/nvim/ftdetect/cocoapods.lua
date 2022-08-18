-- Ref: https://github.com/jvirtanen/vim-cocoapods
vim.filetype.add({
	extension = { podspec = 'ruby' },
	filename = { ['Podfile'] = 'ruby' },
})
