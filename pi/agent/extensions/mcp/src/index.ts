/**
 * MCP Extension for Pi
 *
 * Connects to MCP (Model Context Protocol) servers and exposes their tools
 * as native Pi tools callable by the LLM.
 *
 * Configuration:
 *   ~/.pi/agent/mcp.json (global)
 *   .pi/mcp.json (project-local)
 *
 * Commands:
 *   /mcp              - List servers and tools
 *   /mcp-connect      - Connect to a server
 *   /mcp-disconnect   - Disconnect from a server
 *   /mcp-reload       - Reload configuration and reconnect
 *
 * Example configs:
 *
 *   // Laravel Boost (.pi/mcp.json in project root)
 *   {
 *     "servers": {
 *       "laravel-boost": {
 *         "command": "php",
 *         "args": ["artisan", "boost:mcp"]
 *       }
 *     }
 *   }
 *
 *   // Filesystem server
 *   {
 *     "servers": {
 *       "filesystem": {
 *         "command": "npx",
 *         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"]
 *       }
 *     }
 *   }
 */

import type { ExtensionAPI, ExtensionContext } from '@mariozechner/pi-coding-agent'
import type { McpSessionState } from './types.js'
import { McpClientManager } from './client.js'
import { loadMcpConfig, validateServerConfig } from './config.js'
import { registerMcpTools } from './tools.js'

const STATUS_ID = 'mcp-status'

export default function mcpExtension(pi: ExtensionAPI): void {
  const manager = new McpClientManager()

  /**
   * Update the status line in the footer.
   */
  function updateStatus(ctx: ExtensionContext): void {
    const clients = manager.getAll()
    const connected = clients.filter(c => c.status === 'connected').length
    const total = clients.length

    if (total === 0) {
      ctx.ui.setStatus(STATUS_ID, undefined)
      return
    }

    const statusText
      = connected === total
        ? `MCP: ${connected} server${connected !== 1 ? 's' : ''} connected`
        : `MCP: ${connected}/${total} connected`

    ctx.ui.setStatus(STATUS_ID, ctx.ui.theme.fg('accent', statusText))
  }

  /**
   * Connect to all configured servers.
   */
  async function connectAll(ctx: ExtensionContext): Promise<{ connected: string[], failed: string[] }> {
    const config = await loadMcpConfig(ctx.cwd)
    const connected: string[] = []
    const failed: string[] = []

    for (const [name, serverConfig] of Object.entries(config.servers)) {
      if (serverConfig.disabled) {
        continue
      }

      const error = validateServerConfig(serverConfig)
      if (error) {
        console.error(`Invalid config for server '${name}': ${error}`)
        failed.push(name)
        continue
      }

      try {
        const client = await manager.addClient(name, serverConfig)
        await registerMcpTools(pi, client)
        connected.push(name)
      }
      catch (err) {
        console.error(`Failed to connect to MCP server '${name}':`, err)
        failed.push(name)
      }
    }

    return { connected, failed }
  }

  /**
   * Persist session state.
   */
  function persistState(): void {
    const clients = manager.getAll()
    pi.appendEntry<McpSessionState>('mcp-session', {
      servers: clients.map(c => c.name),
      timestamp: Date.now(),
    })
  }

  /**
   * Show MCP startup info as a widget above the editor.
   * Auto-dismisses after the user starts interacting.
   */
  function showStartupWidget(
    ctx: ExtensionContext,
    result: { connected: string[], failed: string[] },
  ): void {
    if (!ctx.ui.setWidget)
      return

    const lines: string[] = []

    if (result.connected.length > 0) {
      lines.push(
        `${ctx.ui.theme.fg('success', '✓ MCP connected:')
        } ${result.connected.join(', ')}`,
      )
    }

    if (result.failed.length > 0) {
      lines.push(
        `${ctx.ui.theme.fg('error', '✗ MCP failed:')
        } ${result.failed.join(', ')}`,
      )
    }

    if (lines.length > 0) {
      ctx.ui.setWidget('mcp-startup', lines, { placement: 'aboveEditor' })

      // Auto-dismiss after 5 seconds
      setTimeout(() => {
        ctx.ui.setWidget('mcp-startup', undefined)
      }, 5000)
    }
  }

  // Session lifecycle
  pi.on('session_start', async (event, ctx) => {
    const result = await connectAll(ctx)
    updateStatus(ctx)

    // Show startup widget with connection status
    if (ctx.hasUI) {
      showStartupWidget(ctx, result)
    }

    persistState()
  })

  pi.on('session_shutdown', async () => {
    await manager.disconnectAll()
  })

  // Commands
  pi.registerCommand('mcp', {
    description: 'List MCP servers and tools',
    handler: async (_args, ctx) => {
      const clients = manager.getAll()

      if (clients.length === 0) {
        ctx.ui.notify(
          'No MCP servers configured. Create ~/.pi/agent/mcp.json',
          'info',
        )
        return
      }

      // Build a summary string
      const lines: string[] = ['MCP Servers:', '']
      for (const client of clients) {
        const statusIcon
          = client.status === 'connected'
            ? '✓'
            : client.status === 'connecting'
              ? '…'
              : client.status === 'error'
                ? '✗'
                : '○'
        lines.push(`  ${statusIcon} ${client.name} (${client.status})`)
        if (client.error) {
          lines.push(`    Error: ${client.error}`)
        }
      }

      ctx.ui.notify(lines.join('\n'), 'info')
    },
  })

  pi.registerCommand('mcp-connect', {
    description: 'Connect to an MCP server: /mcp-connect <server>',
    handler: async (args, ctx) => {
      const serverName = args?.trim()
      if (!serverName) {
        ctx.ui.notify('Usage: /mcp-connect <server_name>', 'warning')
        return
      }

      const config = await loadMcpConfig(ctx.cwd)
      const serverConfig = config.servers[serverName]

      if (!serverConfig) {
        ctx.ui.notify(`Unknown MCP server: ${serverName}`, 'error')
        return
      }

      try {
        const client = await manager.addClient(serverName, serverConfig)
        const toolCount = await registerMcpTools(pi, client)
        updateStatus(ctx)
        persistState()
        ctx.ui.notify(
          `Connected to ${serverName} (${toolCount} tools)`,
          'info',
        )
      }
      catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        ctx.ui.notify(
          `Failed to connect to ${serverName}: ${message}`,
          'error',
        )
      }
    },
  })

  pi.registerCommand('mcp-disconnect', {
    description: 'Disconnect from an MCP server: /mcp-disconnect <server>',
    handler: async (args, ctx) => {
      const serverName = args?.trim()
      if (!serverName) {
        ctx.ui.notify('Usage: /mcp-disconnect <server_name>', 'warning')
        return
      }

      const client = manager.get(serverName)
      if (!client) {
        ctx.ui.notify(`MCP server not found: ${serverName}`, 'warning')
        return
      }

      await manager.removeClient(serverName)
      updateStatus(ctx)
      persistState()
      ctx.ui.notify(`Disconnected from ${serverName}`, 'info')
    },
  })

  pi.registerCommand('mcp-reload', {
    description: 'Reload MCP configuration and reconnect all servers',
    handler: async (_args, ctx) => {
      await manager.disconnectAll()
      const result = await connectAll(ctx)
      updateStatus(ctx)
      persistState()

      if (result.connected.length > 0) {
        ctx.ui.notify(
          `MCP reloaded: connected to ${result.connected.join(', ')}`,
          'info',
        )
      }
      if (result.failed.length > 0) {
        ctx.ui.notify(`MCP failed: ${result.failed.join(', ')}`, 'warning')
      }
    },
  })
}
