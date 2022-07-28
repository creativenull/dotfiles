vim9script

import './lspclient/core/client.vim'
import './lspclient/core/document.vim'
import './lspclient/core/fs.vim'
import './lspclient/core/log.vim'
import './lspclient/router.vim'
import './lspclient/config.vim'

const openBufEvents = ['BufRead']
const closeBufEvents = ['BufDelete']

var lspClients = {}

def HasStarted(ch: channel): bool
  return ch->ch_status() == 'open'
enddef

export def DocumentDidChange(id: string, buf: number): void
  if buf->getbufvar('&modified')
    document.NotifyDidChange(lspClients[id].channel, {
      uri: fs.FileToUri(buf->bufname()),
      version: buf->getbufvar('changedtick'),
      contents: fs.GetBufferContents(buf),
    })
  endif
enddef

export def DocumentDidOpen(id: string): void
  const b = bufnr('%')

  const ft = b->getbufvar('&filetype')
  const isFileType = lspClients[id].config.filetypes->index(ft) != -1
  if isFileType
    document.NotifyDidOpen(lspClients[id].channel, {
      uri: fs.FileToUri(b->bufname()),
      filetype: ft,
      version: b->getbufvar('changedtick'),
      contents: fs.GetBufferContents(b),
    })

    # Subscribe to buffer changes
    def OnChange(bufnr: number, start: any, end: any, added: any, changes: any)
      DocumentDidChange(id, bufnr)
    enddef

    const ref = listener_add(OnChange, b)

    # Track this document lifecycle, include any other refs
    lspClients[id].documents->add({ bufnr: b, listenerRef: ref })

    # Register for cleanup
    autocmd_add([
      {
        group: lspClients[id].group,
        event: closeBufEvents,
        bufnr: b,
        cmd: printf('call void#lspclient#DocumentDidClose("%s", %d)', id, b)
      },
    ])
  endif
enddef

export def DocumentDidClose(id: string, buf: number): void
  const [doc] = filter(copy(lspClients[id].documents), (i, val) => val.bufnr == buf)

  # Unsubscribe from changes and events
  listener_remove(doc.listenerRef)
  autocmd_delete([
    {
      group: lspClients[id].group,
      event: closeBufEvents,
      bufnr: buf,
    },
  ])
  
  document.NotifyDidClose(lspClients[id].channel, { uri: fs.FileToUri(buf->bufname()) })
enddef

export def LspStartServer(id: string): void
  if HasStarted(lspClients[id].channel)
    return
  endif

  # Notify the server that the client has initialized once
  # the response provides no errors
  def OnInitialize(ch: channel, response: dict<any>): void
    var errmsg = ''

    if response->empty()
      errmsg = 'Empty Response'
      log.LogError(errmsg)

      return
    endif

    if response->has_key('error')
      errmsg = response.error->string()
      log.LogError(errmsg)

      return
    endif

    client.Initialized(ch)

    # Open the current document
    DocumentDidOpen(id)

    # Let future buffers know about the open document event
    autocmd_add([
      {
        group: lspClients[id].group,
        event: openBufEvents,
        pattern: '*',
        cmd: printf('call void#lspclient#DocumentDidOpen("%s")', id),
      },
    ])
  enddef

  def OnStdout(ch: channel, request: dict<any>): void
    log.LogInfo('STDOUT : ' .. request->string())
    router.HandleServerRequest(ch, request, lspClients[id].config)
  enddef

  def OnStderr(ch: channel, data: any): void
    log.LogError('STDERR : ' .. data->string())
  enddef

  def OnExit(ch: channel, data: any): void
    log.LogInfo('Channel Exiting')
  enddef

  const jobOpts = {
    in_mode: 'lsp',
    out_mode: 'lsp',
    err_mode: 'nl',
    out_cb: OnStdout,
    err_cb: OnStderr,
    exit_cb: OnExit,
  }

  log.PrintInfo('Starting LSP Server: ' .. lspClients[id].config.name)

  lspClients[id].job = job_start(lspClients[id].config.cmd, jobOpts)
  lspClients[id].channel = job_getchannel(lspClients[id].job)

  # Start the initialization process
  log.LogInfo('<======= VOID LSP CLIENT LOG =======>')
  client.Initialize(lspClients[id].channel, {
    lspClientConfig: lspClients[id].config,
    callback: OnInitialize,
  })
enddef

export def LspStopServer(id: string): void
  if !HasStarted(lspClients[id].channel)
    return
  endif

  log.LogInfo('<======= VOID LSP CLIENT SHUTDOWN PHASE =======>')
  client.Shutdown(lspClients[id].channel)
enddef

export def MakeLspClient(partialLspClientConfig: dict<any>): void
  # Merge and validate the client config and fail the setup
  # if invalidated
  const lspClientConfig = config.MergeLspClientConfig(partialLspClientConfig)

  const errmsg = config.ValidateLspClientConfig(lspClientConfig)
  if !errmsg->empty()
    log.PrintError(errmsg)
    log.LogError(errmsg)

    return
  endif

  const id = lspClientConfig.name
  var lspClient = {
    id: id,
    group: printf('VoidLspClient_%s', id),
    config: lspClientConfig,
    job: null_job,
    channel: null_channel,
    documents: [],
  }

  # Add to a 'global' state
  lspClients[id] = lspClient

  execute printf('augroup %s', lspClients[id].group)
  autocmd_add([
    {
      group: lspClients[id].group,
      event: 'FileType',
      pattern: lspClients[id].config.filetypes,
      cmd: printf('call void#lspclient#LspStartServer("%s")', id),
    },
    {
      group: lspClients[id].group,
      event: 'VimLeavePre',
      pattern: '*',
      cmd: printf('call void#lspclient#LspStopServer("%s")', id),
    },
  ])
enddef
