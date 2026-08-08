import type { DiagnosticsError, DiagnosticsResult, LspServerConfig } from './types.js'
import { readFile } from 'node:fs/promises'
import { extname } from 'node:path'
import { pathToFileURL } from 'node:url'
import { LspClient } from './lsp-client.js'

const EXTENSION_TO_LANGUAGE: Record<string, string> = {
  '.ts': 'typescript',
  '.tsx': 'typescriptreact',
  '.js': 'javascript',
  '.jsx': 'javascriptreact',
  '.mjs': 'javascript',
  '.cjs': 'javascript',
  '.mts': 'typescript',
  '.cts': 'typescript',
  '.py': 'python',
  '.pyi': 'python',
  '.lua': 'lua',
  '.rs': 'rust',
  '.go': 'go',
  '.java': 'java',
  '.kt': 'kotlin',
  '.kts': 'kotlin',
  '.scala': 'scala',
  '.c': 'c',
  '.h': 'c',
  '.cpp': 'cpp',
  '.hpp': 'cpp',
  '.cc': 'cpp',
  '.cs': 'csharp',
  '.rb': 'ruby',
  '.php': 'php',
  '.swift': 'swift',
  '.dart': 'dart',
  '.sh': 'shellscript',
  '.bash': 'shellscript',
  '.zsh': 'shellscript',
  '.html': 'html',
  '.htm': 'html',
  '.css': 'css',
  '.scss': 'scss',
  '.less': 'less',
  '.vue': 'vue',
  '.svelte': 'svelte',
  '.json': 'json',
  '.jsonc': 'json',
  '.yaml': 'yaml',
  '.yml': 'yaml',
  '.toml': 'toml',
  '.xml': 'xml',
  '.md': 'markdown',
  '.sql': 'sql',
  '.r': 'r',
  '.R': 'r',
  '.ex': 'elixir',
  '.exs': 'elixir',
  '.erl': 'erlang',
  '.hrl': 'erlang',
  '.hs': 'haskell',
  '.lhs': 'haskell',
  '.clj': 'clojure',
  '.cljs': 'clojure',
  '.zig': 'zig',
  '.nim': 'nim',
}

export class LspManager {
  private servers = new Map<string, LspClient>()
  private extensionMap = new Map<string, string>()

  async startAll(
    configs: Record<string, LspServerConfig>,
    rootPath: string,
  ): Promise<{ started: string[], failed: string[] }> {
    const started: string[] = []
    const failed: string[] = []

    for (const [name, config] of Object.entries(configs)) {
      if (config.disabled)
        continue

      try {
        const client = new LspClient(name, config)
        await client.initialize(rootPath)
        this.servers.set(name, client)

        for (const ext of config.extensions) {
          const normalized = ext.startsWith('.') ? ext : `.${ext}`
          this.extensionMap.set(normalized, name)
        }

        started.push(name)
      }
      catch (err) {
        failed.push(name)
        console.error(`Failed to start LSP server '${name}':`, err)
      }
    }

    return { started, failed }
  }

  async stopAll(): Promise<void> {
    const promises = Array.from(this.servers.values()).map(
      server => server.shutdown().catch(() => {}),
    )
    await Promise.all(promises)
    this.servers.clear()
    this.extensionMap.clear()
  }

  findServerForFile(filePath: string): LspClient | undefined {
    const ext = extname(filePath)
    const serverName = this.extensionMap.get(ext)
    if (!serverName)
      return undefined
    return this.servers.get(serverName)
  }

  async getDiagnosticsForFile(filePath: string): Promise<DiagnosticsResult | DiagnosticsError> {
    const server = this.findServerForFile(filePath)
    if (!server) {
      const ext = extname(filePath)
      return {
        error: ext
          ? `No LSP server configured for '${ext}' files`
          : `No LSP server configured for this file type`,
      }
    }

    if (server.status !== 'ready') {
      return { error: `LSP server '${server.name}' is not ready (${server.status}${server.error ? `: ${server.error}` : ''})` }
    }

    try {
      const text = await readFile(filePath, 'utf-8')
      const uri = pathToFileURL(filePath).href
      const ext = extname(filePath)
      const languageId = EXTENSION_TO_LANGUAGE[ext] ?? 'plaintext'

      if (!server.isFileOpen(uri)) {
        const diagPromise = server.waitForDiagnostics(uri)
        await server.openDocument(uri, languageId, text)
        const diagnostics = await diagPromise
        return { server: server.name, filePath, diagnostics }
      }

      const lastContent = server.getLastContent(uri)
      if (lastContent !== text) {
        const diagPromise = server.waitForDiagnostics(uri)
        await server.changeDocument(uri, text)
        const diagnostics = await diagPromise
        return { server: server.name, filePath, diagnostics }
      }

      return {
        server: server.name,
        filePath,
        diagnostics: server.getDiagnostics(uri),
      }
    }
    catch (err) {
      const message = err instanceof Error ? err.message : String(err)
      return { error: `Failed to get diagnostics: ${message}` }
    }
  }

  getAll(): LspClient[] {
    return Array.from(this.servers.values())
  }

  get(name: string): LspClient | undefined {
    return this.servers.get(name)
  }
}
