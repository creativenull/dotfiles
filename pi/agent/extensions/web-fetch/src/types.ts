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
  /** Try to read llms.txt for the domain instead of the URL itself */
  llms_txt?: boolean
}

/** Search tool parameters */
export interface WebSearchParams {
  /** Search query */
  query: string
  /** Source to search (default: all) */
  source?: 'stackoverflow' | 'github' | 'all'
  /** GitHub search type, only used when source is github (default: repositories) */
  github_type?: 'repositories' | 'code' | 'issues'
  /** Max results per source (default: 5, max: 10) */
  limit?: number
}

/** StackOverflow question from API */
export interface SOQuestion {
  question_id: number
  title: string
  link: string
  score: number
  answer_count: number
  is_answered: boolean
  tags: string[]
  view_count: number
  creation_date: number
}

/** GitHub repository from API */
export interface GHRepo {
  full_name: string
  description: string | null
  html_url: string
  stargazers_count: number
  language: string | null
  forks_count: number
  updated_at: string
}

/** GitHub issue from API */
export interface GHIssue {
  title: string
  html_url: string
  state: string
  number: number
  body: string | null
  created_at: string
  user: { login: string }
}

/** GitHub code result from API */
export interface GHCodeItem {
  name: string
  path: string
  html_url: string
  repository: { full_name: string, description: string | null }
}
