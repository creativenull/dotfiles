/**
 * TypeScript types for MCP extension
 */

/** MCP server configuration */
export interface McpServerConfig {
  /** Command to run (e.g., "mcp-filesystem", "node", "python") */
  command: string
  /** Arguments to pass to the command */
  args?: string[]
  /** Environment variables (values can be ${VAR_NAME} for expansion) */
  env?: Record<string, string>
  /** Whether this server is disabled */
  disabled?: boolean
}

/** Full MCP configuration file */
export interface McpConfig {
  /** Named server configurations */
  servers: Record<string, McpServerConfig>
}

/** MCP tool definition from server */
export interface McpToolDefinition {
  name: string
  description?: string
  inputSchema: {
    type: 'object'
    properties?: Record<string, unknown>
    required?: string[]
  }
}

/** MCP tool call result */
export interface McpToolResult {
  content: Array<
    | { type: 'text', text: string }
    | { type: 'image', data: string, mimeType: string }
    | { type: 'resource', resource: unknown }
  >
  isError?: boolean
}

/** Connected MCP server state */
export interface McpServerState {
  name: string
  config: McpServerConfig
  status: 'connecting' | 'connected' | 'disconnected' | 'error'
  error?: string
  tools: McpToolDefinition[]
}

/** Persisted session state */
export interface McpSessionState {
  servers: string[]
  timestamp: number
}
