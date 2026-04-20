/**
 * Content-type detection and response parsing.
 */

import type { ContentCategory, ParsedContent, WebFetchParams } from './types.js'
import { parseHtml } from './html.js'

/**
 * Determine the content category from a Content-Type header.
 */
export function detectContentCategory(contentType: string): ContentCategory {
  const ct = contentType.toLowerCase()

  if (ct.includes('application/json') || ct.includes('text/json'))
    return 'json'

  if (ct.includes('text/html') || ct.includes('application/xhtml'))
    return 'html'

  if (ct.includes('text/') || ct.includes('application/xml') || ct.includes('text/xml'))
    return 'text'

  if (ct.includes('image/') || ct.includes('audio/') || ct.includes('video/') || ct.includes('application/pdf') || ct.includes('application/octet-stream'))
    return 'binary'

  return 'unknown'
}

/**
 * Parse response body into structured content based on content type.
 */
export function parseResponse(
  body: string | null,
  contentType: string,
  params: WebFetchParams,
): ParsedContent {
  if (params.raw || !body) {
    return {
      type: 'text',
      text: body ?? '(empty body)',
    }
  }

  const category = detectContentCategory(contentType)

  switch (category) {
    case 'json': {
      try {
        const data = JSON.parse(body)
        return { type: 'json', data }
      }
      catch {
        // Fallback to text if JSON parse fails
        return { type: 'text', text: body }
      }
    }

    case 'html': {
      return parseHtml(body)
    }

    case 'text': {
      return { type: 'text', text: body }
    }

    default: {
      return {
        type: 'binary' as const,
        sizeBytes: new TextEncoder().encode(body).byteLength,
        contentType,
      }
    }
  }
}

/**
 * Format parsed content into a human-readable text representation
 * suitable for sending to the LLM.
 */
export function formatParsedContent(parsed: ParsedContent): string {
  switch (parsed.type) {
    case 'json': {
      const formatted = JSON.stringify(parsed.data, null, 2)
      return `--- JSON Response ---\n${formatted}`
    }

    case 'html': {
      const parts: string[] = ['--- HTML Page ---']

      if (parsed.title)
        parts.push(`Title: ${parsed.title}`)
      if (parsed.description)
        parts.push(`Description: ${parsed.description}`)

      if (parsed.headings.length > 0) {
        parts.push('\n## Headings')
        for (const h of parsed.headings) {
          const indent = '  '.repeat(h.level - 1)
          parts.push(`${indent}${'#'.repeat(h.level)} ${h.text}`)
        }
      }

      if (parsed.links.length > 0) {
        parts.push(`\n## Links (${parsed.links.length})`)
        const maxLinks = 50
        for (const link of parsed.links.slice(0, maxLinks)) {
          parts.push(`- ${link.text} → ${link.href}`)
        }
        if (parsed.links.length > maxLinks) {
          parts.push(`  ... and ${parsed.links.length - maxLinks} more links`)
        }
      }

      if (parsed.text) {
        parts.push('\n## Content')
        parts.push(parsed.text)
      }

      return parts.join('\n')
    }

    case 'text': {
      return `--- Text Response ---\n${parsed.text}`
    }

    case 'binary':
    case 'unknown': {
      return `--- Binary Response ---
Content-Type: ${parsed.contentType}\nSize: ${parsed.sizeBytes} bytes`
    }
  }
}
