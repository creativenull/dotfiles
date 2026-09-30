# Disabled extensions

Extensions moved here are **not loaded** by pi — only files/directories inside
`extensions/` are discovered. This folder preserves them for reference or
re-enabling later.

- `mcp/` — custom MCP client extension (stdio-only, read `~/.agents/mcp.json`).
  Replaced by pi's built-in MCP support + `codemode` (see `settings.json`:
  `defaultTools: ["+codemode"]`). Servers now go in `~/.pi/agent/mcp.json`
  via `pi mcp add`.

To re-enable: move the folder back into `extensions/` and run `npm install`
inside it if `node_modules` is missing.
