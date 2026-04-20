/**
 * Web fetch tool for Pi.
 *
 * Fetches a URL and intelligently parses the response based on content type:
 * - JSON → pretty-printed structured data
 * - HTML → extracted title, headings, links, and body text
 * - Text → raw text content
 * - Binary/other → metadata only
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import type { WebFetchDetails } from './types.js'
import { mkdir, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { StringEnum } from '@mariozechner/pi-ai'
import {
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  formatSize,
  truncateHead,
} from '@mariozechner/pi-coding-agent'
import { Text } from '@mariozechner/pi-tui'
import { Type } from '@sinclair/typebox'
import { formatParsedContent, parseResponse } from './parser.js'

/**
 * Common headers to strip from responses to reduce noise.
 */
const STRIP_HEADERS = new Set([
  'set-cookie',
  'x-powered-by',
  'x-request-id',
  'x-correlation-id',
  'etag',
  'last-modified',
  'server',
  'strict-transport-security',
  'x-content-type-options',
  'x-frame-options',
  'x-xss-protection',
  'content-security-policy',
  'alt-svc',
  'report-to',
  'nel',
  'cf-cache-status',
  'cf-ray',
])

const HttpMethodEnum = StringEnum(['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'] as const)

const ParamsSchema = Type.Object({
  url: Type.String({ description: 'URL to fetch' }),
  method: Type.Optional(HttpMethodEnum),
  headers: Type.Optional(
    Type.Record(Type.String(), Type.String(), {
      description: 'Custom request headers (e.g. { "Authorization": "Bearer ..." })',
    }),
  ),
  body: Type.Optional(Type.String({ description: 'Request body for POST/PUT/PATCH' })),
  raw: Type.Optional(
    Type.Boolean({
      description: 'If true, return raw response body without parsing (for HTML/JSON)',
    }),
  ),
})

/**
 * Register the web_fetch tool.
 */
export function registerWebFetchTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: 'web_fetch',
    label: 'Web Fetch',
    description: `Fetch a URL and intelligently parse the response. Detects content type automatically:
- JSON responses → pretty-printed structured data
- HTML pages → extracted title, description, headings, links, and readable body text
- Plain text → returned as-is
- Binary/other → metadata with content type and size

Output is truncated to ${DEFAULT_MAX_LINES} lines or ${formatSize(DEFAULT_MAX_BYTES)} (whichever is hit first). If truncated, full output is saved to a temp file. Use the \`raw\` parameter to skip parsing and get the raw response body.`,

    promptSnippet: 'Fetch and parse web content (URLs) — auto-detects JSON, HTML, and text responses',
    promptGuidelines: [
      'Use web_fetch instead of curl for fetching web content. It auto-detects response type and extracts meaningful content from HTML pages.',
      'For API endpoints returning JSON, web_fetch returns structured data.',
      'For web pages (HTML), web_fetch extracts title, headings, links, and readable text — no need to parse raw HTML manually.',
    ],

    parameters: ParamsSchema,

    async execute(_toolCallId, params, signal, onUpdate, _ctx) {
      const { url, method = 'GET', headers = {}, body, raw } = params

      onUpdate?.({
        content: [{ type: 'text', text: `Fetching ${method} ${url}...` }],
        details: {},
      })

      const startTime = Date.now()

      // Build fetch options
      const fetchOptions: RequestInit = {
        method,
        headers: {
          'User-Agent': 'pi-coding-agent/1.0',
          'Accept': 'text/html,application/xhtml+xml,application/json,text/plain,*/*',
          ...headers,
        },
        signal,
        redirect: 'follow',
      }

      if (body && !['GET', 'HEAD'].includes(method)) {
        fetchOptions.body = body
      }

      // Fetch the URL
      let response: Response
      try {
        response = await fetch(url, fetchOptions)
      }
      catch (err) {
        throw new Error(
          `Failed to fetch ${url}: ${err instanceof Error ? err.message : String(err)}`,
        )
      }

      const elapsedTimeMs = Date.now() - startTime

      // Build redirect chain
      const redirectChain: string[] = []
      if (response.redirected && response.url !== url) {
        redirectChain.push(url)
        redirectChain.push(response.url)
      }

      // Collect response headers (filtered)
      const responseHeaders: Record<string, string> = {}
      response.headers.forEach((value, key) => {
        if (!STRIP_HEADERS.has(key.toLowerCase())) {
          responseHeaders[key] = value
        }
      })

      const contentType = response.headers.get('content-type') ?? 'unknown'
      const contentLengthHeader = response.headers.get('content-length')
      let contentLength = contentLengthHeader ? Number.parseInt(contentLengthHeader, 10) : 0

      // Read body (unless HEAD request)
      let responseBody: string | null = null
      if (method !== 'HEAD') {
        responseBody = await response.text()
        if (!contentLength) {
          contentLength = new TextEncoder().encode(responseBody).byteLength
        }
      }

      // Parse response
      const parsed = parseResponse(responseBody, contentType, { url, method, headers, body, raw })

      // Format output
      let outputText = formatParsedContent(parsed)

      // Append response metadata
      const metaLines: string[] = [
        '',
        '--- Response Metadata ---',
        `Status: ${response.status} ${response.statusText}`,
        `Content-Type: ${contentType}`,
        `Size: ${formatSize(contentLength)}`,
        `Time: ${elapsedTimeMs}ms`,
      ]
      if (redirectChain.length > 0) {
        metaLines.push(`Redirects: ${redirectChain.join(' → ')}`)
      }
      const headerKeys = Object.keys(responseHeaders)
      if (headerKeys.length > 0) {
        metaLines.push('Headers:')
        for (const key of headerKeys) {
          metaLines.push(`  ${key}: ${responseHeaders[key]}`)
        }
      }

      outputText += `\n${metaLines.join('\n')}`

      // Apply truncation
      const truncation = truncateHead(outputText, {
        maxLines: DEFAULT_MAX_LINES,
        maxBytes: DEFAULT_MAX_BYTES,
      })

      const details: WebFetchDetails = {
        metadata: {
          url: response.url,
          status: response.status,
          statusText: response.statusText,
          contentType,
          contentCategory: parsed.type === 'binary' ? 'binary' : parsed.type === 'json' ? 'json' : parsed.type === 'html' ? 'html' : parsed.type === 'text' ? 'text' : 'unknown',
          contentLength,
          redirectChain,
          elapsedTimeMs,
        },
        parsed,
        truncated: false,
      }

      if (truncation.truncated) {
        // Save full output to temp file
        const tempDir = join(tmpdir(), `pi-web-fetch-${Date.now()}`)
        await mkdir(tempDir, { recursive: true })
        const tempFile = join(tempDir, 'response.txt')
        await writeFile(tempFile, outputText, 'utf-8')

        details.truncated = true
        details.fullOutputPath = tempFile

        const truncatedLines = truncation.totalLines - truncation.outputLines
        const truncatedBytes = truncation.totalBytes - truncation.outputBytes

        outputText = truncation.content
        outputText += `\n\n[Output truncated: showing ${truncation.outputLines} of ${truncation.totalLines} lines`
        outputText += ` (${formatSize(truncation.outputBytes)} of ${formatSize(truncation.totalBytes)}).`
        outputText += ` ${truncatedLines} lines (${formatSize(truncatedBytes)}) omitted.`
        outputText += ` Full output saved to: ${tempFile}]`
      }

      return {
        content: [{ type: 'text', text: outputText }],
        details,
      }
    },

    // --- Custom rendering ---

    renderCall(args, theme, context) {
      const text = (context.lastComponent as Text | undefined) ?? new Text('', 0, 0)
      const method = args.method ?? 'GET'
      let content = theme.fg('toolTitle', theme.bold('web_fetch '))
      content += theme.fg('muted', `${method} `)
      content += theme.fg('accent', args.url)
      if (args.raw)
        content += theme.fg('dim', ' [raw]')
      text.setText(content)
      return text
    },

    renderResult(result, { expanded, isPartial }, theme, _context) {
      if (isPartial) {
        return new Text(theme.fg('warning', 'Fetching...'), 0, 0)
      }

      const details = result.details as WebFetchDetails | undefined
      if (!details) {
        return new Text(theme.fg('dim', 'No details'), 0, 0)
      }

      const m = details.metadata

      // Status color
      let statusColor: 'success' | 'warning' | 'error' | 'accent' | 'muted' | 'dim' | 'toolTitle' = 'success'
      if (m.status >= 400)
        statusColor = 'error'
      else if (m.status >= 300)
        statusColor = 'warning'

      let text = theme.fg(statusColor, `${m.status} `)
      text += theme.fg('muted', `${m.contentCategory} · ${formatSize(m.contentLength)} · ${m.elapsedTimeMs}ms`)

      if (details.truncated) {
        text += ` ${theme.fg('warning', '(truncated)')}`
      }

      if (expanded) {
        const content = result.content[0]
        if (content?.type === 'text') {
          const lines = content.text.split('\n').slice(0, 40)
          for (const line of lines) {
            text += `\n${theme.fg('dim', line)}`
          }
          if (content.text.split('\n').length > 40) {
            text += `\n${theme.fg('muted', '... (use read tool for full output)')}`
          }
        }

        if (details.fullOutputPath) {
          text += `\n${theme.fg('dim', `Full output: ${details.fullOutputPath}`)}`
        }
      }

      return new Text(text, 0, 0)
    },
  })
}
