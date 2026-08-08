import type { ChildProcess } from 'node:child_process'
import type { Diagnostic, ProtocolConnection } from 'vscode-languageserver-protocol/node'
import type { LspServerConfig } from './types.js'
import { spawn } from 'node:child_process'
import { basename } from 'node:path'
import process from 'node:process'
import { pathToFileURL } from 'node:url'
import {
  createProtocolConnection,

  DidChangeTextDocumentNotification,
  DidCloseTextDocumentNotification,
  DidOpenTextDocumentNotification,
  ExitNotification,
  InitializedNotification,
  InitializeRequest,

  PublishDiagnosticsNotification,
  ShutdownRequest,
} from 'vscode-languageserver-protocol/node'

export class LspClient {
  readonly name: string
  readonly config: LspServerConfig
  status: 'starting' | 'ready' | 'error' | 'shutdown' = 'starting'
  error?: string

  private proc!: ChildProcess
  private connection!: ProtocolConnection
  private diagnostics = new Map<string, Diagnostic[]>()
  private openFiles = new Set<string>()
  private fileVersions = new Map<string, number>()
  private fileContents = new Map<string, string>()
  private diagnosticWaiters = new Map<string, Array<(diags: Diagnostic[]) => void>>()

  constructor(name: string, config: LspServerConfig) {
    this.name = name
    this.config = config
  }

  async initialize(rootPath: string): Promise<void> {
    const env: Record<string, string> = {}
    for (const [key, value] of Object.entries(process.env)) {
      if (value !== undefined)
        env[key] = value
    }
    if (this.config.env) {
      Object.assign(env, this.config.env)
    }

    this.proc = spawn(this.config.command, this.config.args ?? [], {
      env,
      stdio: ['pipe', 'pipe', 'pipe'],
    })

    this.connection = createProtocolConnection(this.proc.stdout!, this.proc.stdin!)

    this.connection.onNotification(PublishDiagnosticsNotification.type, (params) => {
      this.handleDiagnostics(params.uri, params.diagnostics)
    })

    this.connection.onRequest('workspace/configuration', (params: { items: unknown[] }) => {
      return params.items.map(() => null)
    })

    this.connection.onRequest('window/workDoneProgress/create', () => null)
    this.connection.onRequest('client/registerCapability', () => null)
    this.connection.onRequest('client/unregisterCapability', () => null)
    this.connection.onRequest('window/showMessageRequest', () => null)

    this.proc.on('exit', (code) => {
      if (this.status !== 'shutdown') {
        this.status = 'error'
        this.error = `Process exited with code ${code}`
      }
    })

    this.connection.listen()

    const rootUri = pathToFileURL(rootPath).href
    const initParams: any = {
      processId: process.pid,
      rootUri,
      capabilities: {
        textDocument: {
          publishDiagnostics: { relatedInformation: false },
        },
      },
      workspaceFolders: [{ uri: rootUri, name: basename(rootPath) }],
    }

    if (this.config.initializationOptions) {
      initParams.initializationOptions = this.config.initializationOptions
    }

    await this.connection.sendRequest(InitializeRequest.type, initParams)
    this.connection.sendNotification(InitializedNotification.type, {})
    this.status = 'ready'
  }

  async openDocument(uri: string, languageId: string, text: string): Promise<void> {
    const version = 1
    this.fileVersions.set(uri, version)
    this.fileContents.set(uri, text)
    this.openFiles.add(uri)

    this.connection.sendNotification(DidOpenTextDocumentNotification.type, {
      textDocument: { uri, languageId, version, text },
    })
  }

  async changeDocument(uri: string, text: string): Promise<void> {
    const version = (this.fileVersions.get(uri) ?? 0) + 1
    this.fileVersions.set(uri, version)
    this.fileContents.set(uri, text)

    this.connection.sendNotification(DidChangeTextDocumentNotification.type, {
      textDocument: { uri, version },
      contentChanges: [{ text }],
    })
  }

  async closeDocument(uri: string): Promise<void> {
    this.openFiles.delete(uri)
    this.fileVersions.delete(uri)
    this.fileContents.delete(uri)

    if (this.status === 'ready') {
      this.connection.sendNotification(DidCloseTextDocumentNotification.type, {
        textDocument: { uri },
      })
    }
  }

  getDiagnostics(uri: string): Diagnostic[] {
    return this.diagnostics.get(uri) ?? []
  }

  async waitForDiagnostics(uri: string, timeoutMs = 3000): Promise<Diagnostic[]> {
    return new Promise<Diagnostic[]>((resolve) => {
      let settled = false
      let timer: ReturnType<typeof setTimeout>
      let callback: (diags: Diagnostic[]) => void

      const settle = (diags: Diagnostic[]): void => {
        if (settled)
          return
        settled = true
        clearTimeout(timer)

        const waiters = this.diagnosticWaiters.get(uri)
        if (waiters) {
          const idx = waiters.indexOf(callback)
          if (idx >= 0)
            waiters.splice(idx, 1)
          if (waiters.length === 0)
            this.diagnosticWaiters.delete(uri)
        }

        resolve(diags)
      }

      callback = (diags: Diagnostic[]): void => settle(diags)
      timer = setTimeout(() => settle(this.getDiagnostics(uri)), timeoutMs)

      if (!this.diagnosticWaiters.has(uri)) {
        this.diagnosticWaiters.set(uri, [])
      }
      this.diagnosticWaiters.get(uri)!.push(callback)
    })
  }

  isFileOpen(uri: string): boolean {
    return this.openFiles.has(uri)
  }

  getLastContent(uri: string): string | undefined {
    return this.fileContents.get(uri)
  }

  async shutdown(): Promise<void> {
    if (this.status === 'shutdown')
      return

    try {
      await this.connection.sendRequest(ShutdownRequest.type)
      this.connection.sendNotification(ExitNotification.type)
    }
    catch {
      // ignore
    }

    this.connection.dispose()
    if (!this.proc.killed)
      this.proc.kill()
    this.status = 'shutdown'
  }

  private handleDiagnostics(uri: string, diagnostics: Diagnostic[]): void {
    this.diagnostics.set(uri, diagnostics)

    const waiters = this.diagnosticWaiters.get(uri)
    if (waiters && waiters.length > 0) {
      this.diagnosticWaiters.delete(uri)
      for (const resolve of waiters) {
        resolve(diagnostics)
      }
    }
  }
}
