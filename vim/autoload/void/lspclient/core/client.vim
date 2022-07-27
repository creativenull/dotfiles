vim9script

# Base functions to initialize and shutdown the LSP client

import './protocol.vim'
import './fs.vim'
import './log.vim'

const locale = 'en-US'
const clientInfo = { name: 'Vim', version: v:versionlong->string() }

def MakeClientCapabilities(partialCapabilities = null_dict): dict<any>
  const defaults = {
    workspace: {
      applyEdit: true,
      didChangeConfiguration: {
        dynamicRegistration: false,
      },
      configuration: true,
    },
    textDocument: {
      synchronization: {
        dynamicRegistration: false,
        willSave: true,
        willSaveWaitUntil: true,
        didSave: true,
      },
    },
    window: {
      workDoneProgress: true,
    },
  }

  if partialCapabilities->empty()
    return defaults
  endif

  return defaults->extendnew(partialCapabilities)
enddef

# Request intialization of the client to the server
export def Initialize(
  ch: channel,
  opts = { lspClientConfig: null_dict, callback: null_function }
): void
  const capabilities = MakeClientCapabilities(opts.lspClientConfig.capabilities)
  const initializationOptions = opts.lspClientConfig.initOptions

  protocol.RequestAsync(ch, 'initialize', {
    processId: getpid(),
    locale: locale,
    clientInfo: clientInfo,
    rootUri: fs.GetProjectRootUri(),
    trace: 'verbose',
    initializationOptions: initializationOptions,
    capabilities: capabilities,
  }, opts.callback)

  log.LogInfo('LSP Issue Initialize with capabilities: ' .. capabilities->string())
  log.LogInfo('LSP Issue Initialize with initializationOptions: ' .. initializationOptions->string())
enddef

# Notify the server when client has initialized
export def Initialized(ch: channel): void
  protocol.NotifyAsync(ch, 'initialized')
  log.LogInfo('LSP Initialized!')
enddef

# Notify the server when the client has exited
def OnShutdown(ch: channel, response: dict<any>): void
  if response->empty()
    log.LogError('Empty Response')

    return
  endif

  if response->has_key('error')
    log.LogError(response.error)

    return
  endif

  protocol.NotifyAsync(ch, 'exit')
  log.LogInfo('LSP Exit')
enddef

# Request a client shutdown to the server
export def Shutdown(ch: channel): void
  protocol.RequestAsync(ch, 'shutdown', {}, OnShutdown)
  log.LogInfo('LSP Issue Shutdown')
enddef
