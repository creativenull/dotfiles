vim9script

# Install vim-packager if not installed. For first time setup only.
export def Bootstrap(): void
  const plugin = {
    name: 'vim-packager',
    base_dir: expand('~/.vim/pack/packager'),
    git: 'https://github.com/kristijanhusak/vim-packager.git',
    path: expand('~/.vim/pack/packager/opt/vim-packager'),
  }

  if !isdirectory(plugin.path)
    echo printf('Downloading %s plugin manager...', plugin.name)

    const gitcmd = ['git', 'clone', plugin.git, plugin.path]
    call system(gitcmd->join(' '))
  endif
enddef
