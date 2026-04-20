/**
 * Response formatting utilities
 *
 * Provides clean formatting for different content types so the LLM
 * receives structured, useful output instead of raw HTTP data.
 */

import type { FetchResponse } from './types.js'
import { formatSize } from '@mariozechner/pi-coding-agent'

/**
 * Format a JSON response for clean LLM consumption.
 */
export function formatJson(body: string): string {
  try {
    const parsed = JSON.parse(body)
    return JSON.stringify(parsed, null, 2)
  }
  catch {
    // Not valid JSON — return as-is
    return body
  }
}

/**
 * Format a plain text response.
 */
export function formatText(body: string): string {
  return body
}

/**
 * Format the full fetch response into a text summary for the LLM.
 */
export function formatResponse(
  response: FetchResponse,
  maxLength: number,
): string {
  const { status, statusText, headers, body, truncated, totalBytes } = response

  const parts: string[] = []

  // Status line
  parts.push(`Status: ${status} ${statusText}`)

  // Selected headers
  const interestingHeaders = [
    'content-type',
    'content-length',
    'location',
    'cache-control',
    'last-modified',
    'etag',
    'x-ratelimit-remaining',
  ]

  const headerLines: string[] = []
  for (const key of interestingHeaders) {
    const value = headers[key]
    if (value) {
      headerLines.push(`${key}: ${value}`)
    }
  }
  if (headerLines.length > 0) {
    parts.push(`Headers:\n${headerLines.map(h => `  ${h}`).join('\n')}`)
  }

  // Body
  parts.push(`\n${body}`)

  // Truncation notice
  if (truncated) {
    parts.push(
      `\n[Response truncated: showed ${formatSize(maxLength)} of ${formatSize(totalBytes)}. `
      + `Use head=true for more efficient fetching of large pages.]`,
    )
  }

  return parts.join('\n')
}
