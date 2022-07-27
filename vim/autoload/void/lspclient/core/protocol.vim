vim9script

# The generic protocal to be used by the LSP client to send messages to the LSP
# server, whether it's sync or async for Requests, Notifications and Responses
# back to the server.

import './log.vim'

# Send a sync request to the LSP server
export def Request(ch: channel, method: string, params = null_dict): dict<any>
  if ch->ch_status() != 'open'
    throw log.Error('Channel not open')
  endif

  const request = { method: method, params: params }
  const chOpts = { timeout: 500 }

  return ch->ch_evalexpr(request, chOpts)
enddef

# Send an async requet to the LSP server
export def RequestAsync(ch: channel, method: string, params = null_dict, callback = null_function): void
  if ch->ch_status() != 'open'
    throw log.Error('Channel not open')
  endif

  const request = { method: method, params: params }
  const chOpts = { callback: callback }

  ch->ch_sendexpr(request, chOpts)
enddef

# Send a notification request to the LSP server
export def NotifyAsync(ch: channel, method: string, params = null_dict): void
  if ch->ch_status() != 'open'
    throw log.Error('Channel not open')
  endif

  const request = { method: method, params: params }
  ch->ch_sendexpr(request)
enddef

# Handle generic response back to LSP server
# Request ID is a requirement
# Result and Error are optional
export def ReponseAsync(ch: channel, requestId: number, result = null_dict, error = null_dict): void
  const response = { id: requestId, result: result, error: error }
  ch->ch_sendexpr(response)
enddef
