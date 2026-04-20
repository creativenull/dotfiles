# Web Fetch Extension for Pi

A clean web-fetch tool for the Pi coding agent. Fetches URLs and returns parsed, readable content — no raw curl noise.

## Features

- **HTML → plain text**: Strips tags, scripts, styles, decodes entities, normalises whitespace
- **JSON → formatted**: Pretty-prints JSON responses
- **Smart truncation**: Respects `maxBytes` and `head` limits to avoid blowing up context
- **Timeout handling**: Configurable timeout with proper abort signals
- **Custom headers & methods**: Full control for API calls (POST, PUT, etc.)
- **Metadata toggle**: Set `raw=true` to include status, headers, truncation info

## Installation

No extra dependencies needed — uses Node.js built-in `fetch`.

```bash
cd ~/.pi/agent/extensions/web-fetch
npm install
```

## Usage

The `web_fetch` tool is automatically available. Example prompts:

> Fetch https://example.com and summarise the page

> POST to https://api.example.com/data with body '{"key": "value"}'

> Fetch the first 3000 characters of https://docs.example.com/long-page

## Parameters

| Parameter  | Type     | Default | Description                                      |
|------------|----------|---------|--------------------------------------------------|
| `url`      | string   | —       | URL to fetch                                     |
| `method`   | string   | GET     | HTTP method                                      |
| `headers`  | object   | —       | Request headers                                  |
| `body`     | string   | —       | Request body (POST/PUT/PATCH)                    |
| `maxBytes` | number   | 50000   | Max output bytes (after parsing)                 |
| `timeout`  | number   | 15      | Timeout in seconds                               |
| `head`     | number   | —       | Return only first N characters of parsed body    |
| `raw`      | boolean  | false   | Include response status and headers in output    |
