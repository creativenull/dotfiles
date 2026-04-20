/**
 * Type definitions for the web-fetch extension
 */

/** Parsed fetch response */
export interface FetchResponse {
  /** HTTP status code */
  status: number
  /** HTTP status text */
  statusText: string
  /** Normalised lowercase response headers */
  headers: Record<string, string>
  /** Processed body text (HTML converted to plain text, JSON formatted) */
  body: string
  /** Raw content type from the response */
  contentType: string
  /** Whether the body was truncated */
  truncated: boolean
  /** Total bytes of the raw body before processing */
  totalBytes: number
}

/** Tool input parameters */
export interface WebFetchParams {
  /** URL to fetch */
  url: string
  /** HTTP method (default: GET) */
  method?: string
  /** JSON object of headers to send */
  headers?: Record<string, string>
  /** Request body (for POST/PUT/PATCH) */
  body?: string
  /** Maximum response body size in bytes (default: 50_000) */
  maxBytes?: number
  /** Request timeout in seconds (default: 15) */
  timeout?: number
  /** Return only the first N characters of the body (default: none) */
  head?: number
  /** Whether to include raw response metadata (default: false) */
  raw?: boolean
}
