vim9script

import '../../core/log.vim'
import '../../core/protocol.vim'

export def HandleConfigurationRequest(ch: channel, request: any, setupConfig: dict<any>): void
  proto.ResponseAsync(ch, request.id, [setupConfig.config])
  log.LogInfo('STDOUT : Respond workspace/configuration: ' .. setupConfig.config->string())
enddef

export def NotifyDidChangeConfiguration(ch: channel, setupConfig: any): void
  proto.NotifyAsync(ch, 'workspace/didChangeConfiguration', { settings: setupConfig.config })
  log.LogInfo('Notify workspace/didChangeConfiguration: ' .. setupConfig.config->string())
enddef
