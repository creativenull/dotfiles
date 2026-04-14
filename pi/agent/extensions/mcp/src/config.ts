/**
 * Configuration loading for MCP extension
 */

import type { McpConfig, McpServerConfig } from './types'
import { existsSync } from 'node:fs'
import { readFile } from 'node:fs/promises'
import { homedir } from 'node:os'
import { join } from 'node:path'
import process from 'node:process'

/**
 * Expand environment variables in a string.
 * Supports ${VAR_NAME} syntax.
 */
function expandEnv(value: string): string {
  return value.replace(/\$\{([^}]+)\}/g, (_, name) => {
    return process.env[name] ?? ''
  })
}

/**
 * Expand environment variables in config values.
 */
function expandConfigEnv(config: McpServerConfig): McpServerConfig {
  const expanded: McpServerConfig = {
    command: expandEnv(config.command),
    args: config.args?.map(expandEnv),
    disabled: config.disabled,
  }

  if (config.env) {
    expanded.env = {}
    for (const [key, value] of Object.entries(config.env)) {
      expanded.env[key] = expandEnv(value)
    }
  }

  return expanded
}

/**
 * Load and merge configurations from global and project locations.
 */
export async function loadMcpConfig(projectDir?: string): Promise<McpConfig> {
  const configs: McpConfig[] = []

  // Global config: ~/.pi/agent/mcp.json
  const globalPath = join(homedir(), '.pi', 'agent', 'mcp.json')
  if (existsSync(globalPath)) {
    try {
      const content = await readFile(globalPath, 'utf-8')
      configs.push(JSON.parse(content))
    }
    catch (error) {
      console.error(`Failed to load global MCP config: ${error}`)
    }
  }

  // Project config: <project>/.pi/mcp.json
  if (projectDir) {
    const projectPath = join(projectDir, '.pi', 'mcp.json')
    if (existsSync(projectPath)) {
      try {
        const content = await readFile(projectPath, 'utf-8')
        configs.push(JSON.parse(content))
      }
      catch (error) {
        console.error(`Failed to load project MCP config: ${error}`)
      }
    }
  }

  // Merge configs (project overrides global for same server names)
  const merged: McpConfig = { mcpServers: {} }
  for (const config of configs) {
    for (const [name, serverConfig] of Object.entries(config.mcpServers ?? {})) {
      merged.mcpServers[name] = expandConfigEnv(serverConfig)
    }
  }

  return merged
}

/**
 * Validate a server configuration.
 * Returns error message or undefined if valid.
 */
export function validateServerConfig(
  config: McpServerConfig,
): string | undefined {
  if (!config.command || typeof config.command !== 'string') {
    return 'Missing or invalid \'command\' field'
  }
  if (config.args !== undefined && !Array.isArray(config.args)) {
    return '\'args\' must be an array'
  }
  if (config.env !== undefined && typeof config.env !== 'object') {
    return '\'env\' must be an object'
  }
  return undefined
}
