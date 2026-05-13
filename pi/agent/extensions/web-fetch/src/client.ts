/**
 * Jina AI Reader API client
 *
 * Uses r.jina.ai to fetch and parse web content, handling:
 * - Static HTML pages
 * - JavaScript-rendered content (SPA hydration)
 * - Converting to clean markdown
 *
 * API Documentation: https://jina.ai/reader/
 */

import type { JinaReaderOptions, JinaReaderResponse } from './types'
import process from 'node:process'

const JINA_READER_BASE_URL = 'https://r.jina.ai'

/**
 * Get the API key from environment variable
 */
export function getApiKey(): string | null {
  return process.env.JINA_AI_READER_API_KEY ?? null
}

/**
 * Check if the API key is configured
 */
export function isConfigured(): boolean {
  return getApiKey() !== null
}

/**
 * Fetch and parse a URL using Jina AI Reader
 *
 * The Reader API handles:
 * - Following redirects
 * - Rendering JavaScript (for SPA content)
 * - Extracting main content (removing nav, ads, etc.)
 * - Converting to clean markdown
 */
export async function fetchUrl(options: JinaReaderOptions): Promise<JinaReaderResponse> {
  const {
    url,
    format = 'markdown',
    timeout = 30000,
    maxContentLength = 50000,
  } = options

  const apiKey = getApiKey()
  if (!apiKey) {
    throw new Error('JINA_AI_READER_API_KEY is missing')
  }

  // Build the reader URL with the target URL
  const readerUrl = `${JINA_READER_BASE_URL}/${url}`

  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), timeout)

  try {
    const response = await fetch(readerUrl, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Accept': format === 'html' ? 'text/html' : 'text/markdown',
        'X-With-Generated-Alt': 'true', // Include generated alt text for images
      },
      signal: controller.signal,
    })

    clearTimeout(timeoutId)

    if (!response.ok) {
      const errorText = await response.text().catch(() => 'Unknown error')
      throw new Error(`Jina Reader API error (${response.status}): ${errorText}`)
    }

    const content = await response.text()
    const finalUrl = response.headers.get('x-final-url') ?? url
    const title = response.headers.get('x-title') ?? undefined
    const contentType = response.headers.get('content-type') ?? undefined

    // Extract headers we care about
    const headers: Record<string, string> = {}
    response.headers.forEach((value, key) => {
      headers[key] = value
    })

    // Check if we need to truncate
    const truncated = content.length > maxContentLength
    const finalContent = truncated
      ? `${content.slice(0, maxContentLength)}\n\n[...content truncated...]`
      : content

    return {
      content: finalContent,
      url: finalUrl,
      status: response.status,
      headers,
      truncated,
      contentType,
      title: title ? decodeURIComponent(title) : undefined,
    }
  }
  catch (error) {
    clearTimeout(timeoutId)

    if (error instanceof Error && error.name === 'AbortError') {
      throw new Error(`Request timed out after ${timeout}ms`)
    }
    throw error
  }
}

/**
 * Test the API key by making a simple request
 */
export async function testApiKey(): Promise<boolean> {
  if (!isConfigured()) {
    return false
  }

  try {
    // Use a simple, reliable URL for testing
    await fetchUrl({
      url: 'https://example.com',
      timeout: 10000,
      maxContentLength: 1000,
    })
    return true
  }
  catch {
    return false
  }
}
