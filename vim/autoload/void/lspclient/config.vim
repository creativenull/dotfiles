vim9script

# interface LspClientConfig {
#   name: string;
#   cmd: list<string>;
#   filetypes: list<string>;
#   markers: list<string>;
#   initOptions?: dict<any>;
#   capabilities?: dict<any>;
#   config?: dict<any>;
# }

export def MergeLspClientConfig(partialLspClientConfig: dict<any>): dict<any>
  const defaults = {
    initOptions: null_dict,
    capabilities: null_dict,
    settings: null_dict,
    markers: null_list,
  }

  return defaults->extendnew(partialLspClientConfig)
enddef

export def ValidateLspClientConfig(lspClientConfig: dict<any>): string
  var errlist = []

  if lspClientConfig->get('name', '') == ''
    errlist->add('name')
  endif

  if lspClientConfig->get('cmd', []) == []
    errlist->add('cmd')
  endif

  if lspClientConfig->get('filetypes', []) == []
    errlist->add('filetypes')
  endif

  if !errlist->empty()
    return 'Missing arguments: ' .. errlist->join(',')
  endif

  return ''
enddef
