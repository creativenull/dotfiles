# Web Fetch Extension

Fetches and parses web content using [Jina AI Reader](https://jina.ai/reader/).

## Features

- Fetches content from any URL
- Handles JavaScript-rendered content (SPAs, modern docs sites)
- Extracts main content (removes navigation, ads, sidebars)
- Converts to clean markdown format
- Follows redirects automatically

## Smart Content Handling

The extension uses a two-tier approach to balance context usage:

- **Content <= 10,000 chars**: Returns directly to LLM context
- **Content > 10,000 chars**: Saves to temp file, LLM uses `rg` to search

This prevents context bloat while still giving access to full content when needed.

## Setup

1. Get a free API key from https://jina.ai/reader/
2. Set the environment variable:

```bash
export JINA_AI_READER_API_KEY=your-api-key-here
```

Or add to your shell profile (`~/.zshrc`, `~/.bashrc`):

```bash
export JINA_AI_READER_API_KEY=your-api-key-here
```

## Usage

### Tool: `web_fetch`

Use from the LLM to fetch any URL:

```
Fetch the content from https://docs.example.com/api
```

For large pages, the tool will save content to a temp file and instruct the LLM:

```
rg "search_term" /tmp/pi-web-fetch-xxx/content.md
```

### Command: `/fetch <url>`

Quick fetch from the command line:

```
/fetch https://react.dev/learn
```

### Command: `/web-fetch-status`

Check if the API key is configured and working.

## Architecture

```
src/
├── index.ts    # Extension entry point, tool & command registration
├── client.ts   # Jina AI Reader API client
└── types.ts    # TypeScript type definitions
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | required | URL to fetch |
| `timeout` | number | 30000 | Request timeout in ms |

## Best Practices

- Use for documentation websites, API references, technical blogs
- Works well with React docs, MDN, GitHub wikis
- Handles modern SPA frameworks (React, Vue, Angular docs)
- Great for sites that use hydration to load content
