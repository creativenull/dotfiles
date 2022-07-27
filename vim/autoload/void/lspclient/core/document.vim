vim9script

# Handle document synchronization between the editor and the server
# this includes opening and closing the file, and modifying the file in
# buffer.

# interface Document {
#   filepath?: string;
#   filetype?: string;
#   version: number;
#   contents: string;
# }

import './protocol.vim' as proto
import './fs.vim'
import './log.vim'

# Notify LSP server on file/buffer open
export def NotifyDidOpen(ch: channel, document: dict<any>): void
  log.LogInfo(printf('Notify Open Document: (buffer: %s)', bufnr('%')))
  proto.NotifyAsync(ch, 'textDocument/didOpen', {
    textDocument: {
      uri: document.uri,
      languageId: document.filetype,
      version: document.version,
      text: document.contents,
    },
  })
enddef

# Notify LSP server on file/buffer change
export def NotifyDidChange(ch: channel, document: dict<any>): void
  proto.NotifyAsync(ch, 'textDocument/didChange', {
    textDocument: {
      version: document.version,
    },
    contentChanges: [ { text: document.contents } ],
  })
  log.LogInfo(printf('Notify Change Document: (buffer: %s)', bufnr('%')))
enddef

# Notify LSP server when a file/buffer is closed
export def NotifyDidClose(ch: channel, document: dict<any>): void
  proto.NotifyAsync(ch, 'textDocument/didClose', {
    textDocument: {
      uri: document.uri,
    },
  })
  log.LogInfo(printf('Notify Close Document: (buffer: %s)', bufnr('%')))
enddef

# WIP:
export def NotifyWillSave(ch: channel, document: dict<any>): void
  proto.NotifyAsync(ch, 'textDocument/willSave', {
    textDocument: {
      uri: document.uri,
    },
    reason: 1, # Manually
  })
  log.LogInfo(printf('Notify WillSave Document: (buffer: %s)', bufnr('%')))
enddef

# WIP:
export def NotifyDidSave(ch: channel, document: dict<any>): void
  proto.NotifyAsync(ch, 'textDocument/didSave', {
    textDocument: {
      uri: document.uri,
    },
  })
  log.LogInfo(printf('Notify WillSave Document: (buffer: %s)', bufnr('%')))
enddef
