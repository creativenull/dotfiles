# Web Fetch Extension for Pi

A clean web-fetch and web-search extension for the Pi coding agent.

## Features

### Web Fetch (`web_fetch`)

Fetch URLs with four modes:

1. **llms_txt mode** - Fetch and parse llms.txt files from documentation sites
   - Tries `/llms.txt` and `/.well-known/llms.txt`
   - Parses links, sections, and descriptions
   - Scores links against queries

2. **html mode** - Fetch and parse HTML content
   - Converts HTML to readable plain text
   - Strips scripts, styles, and tags
   - Normalizes whitespace

3. **jina mode** - Use Jina Reader API to fetch content
   - Converts any URL to clean Markdown
   - Free, no authentication required
   - Better for LLM consumption

4. **raw mode** - Fetch any URL and parse content
   - HTML → plain text
   - JSON → formatted
   - Text → cleaned
   - Other types noted but not parsed

### Web Search (`web_search`)

Search the web using DuckDuckGo:

- **DuckDuckGo API** - Free search, no authentication required
- **Instant Answers** - Get quick answers to common questions
- **Optional Content Fetching** - Fetch full content from top result using Jina Reader

### Smart Preview

The tool automatically truncates the preview shown in the chat (default: 500 characters) while keeping the **full content available** for processing. This means:

- **User sees**: A brief preview of the fetched content
- **Assistant can access**: The full content to answer the user's question

You can control the preview length with the `previewLength` parameter.

## Usage

### Web Fetch

```bash
# Fetch llms.txt for a domain
web_fetch(url="laravel.com", mode="llms_txt")

# Fetch using Jina Reader API (recommended for web pages)
web_fetch(url="https://example.com/docs", mode="jina")

# Fetch and parse HTML content
web_fetch(url="https://example.com/docs", mode="html")

# Fetch raw content with metadata
web_fetch(url="https://api.example.com/data", mode="raw", raw=true)

# Limit output
web_fetch(url="https://example.com/long-page", head=3000)

# Control preview length (default: 500)
web_fetch(url="https://example.com/large-doc.md", previewLength=200)
```

#### Web Fetch Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to fetch |
| `mode` | string | raw | Fetch mode: `llms_txt`, `html`, `jina`, or `raw` |
| `raw` | boolean | false | Include response metadata (status, headers) |
| `maxBytes` | number | 50000 | Maximum output size in bytes |
| `timeout` | number | 15 | Request timeout in seconds |
| `head` | number | — | Return only first N characters of parsed body |
| `previewLength` | number | 500 | Characters shown in chat preview |

### Web Search

```bash
# Search the web
web_search(query="how to create a job in laravel")

# Search and fetch content from top result
web_search(query="laravel jobs tutorial", fetchContent=true)

# Control number of results
web_search(query="vue computed props", limit=5)

# Control content length
web_search(query="react hooks", fetchContent=true, maxContentLength=5000)
```

#### Web Search Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `query` | string | — | Search query |
| `limit` | number | 5 | Max search results (max: 10) |
| `fetchContent` | boolean | false | Fetch full content from top result |
| `maxContentLength` | number | 10000 | Max characters to fetch |

## Architecture

```
src/
├── types.ts                  # Shared type definitions
├── fetcher.ts                # Core HTTP fetching and content parsing
├── html-extractor.ts         # HTML content extraction
├── llms-txt.ts               # llms.txt discovery and parsing
├── duckduckgo-search.ts     # DuckDuckGo + Jina Reader integration
├── web-fetch.ts              # web_fetch tool (4 modes)
├── web-search.ts             # web_search tool (DuckDuckGo)
└── index.ts                  # Extension entry point
```

## APIs Used

### Jina Reader API
- **URL**: `https://r.jina.ai/http://...`
- **Auth**: Free, no API key required
- **Purpose**: Converts any URL to clean Markdown

### DuckDuckGo Instant Answer API
- **URL**: `https://api.duckduckgo.com/`
- **Auth**: Free, no API key required
- **Purpose**: Web search with instant answers

## Installation

No extra dependencies needed — uses Node.js built-in `fetch`.

```bash
cd ~/.pi/agent/extensions/web-fetch
npm install
```

## Development

```bash
# Lint
npm run lint

# Auto-fix linting issues
npm run lint:fix

# Type check
npm run typecheck
```
