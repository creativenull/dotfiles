vim9script

import './core/protocol.vim' as proto
import './core/log.vim'
import './features/workspace/configuration.vim'

export def HandleServerRequest(ch: channel, request: any, setupConfig: dict<any>): void
  if request.method == 'workspace/configuration'
    configuration.HandleConfigurationRequest(ch, request, setupConfig)
  endif

  if request.method == 'client/registerCapability'
    log.LogInfo('STDOUT : Request ' .. request->string())
  endif
enddef
