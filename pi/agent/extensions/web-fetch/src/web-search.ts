/**
 * Web search tool - search the web using DuckDuckGo (free, no API key)
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import { Type } from '@sinclair/typebox'
import { cleanJinaMarkdown, fetchWithJinaReader, searchDuckDuckGo } from './duckduckgo-search.js'

const DEFAULT_LIMIT = 5
const MAX_LIMIT = 10

/**
 * Format search results for display
 */
function formatSearchResults(results: Array<{ title: string, url: string, snippet?: string, score?: number, source: string }>): string {
  if (results.length === 0) {
    return 'No search results found.'
  }

  const lines: string[] = [`## Search Results (${results.length} result${results.length > 1 ? 's' : ''})`, '']

  for (let i = 0; i < results.length; i++) {
    const result = results[i]!
    lines.push(`${i + 1}. **${result.title}**`)
    lines.push(`   ${result.url}`)

    if (result.snippet) {
      const snippet = result.snippet.length > 200
        ? `${result.snippet.slice(0, 200)}...`
        : result.snippet
      lines.push(`   ${snippet}`)
    }

    lines.push('')
  }

  return lines.join('\n')
}

/**
 * Register the web_search tool
 */
export function registerWebSearchTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: 'web_search',
    label: 'Web Search',
    description: 'Search the web using DuckDuckGo (free, no API key). Optionally fetch and read the content of results using Jina Reader.',
    promptSnippet: 'Search the web and optionally fetch content from results',
    promptGuidelines: [
      'Use web_search to find information online when you need to answer questions.',
      'Search uses DuckDuckGo\'s free API (no authentication required).',
      'Set fetchContent=true to fetch and return full content of top search result',
      'Use maxContentLength to control how much content is fetched (default: 10000 characters).',
      'Use limit to control how many search results to return (default: 5, max: 10).',
      'Use web_fetch to fetch specific URLs directly when you know the exact address.',
      'Jina Reader converts web pages to clean Markdown for better processing.',
    ],
    parameters: Type.Object({
      query: Type.String({ description: 'Search query' }),
      limit: Type.Optional(
        Type.Number({ description: 'Max search results to return (default: 5, max: 10)' }),
      ),
      fetchContent: Type.Optional(
        Type.Boolean({ description: 'Fetch and return full content of top search result (default: false)' }),
      ),
      maxContentLength: Type.Optional(
        Type.Number({ description: 'Max characters of content to fetch when fetchContent=true (default: 10000)' }),
      ),
    }),

    async execute(_toolCallId, params, signal, onUpdate, _ctx) {
      const { query, limit = DEFAULT_LIMIT, fetchContent: shouldFetch = false, maxContentLength = 10000 } = params

      const cappedLimit = Math.min(Math.max(1, limit), MAX_LIMIT)

      onUpdate?.({
        content: [{ type: 'text', text: `Searching for "${query}"...` }],
        details: {},
      })

      try {
        // Search using DuckDuckGo
        const results = await searchDuckDuckGo(query, { limit: cappedLimit, signal })
        const formattedResults = formatSearchResults(results)

        // Optionally fetch content
        if (shouldFetch && results.length > 0) {
          onUpdate?.({
            content: [{ type: 'text', text: `Found ${results.length} result${results.length > 1 ? 's' : ''}. Fetching content...` }],
            details: {},
          })

          try {
            const { markdown } = await fetchWithJinaReader(results[0]!.url, { signal })
            const cleaned = cleanJinaMarkdown(markdown)
            const truncated = cleaned.slice(0, maxContentLength)

            const fullContent = `${formattedResults}\n\n---\n\n## Fetched Content\n\n${truncated}`

            onUpdate?.({
              content: [{ type: 'text', text: `✓ Found ${results.length} result${results.length > 1 ? 's' : ''} and fetched content` }],
              details: {},
            })

            return {
              content: [{ type: 'text', text: fullContent }],
              details: {
                query,
                resultCount: results.length,
                fetchedContentLength: truncated.length,
                hasFetchedContent: true,
              },
            }
          }
          catch (fetchError) {
            const message = fetchError instanceof Error ? fetchError.message : String(fetchError)
            onUpdate?.({
              content: [{ type: 'text', text: `✓ Found ${results.length} result${results.length > 1 ? 's' : ''} (content fetch failed)` }],
              details: {},
            })

            return {
              content: [{ type: 'text', text: formattedResults }],
              details: {
                query,
                resultCount: results.length,
                hasFetchedContent: false,
                fetchError: message,
              },
            }
          }
        }

        onUpdate?.({
          content: [{ type: 'text', text: `✓ Found ${results.length} result${results.length > 1 ? 's' : ''} for "${query}"` }],
          details: {},
        })

        return {
          content: [{ type: 'text', text: formattedResults }],
          details: {
            query,
            resultCount: results.length,
            hasFetchedContent: false,
          },
        }
      }
      catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        throw new Error(`web_search failed: ${message}`)
      }
    },
  })
}
