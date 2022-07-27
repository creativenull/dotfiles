vim9script

# Base functions to initialize and shutdown the LSP client

import './protocol.vim' as proto
import './fs.vim'
import './log.vim'

const locale = 'en-US'
const clientInfo = { name: 'Vim', version: v:versionlong->string() }

def MakeClientCapabilities(partialCapabilities = null_dict): dict<any>
  const capabilities = {
    workspace: {
      didChangeConfiguration: {
        dynamicRegistration: true,
      },
      configuration: true,
    },
  }

  return extendnew(capabilities, partialCapabilities, 'force')
enddef

# Request intialization of the client to the server
export def Initialize(ch: channel, initializationOptions = {}, capabilities = {}): dict<any>
  var errmsg = ''
  const clientCapabilities = MakeClientCapabilities(capabilities)
  const response = proto.Request(ch, 'initialize', {
    processId: getpid(),
    locale: locale,
    clientInfo: clientInfo,
    rootUri: fs.GetProjectRootUri(),
    trace: 'off',
    initializationOptions: initializationOptions,
    capabilities: clientCapabilities,
  })

  if response->empty()
    errmsg = 'Empty Response'
    log.LogError(errmsg)

    throw log.Error(errmsg)
  endif

  if response->has_key('error')
    errmsg = response.error->string()
    log.LogError(errmsg)

    throw log.Error(errmsg)
  endif

  log.LogInfo('LSP Issue Initialize with capabilities: ' .. clientCapabilities->string() .. '; initOptions: ' .. initializationOptions->string())

  return response
enddef

# Notify the server when client has initialized
export def Initialized(ch: channel): void
  proto.NotifyAsync(ch, 'initialized')
  log.LogInfo('LSP Initialized!')
enddef

# Request a client shutdown to the server
export def Shutdown(ch: channel): dict<any>
  const response = proto.Request(ch, 'shutdown')

  if response->empty()
    throw log.Error('Empty Response')
  endif

  if response->has_key('error')
    throw log.Error(response.error)
  endif

  log.LogInfo('LSP Issue Shutdown')

  return response
enddef

# Notify the server when the client has exited
export def Exit(ch: channel): void
  proto.SendNotifAsync(ch, 'exit')
  log.LogInfo('LSP Exit')
enddef
