# Pi LSP Diagnostics Extension

Connect to LSP (Language Server Protocol) servers and expose real compiler/linter diagnostics as a tool the LLM can call. This gives Pi deeper context about your code — type errors, lint warnings, and more — straight from the same language servers your editor uses.

## Features

- **Real diagnostics** — Get actual compiler errors, type errors, and lint warnings from LSP servers
- **Multi-language** — Run multiple LSP servers simultaneously (TypeScript, Python, Rust, Lua, etc.)
- **Standard protocol** — Uses `vscode-languageserver-protocol` for LSP communication
- **Separate config** — Uses its own `~/.agents/lsp.json` config file
- **Automatic routing** — Files are automatically routed to the correct LSP server by extension

## Installation

1. Copy this extension to `~/.pi/agent/extensions/lsp/`
2. Install dev dependencies (for type checking only):

   ```bash
   cd ~/.pi/agent/extensions/lsp
   npm install
   ```

3. Restart Pi or start a new session

## Configuration

The extension reads `lspServers` from a dedicated `lsp.json` config file.

### Configuration Locations

| Location | Purpose |
|----------|---------|
| `~/.agents/lsp.json` | Global configuration (applies to all projects) |
| `.agents/lsp.json` | Project-local configuration (overrides global) |

### Configuration Schema

```jsonc
{
  "lspServers": {
    "<name>": {
      "command": "server-command", // Required: LSP server executable
      "args": ["--stdio"], // Optional: arguments
      "extensions": ["ts", "js"], // Required: file extensions this server handles
      "env": {}, // Optional: environment variables
      "initializationOptions": {}, // Optional: passed to LSP initialize
      "disabled": false // Optional: set true to skip this server
    }
  }
}
```

### Example Configuration

```jsonc
// ~/.agents/lsp.json
{
  "lspServers": {
    "typescript": {
      "command": "typescript-language-server",
      "args": ["--stdio"],
      "extensions": ["ts", "tsx", "js", "jsx", "mjs", "cjs"]
    },
    "python": {
      "command": "pyright-langserver",
      "args": ["--stdio"],
      "extensions": ["py", "pyi"]
    },
    "lua": {
      "command": "lua-language-server",
      "args": [],
      "extensions": ["lua"]
    },
    "rust": {
      "command": "rust-analyzer",
      "args": [],
      "extensions": ["rs"]
    }
  }
}
```

### Environment Variable Expansion

Configuration values support `${VAR_NAME}` syntax:

```json
{
  "lspServers": {
    "custom": {
      "command": "${HOME}/.local/bin/my-lsp-server",
      "args": ["--stdio"],
      "extensions": ["custom"]
    }
  }
}
```

## The `lsp_diagnostics` Tool

The extension registers a single tool that the LLM can call:

### Usage

The LLM calls `lsp_diagnostics` with a file path:

```
lsp_diagnostics({ filePath: "src/app.ts" })
```

### Output Format

**With diagnostics:**
```
Diagnostics for app.ts (typescript):

  ✗ Error (12:5): Property 'foo' does not exist on type 'Bar'. [ts(2339)]
  ⚠ Warning (45:1): 'unused' is declared but its value is never read. [ts(6133)]
  💡 Hint (78:10): Did you mean 'toString'? [ts(2551)]

3 diagnostics: 1 error, 1 warning, 1 hint
```

**Without diagnostics:**
```
No diagnostics for app.ts (typescript) ✓
```

### Typical Workflow

```
User: Fix the type errors in src/app.ts
LLM: [reads src/app.ts with read tool]
LLM: [edits the file with edit tool]
LLM: [calls lsp_diagnostics to check for remaining errors]  ← NEW
LLM: "Fixed 2 type errors. LSP shows no remaining diagnostics."
```

## Commands

| Command | Description |
|---------|-------------|
| `/lsp` | List all LSP servers and their status |
| `/lsp-reload` | Reload configuration and restart all servers |

## Supported Languages

The extension automatically maps file extensions to LSP language IDs. Common mappings include:

| Extension | Language ID |
|-----------|-------------|
| `ts`, `tsx` | typescript, typescriptreact |
| `js`, `jsx`, `mjs`, `cjs` | javascript, javascriptreact |
| `py`, `pyi` | python |
| `rs` | rust |
| `go` | go |
| `lua` | lua |
| `java` | java |
| `kt`, `kts` | kotlin |
| `c`, `h` | c |
| `cpp`, `hpp`, `cc` | cpp |
| `cs` | csharp |
| `rb` | ruby |
| `php` | php |
| `swift` | swift |
| `dart` | dart |
| `vue` | vue |
| `svelte` | svelte |
| `html`, `css`, `scss` | html, css, scss |

## Popular LSP Servers

| Language | Server | Install |
|----------|--------|---------|
| TypeScript/JavaScript | `typescript-language-server` | `npm i -g typescript-language-server` |
| Python | `pyright-langserver` | `npm i -g pyright` |
| Python | `pylsp` | `pip install python-lsp-server` |
| Rust | `rust-analyzer` | Built into rustup |
| Go | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| Lua | `lua-language-server` | See [LuaLS](https://luals.github.io/) |
| C/C++ | `clangd` | `brew install clangd` or system package |
| Ruby | `solargraph` | `gem install solargraph` |
| PHP | `intelephense` | `npm i -g intelephense` |
| Vue | `vue-language-server` | `npm i -g @vue/language-server` |
| Svelte | `svelteserver` | `npm i -g svelte-language-server` |

## How It Works

1. **Startup**: Reads `lspServers` from `~/.agents/lsp.json`, spawns each server as a child process
2. **Initialize**: Performs the LSP `initialize` handshake using `vscode-languageserver-protocol`
3. **On tool call**: When `lsp_diagnostics` is called:
   - Finds the right server by file extension
   - Reads the current file from disk
   - Opens or updates the document in the LSP server
   - Waits for `textDocument/publishDiagnostics` notification
   - Returns formatted diagnostics
4. **Shutdown**: Gracefully shuts down all servers on session end

## Troubleshooting

### Server won't start

1. Check that the `command` is in your PATH or use an absolute path
2. Verify the server supports `--stdio` mode (most do)
3. Check the server's documentation for required setup

### No diagnostics returned

1. Run `/lsp` to check server status
2. Ensure the file extension is in the server's `extensions` list in `~/.agents/lsp.json`
3. Some servers need time to index the workspace — try again after a few seconds

### View server status

```
/lsp
```

This shows all servers and their status:
- ✓ Ready
- … Starting
- ✗ Error (with error message)
- ○ Shutdown

## Development

```bash
# Install dependencies
npm install

# Type check
npx tsc --noEmit
```

## License

MIT
