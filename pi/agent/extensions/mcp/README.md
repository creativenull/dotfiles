# Pi MCP Extension

Connect to [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) servers and expose their tools as native Pi tools callable by the LLM.

## Installation

1. Clone or copy this extension to `~/.pi/agent/extensions/mcp/`
2. Install dependencies:

   ```bash
   cd ~/.pi/agent/extensions/mcp
   npm install
   ```

3. Restart Pi or start a new session

## Configuration

The extension uses a Claude-compatible schema with `mcpServers` as the top-level key.

### Configuration Locations

| Location | Purpose |
|----------|---------|
| `~/.pi/agent/mcp.json` | Global configuration (applies to all projects) |
| `.pi/mcp.json` | Project-local configuration (overrides global) |

### Configuration Schema

```typescript
interface McpConfig {
  mcpServers: {
    [name: string]: {
      command: string // Executable to run
      args?: string[] // Arguments to pass
      env?: Record<string, string> // Environment variables
      disabled?: boolean // Set to true to disable
    }
  }
}
```

### Example Configurations

**Filesystem Server** (`~/.pi/agent/mcp.json`)

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

**Laravel Boost** (`.pi/mcp.json` in project root)

```json
{
  "mcpServers": {
    "laravel-boost": {
      "command": "php",
      "args": ["artisan", "boost:mcp"]
    }
  }
}
```

**Multiple Servers with Environment Variables**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${HOME}/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "disabled-server": {
      "command": "npx",
      "args": ["-y", "some-server"],
      "disabled": true
    }
  }
}
```

### Environment Variable Expansion

Configuration values support `${VAR_NAME}` syntax for environment variable expansion:

```json
{
  "mcpServers": {
    "custom": {
      "command": "${HOME}/.local/bin/my-mcp-server",
      "args": ["--config", "${PROJECT_ROOT}/config.json"]
    }
  }
}
```

## Commands

| Command | Description |
|---------|-------------|
| `/mcp` | List all configured servers and their connection status |
| `/mcp-connect <name>` | Connect to a specific MCP server |
| `/mcp-disconnect <name>` | Disconnect from a specific MCP server |
| `/mcp-reload` | Reload configuration and reconnect all servers |

## Tool Namespacing

MCP tools are namespaced to avoid conflicts between multiple servers:

```
mcp:<server_name>:<tool_name>
```

For example, if you have a filesystem server named `fs` with a `read_file` tool:

```
mcp:fs:read_file
```

The LLM can call these tools directly just like built-in Pi tools.

## Popular MCP Servers

### Official MCP Servers

| Server | Package | Description |
|--------|---------|-------------|
| Filesystem | `@modelcontextprotocol/server-filesystem` | File system operations |
| GitHub | `@modelcontextprotocol/server-github` | GitHub API operations |
| Git | `@modelcontextprotocol/server-git` | Git operations |
| PostgreSQL | `@modelcontextprotocol/server-postgres` | PostgreSQL database |
| SQLite | `@modelcontextprotocol/server-sqlite` | SQLite database |
| Brave Search | `@modelcontextprotocol/server-brave-search` | Web search via Brave |
| Puppeteer | `@modelcontextprotocol/server-puppeteer` | Browser automation |

### Community Servers

Browse the [MCP Servers repository](https://github.com/modelcontextprotocol/servers) for more options.

## Development

```bash
# Install dependencies
npm install

# Run linter
npm run lint

# Fix lint issues
npm run lint:fix

# Type check
npm run typecheck
```

## Troubleshooting

### Server won't connect

1. Check that the `command` is in your PATH or use an absolute path
2. Verify arguments are correct for your MCP server
3. Check the server's documentation for required environment variables

### View connection status

```
/mcp
```

This shows all servers and their status:
- ✓ Connected
- … Connecting
- ✗ Error (with error message)
- ○ Disconnected

### Debug mode

Check Pi's logs for detailed error messages when servers fail to connect.

## License

MIT © 2026 creativenull
