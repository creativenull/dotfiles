# pi Web Fetch

Fetch and intelligently parse web content — replaces raw `curl` calls with structured, usable output.

## How it works

Registers a `web_fetch` tool that auto-detects the response `Content-Type` and extracts meaningful content:

| Content Type | Output |
|---|---|
| **JSON** | Pretty-printed structured data |
| **HTML** | Title, description, OG metadata, headings (h1–h6), links, and readable body text |
| **Text / XML** | Raw content |
| **Binary / images / PDFs** | Metadata only (content-type + size) |

- Strips `<script>`, `<style>`, `<svg>`, `<noscript>`, and other noise from HTML
- Follows redirects and reports the redirect chain
- Filters noisy response headers (cookies, etags, security headers, etc.)
- Output truncated to 50 KB / 2000 lines (same as built-in tools), with full output saved to a temp file when truncated
- Supports all HTTP methods (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`, `OPTIONS`) with custom headers and request body
- `raw` parameter to skip parsing and get the raw response body as-is
- Custom TUI rendering — color-coded status, content category, size, and timing in collapsed view

## Install

Place in `~/.pi/agent/extensions/web-fetch/` and run:

```bash
cd ~/.pi/agent/extensions/web-fetch
npm install
```

Pi auto-discovers the extension via the `pi.extensions` field in `package.json`.

## Usage

Just ask the LLM to fetch a URL — it will use `web_fetch` instead of `curl`:

```
Fetch https://docs.example.com/api and summarize the content
```

```
What's on https://github.com/some/repo?
```

```
POST to https://api.example.com/data with body {"key": "value"}
```

### Parameters

| Parameter | Type | Description |
|---|---|---|
| `url` | string | URL to fetch |
| `method` | string | HTTP method (default: `GET`) |
| `headers` | object | Custom request headers |
| `body` | string | Request body for POST/PUT/PATCH |
| `raw` | boolean | Skip parsing, return raw body |

## Development

```bash
npm run lint       # Check for lint errors
npm run lint:fix   # Auto-fix lint errors
npm run format     # Alias for lint:fix
npm run typecheck  # TypeScript type checking
```

## License

MIT © 2026 creativenull
