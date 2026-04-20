/**
 * Types for the web-fetch extension.
 */

/** Supported HTTP methods for the web_fetch tool. */
export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE' | 'HEAD' | 'OPTIONS'

/** Response content type categories. */
export type ContentCategory = 'json' | 'html' | 'text' | 'binary' | 'unknown'

/** Metadata about a fetched URL response. */
export interface FetchMetadata {
  url: string
  status: number
  statusText: string
  contentType: string
  contentCategory: ContentCategory
  contentLength: number
  redirectChain: string[]
  elapsedTimeMs: number
}

/** Parsed result for JSON responses. */
export interface JsonContent {
  type: 'json'
  data: unknown
}

/** Parsed result for HTML responses. */
export interface HtmlContent {
  type: 'html'
  title: string
  description: string
  headings: Array<{ level: number, text: string }>
  links: Array<{ text: string, href: string }>
  text: string
  metadata: Record<string, string>
}

/** Parsed result for plain text responses. */
export interface TextContent {
  type: 'text'
  text: string
}

/** Result for binary/unknown responses. */
export interface RawContent {
  type: 'binary' | 'unknown'
  sizeBytes: number
  contentType: string
}

/** Union of all parsed content types. */
export type ParsedContent = JsonContent | HtmlContent | TextContent | RawContent

/** Details object returned alongside the tool content. */
export interface WebFetchDetails {
  metadata: FetchMetadata
  parsed: ParsedContent
  truncated: boolean
  fullOutputPath?: string
}

/** Input parameters for the web_fetch tool. */
export interface WebFetchParams {
  url: string
  method?: HttpMethod
  headers?: Record<string, string>
  body?: string
  raw?: boolean
}
