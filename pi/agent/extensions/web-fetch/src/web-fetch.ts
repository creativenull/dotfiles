/**
 * Web fetch tool - fetch URLs with clean parsed output
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import type { FetchMetadata } from './types.js'
import { StringEnum } from '@mariozechner/pi-ai'
import { Type } from '@sinclair/typebox'
import { cleanJinaMarkdown, fetchWithJinaReader } from './duckduckgo-search.js'
import { fetchUrl, processBody, truncateContent } from './fetcher.js'
import { fetchLlmsTxt, formatLlmsTxt, parseLlmsTxt } from './llms-txt.js'

const DEFAULT_PREVIEW_LENGTH = 500

/**
 * Create a preview of content for UI display
 */
function createPreview(content: string, maxLength: number): string {
  if (content.length <= maxLength) {
    return content
  }

  return `${content.slice(0, maxLength)}\n\n[... ${content.length - maxLength} more characters truncated in preview. Full content available for processing ...]`
}

/**
 * Fetch llms.txt for a domain
 */
async function fetchLlmsTxtMode(
  url: string,
  previewLength: number,
  signal?: AbortSignal,
): Promise<{ content: string, fullContent: string, metadata: FetchMetadata }> {
  const result = await fetchLlmsTxt(url, signal)

  if (result.found) {
    const doc = parseLlmsTxt(result.text)
    const formatted = formatLlmsTxt(doc, result.url)

    return {
      content: createPreview(formatted, previewLength),
      fullContent: formatted,
      metadata: {
        url,
        source: 'llms-txt',
        linkCount: doc.links.length,
      },
    }
  }

  return {
    content: createPreview(result.text, previewLength),
    fullContent: result.text,
    metadata: {
      url,
      source: 'llms-txt',
    },
  }
}

/**
 * Fetch HTML page and extract navigation links
 */
async function fetchHtmlMode(
  url: string,
  previewLength: number,
  signal?: AbortSignal,
): Promise<{ content: string, fullContent: string, metadata: FetchMetadata }> {
  const result = await fetchUrl(url, { signal })

  if (result.status !== 200) {
    const error = `Failed to fetch ${url}: ${result.status}`
    return {
      content: error,
      fullContent: error,
      metadata: {
        url,
        source: 'html',
        status: result.status,
      },
    }
  }

  // For HTML mode, we want to extract navigation links
  // This is a simplified approach - real implementation would be site-specific
  const content = processBody(result.body, result.contentType)
  const truncated = truncateContent(content)

  return {
    content: createPreview(truncated.content, previewLength),
    fullContent: truncated.content,
    metadata: {
      url,
      source: 'html',
      status: result.status,
      contentType: result.contentType,
      truncated: truncated.truncated,
      totalBytes: result.totalBytes,
    },
  }
}

/**
 * Fetch using Jina Reader API
 */
async function fetchJinaMode(
  url: string,
  previewLength: number,
  options: { timeout?: number },
  signal?: AbortSignal,
): Promise<{ content: string, fullContent: string, metadata: FetchMetadata }> {
  try {
    const { markdown } = await fetchWithJinaReader(url, {
      timeout: options.timeout,
      signal,
    })

    const cleaned = cleanJinaMarkdown(markdown)

    return {
      content: createPreview(cleaned, previewLength),
      fullContent: cleaned,
      metadata: {
        url,
        source: 'jina-reader',
        totalBytes: cleaned.length,
      },
    }
  }
  catch (error) {
    const message = error instanceof Error ? error.message : String(error)
    const errorText = `Jina Reader failed: ${message}`

    return {
      content: createPreview(errorText, previewLength),
      fullContent: errorText,
      metadata: {
        url,
        source: 'jina-reader',
      },
    }
  }
}

/**
 * Fetch raw content (direct URL)
 */
async function fetchRawMode(
  url: string,
  options: {
    maxBytes?: number
    timeout?: number
    head?: number
    raw?: boolean
    previewLength?: number
  },
  signal?: AbortSignal,
): Promise<{ content: string, fullContent: string, metadata: FetchMetadata }> {
  const { maxBytes, timeout, head, raw, previewLength = DEFAULT_PREVIEW_LENGTH } = options

  const result = await fetchUrl(url, {
    timeout,
    signal,
  })

  const processed = processBody(result.body, result.contentType)
  const truncated = truncateContent(processed, {
    maxBytes,
    head,
  })

  let processedContent = truncated.content

  if (raw) {
    const lines: string[] = []
    lines.push(`Status: ${result.status}`)
    lines.push(`Content-Type: ${result.contentType}`)
    lines.push(`Size: ${result.totalBytes.toLocaleString()} bytes`)

    if (truncated.truncated)
      lines.push(`Warning: Output was truncated`)

    lines.push('')
    lines.push('---')
    lines.push('')
    lines.push(processedContent)

    processedContent = lines.join('\n')
  }

  return {
    content: createPreview(processedContent, previewLength),
    fullContent: processedContent,
    metadata: {
      url,
      source: 'raw',
      status: result.status,
      contentType: result.contentType,
      truncated: truncated.truncated,
      totalBytes: result.totalBytes,
    },
  }
}

/**
 * Register the web_fetch tool
 */
export function registerWebFetchTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: 'web_fetch',
    label: 'Web Fetch',
    description: 'Fetch a URL and return clean, parsed content. Supports four modes: llms_txt (fetch llms.txt), html (fetch HTML), jina (Jina Reader API), or raw (fetch and parse any URL).',
    promptSnippet: 'Fetch a URL and return clean, readable content',
    promptGuidelines: [
      'Use mode=llms_txt to fetch the llms.txt file for a domain',
      'Use mode=jina to fetch using Jina Reader API (recommended for web pages - converts to clean Markdown)',
      'Use mode=html to fetch and parse HTML content',
      'By default, fetches the URL directly and parses the content (mode=raw)',
      'Set raw=true to include response metadata (status, headers)',
      'Use head=N to limit output to first N characters',
      'Use maxBytes=N to limit output size in bytes',
      'Use timeout=N to set request timeout in seconds',
      'Use previewLength=N to control how many characters are shown in the preview (default: 500)',
      'The tool displays a preview in the chat, but the full content is available for processing the user\'s question',
    ],
    parameters: Type.Object({
      url: Type.String({ description: 'URL to fetch' }),
      mode: Type.Optional(
        StringEnum(['llms_txt', 'html', 'jina', 'raw'] as const, {
          description: 'Fetch mode: llms_txt (fetch llms.txt), html (fetch HTML), jina (Jina Reader API), raw (fetch any URL). Default: raw',
        }),
      ),
      raw: Type.Optional(
        Type.Boolean({ description: 'Include response metadata (status, headers) in output' }),
      ),
      maxBytes: Type.Optional(
        Type.Number({ description: 'Maximum output size in bytes (default: 50000)' }),
      ),
      timeout: Type.Optional(
        Type.Number({ description: 'Request timeout in seconds (default: 15)' }),
      ),
      head: Type.Optional(
        Type.Number({ description: 'Return only first N characters of parsed body' }),
      ),
      previewLength: Type.Optional(
        Type.Number({ description: 'Number of characters to show in preview (default: 500). Full content is available for processing.' }),
      ),
    }),

    async execute(_toolCallId, params, signal, onUpdate, _ctx) {
      const { url, mode = 'raw', raw, maxBytes, timeout, head, previewLength = DEFAULT_PREVIEW_LENGTH } = params

      onUpdate?.({
        content: [{ type: 'text', text: `Fetching ${url}...` }],
        details: {},
      })

      try {
        let result: { content: string, fullContent: string, metadata: FetchMetadata }

        if (mode === 'llms_txt') {
          result = await fetchLlmsTxtMode(url, previewLength, signal)
        }
        else if (mode === 'html') {
          result = await fetchHtmlMode(url, previewLength, signal)
        }
        else if (mode === 'jina') {
          result = await fetchJinaMode(url, previewLength, { timeout }, signal)
        }
        else {
          result = await fetchRawMode(url, { maxBytes, timeout, head, raw, previewLength }, signal)
        }

        onUpdate?.({
          content: [{ type: 'text', text: `✓ Fetched ${result.metadata.totalBytes?.toLocaleString()} bytes from ${url}` }],
          details: result.metadata,
        })

        return {
          content: [{ type: 'text', text: result.content }],
          details: {
            ...result.metadata,
            fullContent: result.fullContent,
          },
        }
      }
      catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        throw new Error(`web_fetch failed: ${message}`)
      }
    },
  })
}
