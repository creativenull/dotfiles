/**
 * Core HTTP fetcher with timeout and truncation support
 */

import { Buffer } from 'node:buffer'
import { truncateHead } from '@mariozechner/pi-coding-agent'

const DEFAULT_TIMEOUT = 15000 // ms
const DEFAULT_MAX_BYTES = 50000
const MAX_BODY_BYTES = 5000000

/**
 * Fetch a URL with timeout
 */
export async function fetchUrl(
  url: string,
  options: { timeout?: number, signal?: AbortSignal, headers?: Record<string, string> } = {},
): Promise<{ body: string, status: number, contentType: string, totalBytes: number, headers: Record<string, string> }> {
  const { timeout = DEFAULT_TIMEOUT, signal, headers = {} } = options

  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), timeout)

  const combinedSignal = signal ? AbortSignal.any([signal, controller.signal]) : controller.signal

  const response = await fetch(url, {
    headers: {
      'User-Agent': 'pi-web-fetch/1.0',
      'Accept': 'text/html,application/json,text/plain,*/*',
      ...headers,
    },
    signal: combinedSignal,
    redirect: 'follow',
  })

  clearTimeout(timeoutId)

  // Normalize headers
  const responseHeaders: Record<string, string> = {}
  response.headers.forEach((value, key) => {
    responseHeaders[key.toLowerCase()] = value
  })

  const contentType = responseHeaders['content-type'] ?? 'application/octet-stream'

  // Check content length
  const contentLength = responseHeaders['content-length']
  if (contentLength && Number.parseInt(contentLength, 10) > MAX_BODY_BYTES) {
    return {
      body: `[Response too large: ${contentLength} bytes]`,
      status: response.status,
      contentType,
      totalBytes: Number.parseInt(contentLength, 10),
      headers: responseHeaders,
    }
  }

  // Read body
  const rawBody = await response.text()
  const totalBytes = Buffer.byteLength(rawBody, 'utf-8')

  if (totalBytes > MAX_BODY_BYTES) {
    return {
      body: `[Response too large: ${totalBytes} bytes]`,
      status: response.status,
      contentType,
      totalBytes,
      headers: responseHeaders,
    }
  }

  return {
    body: rawBody,
    status: response.status,
    contentType,
    totalBytes,
    headers: responseHeaders,
  }
}

/**
 * Parse HTML to plain text
 */
export function htmlToText(html: string): string {
  // Remove script and style tags with content
  let text = html.replace(/<(script|style)[\s\S]*?<\/\1>/gi, '')

  // Remove HTML comments
  text = text.replace(/<!--[\s\S]*?-->/g, '')

  // Decode HTML entities
  const entities: Record<string, string> = {
    '&nbsp;': ' ',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&apos;': '\'',
    '&#39;': '\'',
    '&#34;': '"',
  }

  text = text.replace(/&[#\w]+;/g, entity => entities[entity] || entity)

  // Remove HTML tags
  text = text.replace(/<[^>]+>/g, '')

  // Normalize whitespace
  text = text.replace(/\s+/g, ' ').trim()

  return text
}

/**
 * Parse JSON to formatted string
 */
export function jsonToText(json: string): string {
  try {
    const parsed = JSON.parse(json)
    return JSON.stringify(parsed, null, 2)
  }
  catch {
    return json
  }
}

/**
 * Get content type category
 */
export function getContentType(contentType: string): 'html' | 'json' | 'text' | 'other' {
  const lower = contentType.toLowerCase()

  if (lower.includes('text/html') || lower.includes('application/xhtml'))
    return 'html'
  if (lower.includes('application/json') || lower.includes('+json'))
    return 'json'
  if (lower.includes('text/'))
    return 'text'

  return 'other'
}

/**
 * Process body based on content type
 */
export function processBody(body: string, contentType: string): string {
  const type = getContentType(contentType)

  switch (type) {
    case 'html':
      return htmlToText(body)
    case 'json':
      return jsonToText(body)
    default:
      return body.trim()
  }
}

/**
 * Truncate content
 */
export function truncateContent(content: string, options: { maxBytes?: number, head?: number } = {}): { content: string, truncated: boolean } {
  const { maxBytes = DEFAULT_MAX_BYTES, head } = options

  let result = content

  // Apply head limit
  if (head && result.length > head) {
    result = `${result.slice(0, head)}\n[...truncated at ${head} characters of ${content.length}]`
  }

  // Apply maxBytes limit
  const truncation = truncateHead(result, {
    maxLines: 2000,
    maxBytes,
  })

  return {
    content: truncation.content,
    truncated: truncation.truncated,
  }
}
