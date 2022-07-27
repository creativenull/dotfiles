vim9script

import './lspclient/core/protocol.vim' as proto
import './lspclient/core/client.vim'
import './lspclient/core/document_sync.vim'
import './lspclient/core/log.vim'
import './lspclient/core/fs.vim'
import './lspclient/router.vim'

# interface VimDocument {
#   buf: number;
#   version: number;
# }

# interface SetupConfig {
#   name: string;
#   cmd: List<string>;
#   filetypes: List<string>;
#   markers: List<string>;
#   initOptions?: Dict<any>;
#   config?: Dict<any>;
# }

var self = {
  job: null_job,
  channel: null_channel,
  clientEventGroup: 'VoidLspClientGroup',
}

def GetGroupName(name: string): string
  return printf('%s_%s', self.clientEventGroup, name)
enddef

def HasStarted(): bool
  return self.channel->ch_status() == 'open'
enddef

def MergeSetupConfig(partialSetupConfig: dict<any>): dict<any>
  const defaults = {
    initOptions: null_dict,
    settings: null_dict,
    markers: null_list,
  }

  return extendnew(defaults, partialSetupConfig, 'force')
enddef

def ValidateSetupConfig(setupConfig: dict<any>): void
  if setupConfig->get('name', '') == ''
    throw log.Error('`name` must be present')
  endif

  if setupConfig->get('cmd', []) == []
    throw log.Error('`cmd` must be present')
  endif

  if setupConfig->get('filetypes', []) == []
    throw log.Error('`filetypes` must be present')
  endif
enddef

def DocumentDidOpen(): number
  const b = bufnr('%')
  const documentOpts = {
    filepath: b->bufname(),
    filetype: b->getbufvar('&filetype'),
    version: changenr(),
    contents: fs.GetBufferContents(b),
  }

  document_sync.NotifyDidOpen(self.channel, documentOpts)

  return b
enddef

export def DocumentDidChange(): void
  if !HasStarted()
    return
  endif

  const b = bufnr('%')

  # Only notify of change when it has been modified
  if b->getbufvar('&modified')
    document_sync.NotifyDidChange(self.channel, {
      version: changenr(),
      contents: fs.GetBufferContents(b),
    })
  endif
enddef

export def DocumentDidClose(): void
  const b = bufnr('%')

  const documentChangeEvent = {
    event: 'InsertLeave',
    bufnr: b,
  }

  const documentCloseEvent = {
    event: ['BufUnload', 'BufWipeout'],
    bufnr: b,
  }

  autocmd_delete([documentChangeEvent, documentCloseEvent])

  document_sync.NotifyDidClose(self.channel, { filepath: bufname(b) })
enddef

export def StartLspServer(setupConfig: dict<any>): void
  if HasStarted()
    return
  endif

  def OnStdout(ch: channel, request: dict<any>): void
    log.LogInfo('STDOUT : ' .. request->string())
    router.HandleServerRequest(ch, request, setupConfig)
  enddef

  def OnStderr(ch: channel, msg: any): void
    log.LogError('STDERR : ' .. msg->string())
  enddef

  def OnExit(ch: channel, msg: any): void
    echom log.Info('Channel Exiting')
  enddef

  const group = GetGroupName(setupConfig.name)
  const opts = {
    in_mode: 'lsp',
    out_mode: 'lsp',
    err_mode: 'nl',
    out_cb: OnStdout,
    err_cb: OnStderr,
    exit_cb: OnExit,
  }

  log.PrintInfo('Starting LSP Server')

  self.job = job_start(setupConfig.cmd, opts)
  self.channel = job_getchannel(self.job)

  try
    log.LogInfo('=== VOID LSP CLIENT LOG ===')

    client.Initialize(self.channel, setupConfig.initOptions)
    client.Initialized(self.channel)

    # Let server know of open document
    const b = DocumentDidOpen()

    const documentChangeEvent = {
      group: group,
      event: 'InsertLeave',
      bufnr: b,
      cmd: 'call void#lspclient#DocumentDidChange()',
    }

    const documentCloseEvent = {
      group: group,
      event: ['BufUnload', 'BufWipeout'],
      bufnr: b,
      once: true,
      cmd: 'call void#lspclient#DocumentDidClose()',
    }

    autocmd_add([documentChangeEvent, documentCloseEvent])
  catch
    const msg = 'Failed to initialize LSP server with exception: ' .. v:exception->string()
    log.PrintError(msg)
  endtry
enddef

export def StopLspServer(setupConfig: dict<any>): void
  if !HasStarted()
    return
  endif

  try
    client.Shutdown(self.channel)
    client.Exit(self.channel)
  catch
    const msg = 'Failed to shutdown LSP server with exception: ' .. v:exception->string()
    log.PrintError(msg)
  endtry
enddef

export def Setup(partialSetupConfig: dict<any>): void
  const setupConfig = MergeSetupConfig(partialSetupConfig)
  try
    ValidateSetupConfig(setupConfig)
  catch
    echoerr v:exception
  endtry

  const group = GetGroupName(setupConfig.name)
  execute printf('augroup %s', group)

  const clientStartEvent = {
    group: group,
    event: 'FileType',
    pattern: setupConfig.filetypes,
    cmd: printf('call void#lspclient#StartLspServer(%s)', string(setupConfig)),
  }

  const clientStopEvent = {
    group: group,
    event: 'VimLeavePre',
    pattern: '*',
    cmd: printf('call void#lspclient#StopLspServer(%s)', string(setupConfig)),
  }

  autocmd_add([clientStartEvent, clientStopEvent])
enddef
