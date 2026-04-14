# pi Theme Switcher

Auto-switch pi theme based on macOS system appearance (dark/light mode).

## How it works

- Detects macOS dark/light mode via `defaults read -g AppleInterfaceStyle`
- Sets the pi theme immediately on session start
- Polls every 3 seconds for changes and switches theme automatically
- No `settings.json` modification — uses `ctx.ui.setTheme()` in-memory

## Install

Place in `~/.pi/agent/extensions/theme-switcher/` and run:

```bash
npm install
```

Pi auto-discovers the extension via the `pi.extensions` field in `package.json`.

## Development

```bash
npm run lint       # Check for lint errors
npm run lint:fix   # Auto-fix lint errors
npm run format     # Alias for lint:fix
```

## Configuration

The extension uses your existing pi themes (`dark` and `light` by default). Custom themes with those names in `~/.pi/agent/themes/` will be used if available.

## License

MIT © 2026 creativenull
