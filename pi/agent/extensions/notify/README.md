# Pi Notify Extension

Sends a terminal notification when the Pi agent finishes responding, with a preview of the first sentence of the answer.

## How it works

- Listens for the `agent_end` event (fires when the agent is done and waiting for input)
- Extracts the first sentence of the last assistant message
- Strips all markdown formatting for a clean notification preview
- Sends a terminal notification via OSC escape sequences

### Preview extraction

The extension finds the first prose line of the answer:

1. Skips content inside code blocks (between ` ``` ` fences)
2. Skips markdown headings (`# Title`, `## Section`, etc.)
3. Skips empty lines and bare bullet points
4. Takes the first content line
5. Strips inline markdown — `**bold**` → bold, `*italic*` → italic, `` `code` `` → code, `[text](url)` → text, `~~strike~~` → strike
6. Truncates at the first sentence boundary (`.`, `!`, `?`) or at a configurable max length with `…`

### Terminal protocol support

| Protocol | Terminals | Stacking |
|----------|-----------|----------|
| OSC 777 | Ghostty, iTerm2, WezTerm, rxvt-unicode | Yes (by default) |
| OSC 99 | Kitty | Yes (incrementing IDs) |

Kitty is auto-detected via the `KITTY_WINDOW_ID` environment variable. All other terminals use OSC 777.

Notifications stack — each `agent_end` creates a new notification rather than replacing the previous one. Kitty uses incrementing notification IDs with `d=1` (done state) so each one appears as a separate OS notification.

## Install

1. Copy this extension to `~/.pi/agent/extensions/notify/`
2. Install dependencies:

   ```bash
   cd ~/.pi/agent/extensions/notify
   npm install
   ```

3. Restart Pi or start a new session

## Configuration

Create `~/.pi/agent/notify.json` (optional — defaults are used if absent):

```json
{
  "maxPreviewLength": 80,
  "title": "pi coding agent"
}
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxPreviewLength` | number | `80` | Max characters of the answer preview |
| `title` | string | `"pi coding agent"` | Notification title |

### Example configurations

**Longer preview:**

```json
{
  "maxPreviewLength": 120
}
```

**Custom title:**

```json
{
  "title": "My Agent"
}
```

## Development

```bash
npm install       # Install dependencies
npm run lint      # Check for lint errors
npm run lint:fix  # Fix lint errors
```

## License

MIT © 2026 creativenull
