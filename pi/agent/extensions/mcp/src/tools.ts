/**
 * Tool discovery and registration for MCP tools
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import type { TSchema } from '@sinclair/typebox'
import type { McpClient, McpClientManager } from './client'
import type { McpToolDefinition } from './types'
import { Type } from '@sinclair/typebox'

/**
 * Generate a Pi-compatible tool name from MCP server and tool names.
 * Format: mcp:<server>:<tool>
 */
export function makePiToolName(serverName: string, toolName: string): string {
  return `mcp:${serverName}:${toolName}`
}

/**
 * Parse a Pi tool name back to server and tool names.
 */
export function parsePiToolName(
  piToolName: string,
): { server: string, tool: string } | null {
  const parts = piToolName.split(':')
  if (parts.length !== 3 || parts[0] !== 'mcp') {
    return null
  }
  return { server: parts[1], tool: parts[2] }
}

/**
 * Convert MCP JSON Schema property to TypeBox schema.
 */
function jsonSchemaToTypeBox(schema: unknown): TSchema {
  if (!schema || typeof schema !== 'object') {
    return Type.Unknown()
  }

  const s = schema as Record<string, unknown>
  const type = s.type as string | undefined

  // Handle description
  const description = s.description as string | undefined

  switch (type) {
    case 'string':
      return Type.String({ description })
    case 'number':
    case 'integer':
      return Type.Number({ description })
    case 'boolean':
      return Type.Boolean({ description })
    case 'array':
      if (s.items) {
        return Type.Array(jsonSchemaToTypeBox(s.items), { description })
      }
      return Type.Array(Type.Unknown(), { description })
    case 'object': {
      const properties: Record<string, TSchema> = {}
      const props = s.properties as Record<string, unknown> | undefined
      if (props) {
        for (const [key, value] of Object.entries(props)) {
          properties[key] = jsonSchemaToTypeBox(value)
        }
      }
      const required = s.required as string[] | undefined
      return Type.Object(properties, {
        description,
        required: required ?? Object.keys(properties),
      })
    }
    default:
      return Type.Unknown({ description })
  }
}

/**
 * Convert MCP tool input schema to TypeBox schema for Pi.
 */
function convertInputSchema(
  inputSchema: McpToolDefinition['inputSchema'],
): TSchema {
  const properties: Record<string, TSchema> = {}
  const required: string[] = []

  if (inputSchema.properties) {
    for (const [name, schema] of Object.entries(inputSchema.properties)) {
      properties[name] = jsonSchemaToTypeBox(schema)
    }
  }

  if (inputSchema.required) {
    required.push(...inputSchema.required)
  }

  return Type.Object(properties, { required })
}

/**
 * Register an MCP tool as a Pi tool.
 */
export function registerMcpTool(
  pi: ExtensionAPI,
  client: McpClient,
  tool: McpToolDefinition,
): void {
  const piToolName = makePiToolName(client.name, tool.name)
  const parameters = convertInputSchema(tool.inputSchema)

  pi.registerTool({
    name: piToolName,
    label: `${client.name}/${tool.name}`,
    description: tool.description ?? `MCP tool: ${client.name}/${tool.name}`,
    parameters,
    async execute(_toolCallId, params, _signal, _onUpdate, _ctx) {
      try {
        const result = await client.callTool(tool.name, params as Record<string, unknown>)

        // Convert MCP result to Pi result format
        const textContent = result.content
          .filter((c): c is { type: 'text', text: string } => c.type === 'text')
          .map(c => c.text)
          .join('\n')

        return {
          content: [
            { type: 'text', text: textContent || 'Tool executed successfully' },
          ],
          details: {},
          isError: result.isError,
        }
      }
      catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        return {
          content: [
            {
              type: 'text',
              text: `MCP Error (${client.name}/${tool.name}): ${message}`,
            },
          ],
          details: {},
          isError: true,
        }
      }
    },
  })
}

/**
 * Discover and register all tools from an MCP client.
 */
export async function registerMcpTools(
  pi: ExtensionAPI,
  client: McpClient,
): Promise<number> {
  const tools = await client.listTools()

  for (const tool of tools) {
    registerMcpTool(pi, client, tool)
  }

  return tools.length
}

/**
 * Register all tools from all connected clients.
 */
export async function registerAllMcpTools(
  pi: ExtensionAPI,
  manager: McpClientManager,
): Promise<Map<string, number>> {
  const counts = new Map<string, number>()

  for (const client of manager.getAll()) {
    if (client.status === 'connected') {
      const count = await registerMcpTools(pi, client)
      counts.set(client.name, count)
    }
  }

  return counts
}
