/**
 * Web fetch tool implementation
 *
 * Registers a `web_fetch` tool that makes HTTP requests and returns
 * clean, parsed content. HTML is converted to readable plain text,
 * JSON is pretty-printed, and other content types are passed through.
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import type { FetchResponse, WebFetchParams } from './types.js'
import { Buffer } from 'node:buffer'
import { StringEnum } from '@mariozechner/pi-ai'
import { DEFAULT_MAX_BYTES, truncateHead } from '@mariozechner/pi-coding-agent'
import { Type } from '@sinclair/typebox'
import { htmlToText } from './html-parser.js'
import { formatJson, formatResponse, formatText } from './response-formatter.js'

const DEFAULT_TIMEOUT = 15_000
const MAX_BODY_BYTES = 5_000_000 // generous raw limit — parsed output is capped by maxBytes/head
const DEFAULT_MAX_BYTES_OUTPUT = DEFAULT_MAX_BYTES // LLM-facing cap after processing

/**
 * Determine the content category from a Content-Type header.
 */
function categorizeContentType(ct: string): 'html' | 'json' | 'text' | 'other' {
  const lower = ct.toLowerCase()
  if (lower.includes('text/html') || lower.includes('application/xhtml'))
    return 'html'
  if (lower.includes('application/json') || lower.includes('+json'))
    return 'json'
  if (lower.includes('text/'))
    return 'text'
  return 'other'
}

/**
 * Parse a response body into clean text based on content type.
 */
function parseBody(body: string, contentType: string): string {
  const category = categorizeContentType(contentType)

  switch (category) {
    case 'html':
      return htmlToText(body)
    case 'json':
      return formatJson(body)
    case 'text':
      return formatText(body)
    default:
      // For binary or unknown types, return a short summary
      return `[Binary/unsupported content type: ${contentType} (${body.length} bytes)]`
  }
}

/**
 * Extract the text encoding from a Content-Type header.
 * Falls back to utf-8.
 */
function extractEncoding(contentType: string): string {
  const match = contentType.match(/charset=([^\s;]+)/i)
  return match ? match[1]!.toLowerCase() : 'utf-8'
}

/**
 * Perform the actual HTTP fetch.
 */
async function performFetch(
  params: WebFetchParams,
  signal: AbortSignal,
): Promise<FetchResponse> {
  const {
    url,
    method = 'GET',
    headers: customHeaders = {},
    body: reqBody,
    timeout = DEFAULT_TIMEOUT / 1000,
    head,
  } = params

  // Build fetch options
  const fetchHeaders: Record<string, string> = {
    'User-Agent': 'pi-web-fetch/1.0',
    'Accept': 'text/html,application/xhtml+xml,application/json,text/plain,*/*',
    ...customHeaders,
  }

  const fetchOptions: RequestInit = {
    method,
    headers: fetchHeaders,
    signal,
    redirect: 'follow',
  }

  // Only attach body for methods that support it
  if (reqBody && !['GET', 'HEAD'].includes(method.toUpperCase())) {
    fetchOptions.body = reqBody
  }

  // Create a timeout controller
  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), timeout * 1000)

  // Combine with the external signal
  const combinedSignal = signal.aborted
    ? signal
    : AbortSignal.any([signal, controller.signal])

  fetchOptions.signal = combinedSignal

  try {
    const response = await fetch(url, fetchOptions)

    // Normalise response headers
    const headers: Record<string, string> = {}
    response.headers.forEach((value, key) => {
      headers[key.toLowerCase()] = value
    })

    const contentType = headers['content-type'] ?? 'application/octet-stream'
    const statusText = response.statusText || getStatusText(response.status)

    // Check response size before reading (Content-Length hint)
    const contentLength = headers['content-length']
    if (contentLength && Number.parseInt(contentLength, 10) > MAX_BODY_BYTES) {
      return {
        status: response.status,
        statusText,
        headers,
        body: `[Response too large: ${contentLength} bytes. Use head parameter to limit output.]`,
        contentType,
        truncated: false,
        totalBytes: Number.parseInt(contentLength, 10),
      }
    }

    // Read body as text
    const encoding = extractEncoding(contentType)
    const rawBody = await response.text()
    const totalBytes = Buffer.byteLength(rawBody, encoding as BufferEncoding)

    // Early bail for oversized bodies
    if (totalBytes > MAX_BODY_BYTES) {
      return {
        status: response.status,
        statusText,
        headers,
        body: `[Response too large: ${totalBytes} bytes (limit: ${MAX_BODY_BYTES}). Use head parameter to limit output.]`,
        contentType,
        truncated: false,
        totalBytes,
      }
    }

    // Parse body into clean text
    let parsed = parseBody(rawBody, contentType)

    // Apply head limit (character count on parsed text)
    if (head && parsed.length > head) {
      parsed = `${parsed.slice(0, head)}\n[...truncated at ${head} characters of ${parsed.length}]`
    }

    // Apply maxBytes truncation for LLM output
    const maxBytes = params.maxBytes ?? DEFAULT_MAX_BYTES_OUTPUT
    const truncation = truncateHead(parsed, {
      maxLines: 2000,
      maxBytes,
    })

    return {
      status: response.status,
      statusText,
      headers,
      body: truncation.content,
      contentType,
      truncated: truncation.truncated,
      totalBytes,
    }
  }
  catch (error) {
    if (error instanceof DOMException && error.name === 'AbortError') {
      throw new Error(`Request timed out after ${timeout}s`)
    }
    throw error
  }
  finally {
    clearTimeout(timeoutId)
  }
}

/**
 * Get a human-readable status text for common HTTP codes.
 */
function getStatusText(status: number): string {
  const map: Record<number, string> = {
    200: 'OK',
    201: 'Created',
    204: 'No Content',
    301: 'Moved Permanently',
    302: 'Found',
    304: 'Not Modified',
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    429: 'Too Many Requests',
    500: 'Internal Server Error',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
  }
  return map[status] ?? 'Unknown'
}

/**
 * Fetch llms.txt for a given domain.
 * Tries /llms.txt first, then /.well-known/llms.txt.
 */
async function fetchLlmsTxt(url: string, signal: AbortSignal): Promise<{ text: string, found: boolean, llmsTxtUrl: string }> {
  let origin: string
  try {
    origin = new URL(url).origin
  }
  catch {
    throw new Error(`Invalid URL: ${url}`)
  }

  const paths = [`${origin}/llms.txt`, `${origin}/.well-known/llms.txt`]

  for (const path of paths) {
    try {
      const response = await fetch(path, {
        signal,
        headers: { Accept: 'text/plain,text/markdown,*/*' },
        redirect: 'follow',
      })

      if (response.ok) {
        const text = await response.text()
        return {
          text: text.trim() || `[llms.txt found at ${path} but is empty]`,
          found: true,
          llmsTxtUrl: path,
        }
      }
    }
    catch {
      // Try next path
    }
  }

  return {
    text: `No llms.txt found for ${origin}. Tried:\n  ${paths.join('\n  ')}`,
    found: false,
    llmsTxtUrl: '',
  }
}

/**
 * Register the web_fetch tool with the Pi extension API.
 */
export function registerWebFetchTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: 'web_fetch',
    label: 'Web Fetch',
    description:
      'Fetch a URL and return clean, parsed content. HTML is converted to readable plain text (tags, scripts, and styles stripped). JSON is pretty-printed. Other content types are noted but not parsed.',
    promptSnippet:
      'Fetch a URL and return clean, readable content (HTML→text, JSON→formatted)',
    promptGuidelines: [
      'Use web_fetch instead of curl when you need to read web pages, APIs, or any HTTP resource.',
      'The response is automatically parsed — HTML becomes plain text, JSON is pretty-printed.',
      'Use the head parameter (e.g., head=3000) to limit output from large pages.',
      'Set raw=true to include response headers and metadata in the output.',
      'Set llms_txt=true to read the domain\'s llms.txt file instead of the URL itself.',
      'For POST/PUT requests, provide method, headers, and body as needed.',
    ],
    parameters: Type.Object({
      url: Type.String({ description: 'URL to fetch' }),
      method: Type.Optional(
        StringEnum(['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'] as const),
      ),
      headers: Type.Optional(
        Type.Record(Type.String(), Type.String(), {
          description: 'Request headers as key-value pairs',
        }),
      ),
      body: Type.Optional(
        Type.String({ description: 'Request body (for POST/PUT/PATCH)' }),
      ),
      maxBytes: Type.Optional(
        Type.Number({
          description: `Maximum output size in bytes (default: ${DEFAULT_MAX_BYTES_OUTPUT})`,
        }),
      ),
      timeout: Type.Optional(
        Type.Number({
          description: 'Request timeout in seconds (default: 15)',
        }),
      ),
      head: Type.Optional(
        Type.Number({
          description: 'Return only the first N characters of parsed body',
        }),
      ),
      raw: Type.Optional(
        Type.Boolean({
          description: 'Include full response metadata (status, headers)',
        }),
      ),
      llms_txt: Type.Optional(
        Type.Boolean({
          description: 'Read llms.txt for the domain instead of the URL itself. Tries /llms.txt then /.well-known/llms.txt',
        }),
      ),
    }),

    async execute(_toolCallId, params, signal, onUpdate, _ctx) {
      onUpdate?.({
        content: [{ type: 'text', text: `Fetching ${params.url}...` }],
        details: {},
      })

      try {
        // Handle llms.txt mode
        if (params.llms_txt) {
          const result = await fetchLlmsTxt(params.url, signal!)
          return {
            content: [{ type: 'text', text: result.text }],
            details: {
              url: params.url,
              found: result.found,
              llms_txt_url: result.llmsTxtUrl,
            } as Record<string, unknown>,
          }
        }

        const response = await performFetch(params, signal!)

        // If raw mode is off and response is OK, keep output minimal
        const text = params.raw
          ? formatResponse(response, params.maxBytes ?? DEFAULT_MAX_BYTES_OUTPUT)
          : response.body

        return {
          content: [{ type: 'text', text }],
          details: {
            url: params.url,
            status: response.status,
            contentType: response.contentType,
            truncated: response.truncated,
            totalBytes: response.totalBytes,
          } as Record<string, unknown>,
        }
      }
      catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        throw new Error(`web_fetch failed for ${params.url}: ${message}`)
      }
    },
  })
}
