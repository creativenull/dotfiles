import type { ExtensionAPI, ExtensionContext } from '@earendil-works/pi-coding-agent'
import type { LspSessionState } from './types.js'
import { loadLspConfig, validateLspServerConfig } from './config.js'
import { LspManager } from './lsp-manager.js'
import { registerLspTools } from './tools.js'

const STATUS_ID = 'lsp-status'

export default function lspExtension(pi: ExtensionAPI): void {
  const manager = new LspManager()

  function updateStatus(ctx: ExtensionContext): void {
    const servers = manager.getAll()
    const ready = servers.filter(s => s.status === 'ready').length
    const total = servers.length

    if (total === 0) {
      ctx.ui.setStatus(STATUS_ID, undefined)
      return
    }

    const statusText = ready === total
      ? `LSP: ${ready} server${ready !== 1 ? 's' : ''} ready`
      : `LSP: ${ready}/${total} ready`

    ctx.ui.setStatus(STATUS_ID, ctx.ui.theme.fg('accent', statusText))
  }

  async function startAll(ctx: ExtensionContext): Promise<{ started: string[], failed: string[], skipped: string[] }> {
    const config = await loadLspConfig(ctx.cwd)
    const lspConfigs = config.lspServers ?? {}
    const failed: string[] = []
    const skipped: string[] = []

    for (const [name, serverConfig] of Object.entries(lspConfigs)) {
      if (serverConfig.disabled) {
        skipped.push(name)
        continue
      }

      const error = validateLspServerConfig(name, serverConfig)
      if (error) {
        console.error(error)
        failed.push(name)
        continue
      }
    }

    const result = await manager.startAll(lspConfigs, ctx.cwd)
    return { ...result, skipped }
  }

  function persistState(): void {
    const servers = manager.getAll()
    pi.appendEntry<LspSessionState>('lsp-session', {
      servers: servers.map(s => s.name),
      timestamp: Date.now(),
    })
  }

  function showStartupWidget(
    ctx: ExtensionContext,
    result: { started: string[], failed: string[] },
  ): void {
    if (!ctx.ui.setWidget)
      return

    const lines: string[] = []

    if (result.started.length > 0) {
      lines.push(
        `${ctx.ui.theme.fg('success', '✓ LSP servers ready:')} ${result.started.join(', ')}`,
      )
    }

    if (result.failed.length > 0) {
      lines.push(
        `${ctx.ui.theme.fg('error', '✗ LSP servers failed:')} ${result.failed.join(', ')}`,
      )
    }

    if (lines.length > 0) {
      ctx.ui.setWidget('lsp-startup', lines, { placement: 'aboveEditor' })
      setTimeout(() => {
        ctx.ui.setWidget('lsp-startup', undefined)
      }, 5000)
    }
  }

  pi.on('session_start', async (_event, ctx) => {
    const result = await startAll(ctx)
    registerLspTools(pi, manager)
    updateStatus(ctx)

    if (ctx.hasUI) {
      showStartupWidget(ctx, result)
    }

    persistState()
  })

  pi.on('session_shutdown', async () => {
    await manager.stopAll()
  })

  pi.registerCommand('lsp', {
    description: 'List LSP servers and their status',
    handler: async (_args, ctx) => {
      const servers = manager.getAll()

      if (servers.length === 0) {
        ctx.ui.notify(
          'No LSP servers configured. Add "lspServers" to ~/.agents/mcp.json',
          'info',
        )
        return
      }

      const lines: string[] = ['LSP Servers:', '']
      for (const server of servers) {
        const icon = server.status === 'ready'
          ? '✓'
          : server.status === 'starting'
            ? '…'
            : server.status === 'error'
              ? '✗'
              : '○'

        const extensions = server.config.extensions.join(', ')
        lines.push(`  ${icon} ${server.name} (${server.status})`)
        lines.push(`    Extensions: ${extensions}`)

        if (server.error) {
          lines.push(`    Error: ${server.error}`)
        }
      }

      ctx.ui.notify(lines.join('\n'), 'info')
    },
  })

  pi.registerCommand('lsp-reload', {
    description: 'Reload LSP configuration and restart all servers',
    handler: async (_args, ctx) => {
      await manager.stopAll()
      const result = await startAll(ctx)
      updateStatus(ctx)
      persistState()

      const messages: string[] = []
      if (result.started.length > 0) {
        messages.push(`LSP reloaded: ${result.started.join(', ')}`)
      }
      if (result.failed.length > 0) {
        messages.push(`Failed: ${result.failed.join(', ')}`)
      }

      ctx.ui.notify(messages.join('\n') || 'No LSP servers configured', 'info')
    },
  })
}
