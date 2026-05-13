/**
 * Types for the Jina AI Reader API
 */

export interface JinaReaderOptions {
  /** The URL to fetch and parse */
  url: string
  /** Whether to return content as markdown (default) or HTML */
  format?: 'markdown' | 'html'
  /** Custom timeout in milliseconds */
  timeout?: number
  /** Whether to follow redirects */
  followRedirects?: boolean
  /** Maximum content length to return (in characters) */
  maxContentLength?: number
}

export interface JinaReaderResponse {
  /** The parsed content (markdown or HTML) */
  content: string
  /** The final URL after any redirects */
  url: string
  /** HTTP status code */
  status: number
  /** Response headers */
  headers: Record<string, string>
  /** Whether the response was truncated */
  truncated: boolean
  /** Content type from the original response */
  contentType?: string
  /** Title extracted from the page (if available) */
  title?: string
}

export interface FetchResult {
  success: boolean
  content?: string
  url: string
  title?: string
  error?: string
  status?: number
  truncated?: boolean
}

export type FetchType = 'static' | 'js-rendered'

export interface WebFetchInput {
  url: string
  /** Override automatic detection and force a specific fetch type */
  forceType?: FetchType
  /** Maximum content length to return (in characters, default: 50000) */
  maxContentLength?: number
  /** Timeout in milliseconds (default: 30000) */
  timeout?: number
}
