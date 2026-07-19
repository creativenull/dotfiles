/**
 * Web Fetch Extension
 *
 * Fetches and parses web content using Jina AI Reader API.
 * Handles both static HTML and JavaScript-rendered content (SPAs).
 *
 * Features:
 * - Fetches content from any URL
 * - Automatically handles JS-rendered content
 * - Converts to clean markdown
 * - Extracts main content (removes nav, ads, etc.)
 * - Handles redirects and authentication
 *
 * Requirements:
 * - Set JINA_AI_READER_API_KEY environment variable
 * - Get a free API key at https://jina.ai/reader/
 */

import type { ExtensionAPI } from '@earendil-works/pi-coding-agent'
import type { WebFetchInput } from './types'
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

import { Type } from 'typebox'
import { fetchUrl, getApiKey, testApiKey } from './client'

/** Max chars to return directly to LLM. Above this, content goes to temp file. */
const DIRECT_CONTENT_LIMIT = 10000

/** Temp directory for large content files */
let tempDir: string | null = null

function getTempDir(): string {
  if (!tempDir) {
    tempDir = mkdtempSync(join(tmpdir(), 'pi-web-fetch-'))
  }
  return tempDir
}

function cleanupTempDir(): void {
  if (tempDir) {
    try {
      rmSync(tempDir, { recursive: true, force: true })
    }
    catch {}
    tempDir = null
  }
}

const WEB_FETCH_PARAMS = Type.Object({
  url: Type.String({
    description: 'The URL to fetch and parse (e.g., https://docs.example.com/api)',
  }),
  timeout: Type.Optional(Type.Number({
    description: 'Timeout in milliseconds (default: 30000)',
    minimum: 5000,
    maximum: 120000,
  })),
})

/**
 * Validates that the JINA_AI_READER_API_KEY is present and non-empty.
 * Throws an error if validation fails.
 */
function validateApiKey(): void {
  const apiKey = getApiKey()

  if (!apiKey || apiKey.trim() === '') {
    throw new Error('JINA_AI_READER_API_KEY is missing')
  }
}

export default async function webFetchExtension(pi: ExtensionAPI) {
  // Validate API key before extension loads
  validateApiKey()

  // Track API key status
  let apiKeyValid: boolean | null = null

  pi.on('session_start', async (_event, ctx) => {
    // Test API key validity on startup
    apiKeyValid = await testApiKey()
    if (!apiKeyValid) {
      ctx.ui.notify('Web Fetch: API key validation failed', 'warning')
    }
  })

  pi.on('session_shutdown', () => {
    cleanupTempDir()
  })

  pi.registerTool({
    name: 'web_fetch',
    label: 'Web Fetch',
    description: `Fetch and parse web content from any URL. Uses Jina AI Reader to handle JavaScript-rendered content (SPAs), extract main content, and convert to clean markdown.

Behavior:
- Content <= 10,000 characters: Returns directly to context
- Content > 10,000 characters: Saves to temp file, use \`rg\` to search

Best for:
- Documentation websites (React docs, API references, guides)
- Technical blogs and articles
- GitHub READMEs and wikis
- Any URL that might use JavaScript to render content

The tool automatically:
- Follows redirects
- Renders JavaScript if needed
- Extracts main content (removes navigation, ads, sidebars)
- Converts to readable markdown format`,
    promptSnippet: 'Fetch and parse web content from URLs',
    promptGuidelines: [
      'Use web_fetch when you need to read content from documentation websites or technical articles.',
      'web_fetch handles JavaScript-rendered content, making it suitable for modern docs sites.',
      'Provide the full URL including the protocol (https://).',
    ],
    parameters: WEB_FETCH_PARAMS,
    async execute(_toolCallId, params: WebFetchInput, signal, onUpdate, ctx) {
      const timeout = params.timeout ?? 30000

      // Validate URL
      let parsedUrl: URL
      try {
        parsedUrl = new URL(params.url)
      }
      catch {
        return {
          content: [{
            type: 'text',
            text: `Error: Invalid URL "${params.url}". Make sure to include the protocol (https://).`,
          }],
          details: {},
          isError: true,
        }
      }

      // Only allow http/https
      if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
        return {
          content: [{
            type: 'text',
            text: `Error: Unsupported protocol "${parsedUrl.protocol}". Only http and https are allowed.`,
          }],
          details: {},
          isError: true,
        }
      }

      // Notify user we're fetching
      onUpdate?.({
        content: [{ type: 'text', text: `Fetching ${params.url}...` }],
        details: {},
      })

      try {
        // Fetch with no truncation limit (we handle it ourselves)
        const result = await fetchUrl({
          url: params.url,
          format: 'markdown',
          maxContentLength: 500000,
          timeout,
        })

        const contentLength = result.content.length

        // If content is small enough, return directly
        if (contentLength <= DIRECT_CONTENT_LIMIT) {
          const parts: string[] = []
          if (result.title) {
            parts.push(`# ${result.title}\n`)
          }
          parts.push(`URL: ${result.url}`)
          parts.push(`\n---\n`)
          parts.push(result.content)

          return {
            content: [{ type: 'text', text: parts.join('\n') }],
            details: {
              url: result.url,
              title: result.title,
              contentLength,
              storedInFile: false,
            },
          }
        }

        // Content is large - write to temp file
        const tempPath = join(getTempDir(), `content-${Date.now()}.md`)

        // Build full content for file
        const fullContent: string[] = []
        if (result.title) {
          fullContent.push(`# ${result.title}`)
          fullContent.push(``)
        }
        fullContent.push(`URL: ${result.url}`)
        fullContent.push(`Fetched: ${new Date().toISOString()}`)
        fullContent.push(`Content-Length: ${contentLength} characters`)
        fullContent.push(``)
        fullContent.push(`---`)
        fullContent.push(``)
        fullContent.push(result.content)

        writeFileSync(tempPath, fullContent.join('\n'), 'utf-8')

        // Return minimal info to LLM with instructions
        return {
          content: [{
            type: 'text',
            text: `Fetched: ${result.url}
Title: ${result.title ?? 'N/A'}
Content: ${contentLength} characters (too large for direct context)

The full content has been saved to: ${tempPath}

Use \`rg\` to search for specific information in this file. For example:
- \`rg "signers" ${tempPath}\` - Find information about signers
- \`rg -i "retry" ${tempPath}\` - Case-insensitive search for retry-related content
- \`rg -C 3 "job" ${tempPath}\` - Search with context lines`,
          }],
          details: {
            url: result.url,
            title: result.title,
            contentLength,
            tempFile: tempPath,
            storedInFile: true,
          },
        }
      }
      catch (error) {
        const errorMessage = error instanceof Error ? error.message : 'Unknown error'

        ctx.ui.notify(`Web fetch failed: ${errorMessage}`, 'error')

        return {
          content: [{
            type: 'text',
            text: `Error fetching ${params.url}:\n${errorMessage}`,
          }],
          details: {},
          isError: true,
        }
      }
    },
  })

  // Command to check API key status
  pi.registerCommand('web-fetch-status', {
    description: 'Check web fetch API key status',
    handler: async (_args, ctx) => {
      const apiKey = getApiKey()
      if (!apiKey || apiKey.trim() === '') {
        ctx.ui.notify('JINA_AI_READER_API_KEY is not set', 'warning')
        return
      }

      ctx.ui.notify('Testing API key...', 'info')

      const valid = await testApiKey()
      if (valid) {
        ctx.ui.notify('API key is valid', 'info')
      }
      else {
        ctx.ui.notify('API key is invalid', 'error')
      }
    },
  })

  // Command to quickly fetch a URL (for user-initiated fetches)
  pi.registerCommand('fetch', {
    description: 'Fetch and parse a URL: /fetch <url>',
    getArgumentCompletions: (prefix: string) => {
      // Simple URL prefix completion
      if (prefix.startsWith('http')) {
        return [{ value: prefix, label: prefix }]
      }
      if (prefix.startsWith('www.')) {
        const url = `https://${prefix}`
        return [{ value: url, label: url }]
      }
      return null
    },
    handler: async (args, ctx) => {
      let url = args?.trim()

      if (!url) {
        ctx.ui.notify('Usage: /fetch <url>', 'warning')
        return
      }

      // Add https:// if no protocol
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = `https://${url}`
      }

      // Send as user message so the LLM processes the content
      pi.sendUserMessage(`Fetch and summarize the content from: ${url}`)
    },
  })
}
