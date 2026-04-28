/**
 * Jina AI integration - Reader API and search utilities
 */

import type { JinaReaderResponse, SearchResult } from './types.js'
import { fetchUrl } from './fetcher.js'

const JINA_READER_BASE = 'https://r.jina.ai/'

/**
 * Fetch URL using Jina Reader API (converts to Markdown)
 * Free, no authentication required
 */
export async function fetchWithJinaReader(
  targetUrl: string,
  options: { signal?: AbortSignal, timeout?: number } = {},
): Promise<{ response: JinaReaderResponse, markdown: string }> {
  // Encode the target URL and prepend Jina Reader base
  const jinaUrl = `${JINA_READER_BASE}${targetUrl}`

  const result = await fetchUrl(jinaUrl, {
    timeout: options.timeout || 15000,
    signal: options.signal,
    headers: {
      Accept: 'text/markdown,text/plain,*/*',
    },
  })

  if (result.status !== 200) {
    throw new Error(`Jina Reader failed: ${result.status}`)
  }

  // Parse the response (Jina returns markdown)
  const markdown = result.body

  // Extract metadata from Jina's response format
  const response: JinaReaderResponse = {
    title: extractTitle(markdown) || 'Unknown',
    url: targetUrl,
    content: markdown,
    description: extractDescription(markdown) || undefined,
    publishedTime: extractPublishedTime(markdown) || undefined,
  }

  return { response, markdown }
}

/**
 * Extract title from Jina markdown response
 */
function extractTitle(markdown: string): string | null {
  const titleMatch = markdown.match(/^Title: (.+)$/m)
  return titleMatch ? titleMatch[1]!.trim() : null
}

/**
 * Extract description from Jina markdown response
 */
function extractDescription(markdown: string): string | null {
  const descMatch = markdown.match(/^URL Source: (.+)$/m)
  return descMatch ? descMatch[1]!.trim() : null
}

/**
 * Extract published time from Jina markdown response
 */
function extractPublishedTime(markdown: string): string | null {
  const timeMatch = markdown.match(/^Published Time: (.+)$/m)
  return timeMatch ? timeMatch[1]!.trim() : null
}

/**
 * Clean Jina metadata from markdown content
 * Removes the header section that Jina adds
 */
export function cleanJinaMarkdown(markdown: string): string {
  const lines = markdown.split('\n')

  // Find where the actual content starts (after the metadata header)
  let contentStart = 0
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!.trim()
    if (line.startsWith('Markdown Content:')) {
      contentStart = i + 1
      break
    }
  }

  if (contentStart > 0) {
    return lines.slice(contentStart).join('\n').trim()
  }

  return markdown
}

/**
 * Perform a simple search using DuckDuckGo's instant answer API
 * This is free and doesn't require authentication
 */
export async function searchDuckDuckGo(
  query: string,
  options: { limit?: number, signal?: AbortSignal } = {},
): Promise<SearchResult[]> {
  const { limit = 5 } = options

  // Use DuckDuckGo's instant answer API
  const url = `https://api.duckduckgo.com/?q=${encodeURIComponent(query)}&format=json&no_html=1&skip_disambig=1`

  const result = await fetchUrl(url, {
    signal: options.signal,
    headers: {
      Accept: 'application/json',
    },
  })

  if (result.status !== 200) {
    throw new Error(`DuckDuckGo search failed: ${result.status}`)
  }

  const data = JSON.parse(result.body)
  const results: SearchResult[] = []

  // Add the instant answer if available
  if (data.Abstract) {
    results.push({
      title: data.Heading || 'DuckDuckGo Answer',
      url: data.AbstractURL || data.AbstractSource || '',
      snippet: data.Abstract,
      score: 10,
      source: 'duckduckgo',
    })
  }

  // Add related topics as search results
  if (data.RelatedTopics && Array.isArray(data.RelatedTopics)) {
    for (const topic of data.RelatedTopics) {
      if (topic.FirstURL && topic.Text && results.length < limit) {
        results.push({
          title: topic.Text.split(' - ')[0] || 'Result',
          url: topic.FirstURL,
          snippet: topic.Text,
          score: 5,
          source: 'duckduckgo',
        })
      }
    }
  }

  return results.slice(0, limit)
}

/**
 * Perform a search and fetch content using Jina Reader
 * Combines search + content fetching
 */
export async function searchAndFetch(
  query: string,
  options: {
    limit?: number
    fetchContent?: boolean
    maxContentLength?: number
    signal?: AbortSignal
  } = {},
): Promise<{ searchResults: SearchResult[], fetchedContent?: string }> {
  const { limit = 3, fetchContent: shouldFetch = false, maxContentLength = 10000 } = options

  // Get search results
  const searchResults = await searchDuckDuckGo(query, { limit, signal: options.signal })

  if (!shouldFetch || searchResults.length === 0) {
    return { searchResults }
  }

  // Fetch content for the top result using Jina Reader
  try {
    const topResult = searchResults[0]!
    const { markdown } = await fetchWithJinaReader(topResult.url, { signal: options.signal })
    const cleaned = cleanJinaMarkdown(markdown)
    const truncated = cleaned.slice(0, maxContentLength)

    return {
      searchResults,
      fetchedContent: truncated,
    }
  }
  catch {
    // If fetching fails, return just search results
    return { searchResults }
  }
}
