/**
 * MCP client implementation using stdio transport
 */

import type {
  McpServerConfig,
  McpToolDefinition,
  McpToolResult,
} from './types'
import process from 'node:process'
import { Client } from '@modelcontextprotocol/sdk/client/index.js'
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js'

export interface McpClient {
  readonly name: string
  readonly status: 'connecting' | 'connected' | 'disconnected' | 'error'
  readonly error?: string
  connect: () => Promise<void>
  disconnect: () => Promise<void>
  listTools: () => Promise<McpToolDefinition[]>
  callTool: (name: string, args: Record<string, unknown>) => Promise<McpToolResult>
}

/**
 * Create an MCP client for a server.
 */
export function createMcpClient(
  name: string,
  config: McpServerConfig,
): McpClient {
  let client: Client | null = null
  let transport: StdioClientTransport | null = null
  let status: 'connecting' | 'connected' | 'disconnected' | 'error'
    = 'disconnected'
  let errorMsg: string | undefined

  return {
    get name() {
      return name
    },
    get status() {
      return status
    },
    get error() {
      return errorMsg
    },

    async connect() {
      if (client) {
        await this.disconnect()
      }

      status = 'connecting'
      errorMsg = undefined

      try {
        const env: Record<string, string> = {}
        for (const [key, value] of Object.entries(process.env)) {
          if (value !== undefined) {
            env[key] = value
          }
        }
        transport = new StdioClientTransport({
          command: config.command,
          args: config.args ?? [],
          env: {
            ...env,
            ...config.env,
          },
        })

        client = new Client(
          { name: `pi-mcp-${name}`, version: '1.0.0' },
          { capabilities: {} },
        )

        await client.connect(transport)
        status = 'connected'
      }
      catch (error) {
        status = 'error'
        errorMsg = error instanceof Error ? error.message : String(error)
        throw error
      }
    },

    async disconnect() {
      if (client) {
        try {
          await client.close()
        }
        catch {
          // Ignore close errors
        }
        client = null
      }
      transport = null
      status = 'disconnected'
      errorMsg = undefined
    },

    async listTools() {
      if (!client || status !== 'connected') {
        throw new Error(`MCP server '${name}' is not connected`)
      }

      const result = await client.listTools()

      return result.tools.map(tool => ({
        name: tool.name,
        description: tool.description,
        inputSchema: tool.inputSchema as McpToolDefinition['inputSchema'],
      }))
    },

    async callTool(toolName: string, args: Record<string, unknown>) {
      if (!client || status !== 'connected') {
        throw new Error(`MCP server '${name}' is not connected`)
      }

      const result = await client.callTool({
        name: toolName,
        arguments: args,
      })

      return {
        content: result.content as McpToolResult['content'],
        isError: typeof result.isError === 'boolean' ? result.isError : false,
      }
    },
  }
}

/**
 * Manager for multiple MCP clients.
 */
export class McpClientManager {
  private clients = new Map<string, McpClient>()

  /**
   * Get all managed clients.
   */
  getAll(): McpClient[] {
    return Array.from(this.clients.values())
  }

  /**
   * Get a client by name.
   */
  get(name: string): McpClient | undefined {
    return this.clients.get(name)
  }

  /**
   * Add and connect to a new server.
   */
  async addClient(name: string, config: McpServerConfig): Promise<McpClient> {
    const existing = this.clients.get(name)
    if (existing) {
      await existing.disconnect()
    }

    const client = createMcpClient(name, config)
    this.clients.set(name, client)
    await client.connect()

    return client
  }

  /**
   * Remove and disconnect a server.
   */
  async removeClient(name: string): Promise<void> {
    const client = this.clients.get(name)
    if (client) {
      await client.disconnect()
      this.clients.delete(name)
    }
  }

  /**
   * Disconnect all servers.
   */
  async disconnectAll(): Promise<void> {
    const promises = Array.from(this.clients.values()).map(client =>
      client.disconnect().catch(() => {}),
    )
    await Promise.all(promises)
    this.clients.clear()
  }
}
