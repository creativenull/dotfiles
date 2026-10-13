import type { Diagnostic } from 'vscode-languageserver-protocol'

export interface LspServerConfig {
  command: string
  args?: string[]
  extensions: string[]
  env?: Record<string, string>
  initializationOptions?: Record<string, unknown>
  disabled?: boolean
}

export interface LspConfig {
  lspServers?: Record<string, LspServerConfig>
}

export interface DiagnosticsResult {
  server: string
  filePath: string
  diagnostics: Diagnostic[]
}

export interface DiagnosticsError {
  error: string
}

export interface LspSessionState {
  servers: string[]
  timestamp: number
}
