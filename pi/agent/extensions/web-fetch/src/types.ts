/**
 * Type definitions for the web-fetch extension
 */

// ============================================================================
// Web Fetch Types
// ============================================================================

/** Fetch result */
export interface FetchResult {
  content: string
  metadata: FetchMetadata
}

/** Fetch metadata */
export interface FetchMetadata {
  url: string
  source: 'llms-txt' | 'html' | 'raw' | 'jina-reader'
  status?: number
  contentType?: string
  truncated?: boolean
  totalBytes?: number
  linkCount?: number
}

/** Fetch options */
export interface FetchOptions {
  url: string
  maxBytes?: number
  timeout?: number
  head?: number
}

// ============================================================================
// Web Search Types
// ============================================================================

/** Search result */
export interface SearchResult {
  title: string
  url: string
  snippet?: string
  score?: number
  source: string
}

/** Search options */
export interface SearchOptions {
  query: string
  limit?: number
  source?: string // 'jina', 'duckduckgo', etc.
}

// ============================================================================
// LLMs.txt Types
// ============================================================================

/** Document link */
export interface DocLink {
  title: string
  url: string
  description?: string
  section?: string
}

/** Parsed llms.txt */
export interface LlmsDocument {
  title: string
  description: string
  links: DocLink[]
}

// ============================================================================
// Documentation Site Types
// ============================================================================

/** Docs site config */
export interface DocsSite {
  name: string
  baseUrl: string
  llmsPath?: string
  docsPath?: string
  selector?: string
}

// ============================================================================
// Jina AI Types
// ============================================================================

/** Jina Reader response */
export interface JinaReaderResponse {
  title: string
  url: string
  content: string
  description?: string
  publishedTime?: string
}
