/**
 * Web Search tool for programming queries
 *
 * Searches StackOverflow questions and GitHub repositories/code/issues.
 * Returns clean, formatted text suitable for LLM consumption.
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import type { GHCodeItem, GHIssue, GHRepo, SOQuestion } from './types.js'
import { StringEnum } from '@mariozechner/pi-ai'
import { Type } from '@sinclair/typebox'
import { searchDocs } from './docs-search.js'

const SO_API_BASE = 'https://api.stackexchange.com/2.3'
const GH_API_BASE = 'https://api.github.com'
const DEFAULT_LIMIT = 5
const MAX_LIMIT = 10

/**
 * Format a Unix timestamp into a human-readable relative date.
 */
function formatDate(unix: number): string {
  const d = new Date(unix * 1000)
  const now = new Date()
  const diff = (now.getTime() - d.getTime()) / 1000
  if (diff < 3600)
    return `${Math.floor(diff / 60)}m ago`
  if (diff < 86400)
    return `${Math.floor(diff / 3600)}h ago`
  if (diff < 2592000)
    return `${Math.floor(diff / 86400)}d ago`
  return d.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
}

/**
 * Format an ISO date string into a human-readable relative date.
 */
function formatISODate(iso: string): string {
  const d = new Date(iso)
  const now = new Date()
  const diff = (now.getTime() - d.getTime()) / 1000
  if (diff < 3600)
    return `${Math.floor(diff / 60)}m ago`
  if (diff < 86400)
    return `${Math.floor(diff / 3600)}h ago`
  if (diff < 2592000)
    return `${Math.floor(diff / 86400)}d ago`
  return d.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
}

/**
 * Strip HTML tags from a string.
 */
function stripHtml(html: string): string {
  return html.replace(/<[^>]+>/g, '').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&').replace(/&quot;/g, '"').trim()
}

/**
 * Search StackOverflow for questions.
 */
async function searchStackOverflow(query: string, limit: number): Promise<string> {
  const url = `${SO_API_BASE}/search?order=desc&sort=relevance&intitle=${encodeURIComponent(query)}&site=stackoverflow&pagesize=${limit}`

  const response = await fetch(url, {
    headers: { Accept: 'application/json' },
  })

  if (!response.ok) {
    const text = await response.text().catch(() => 'unknown error')
    throw new Error(`StackOverflow API error ${response.status}: ${text}`)
  }

  const data = await response.json() as { items: SOQuestion[], quota_remaining: number }
  const items = data.items ?? []

  if (items.length === 0) {
    return `No StackOverflow results for "${query}".`
  }

  const lines: string[] = [`## StackOverflow (${items.length} result${items.length > 1 ? 's' : ''} for "${query}")`, '']

  for (let i = 0; i < items.length; i++) {
    const q = items[i]!
    const answered = q.is_answered ? '✓' : '○'
    lines.push(`${i + 1}. **${q.title}** — Score: ${q.score}, Answers: ${answered} ${q.answer_count}`)
    lines.push(`   Tags: ${q.tags.slice(0, 5).join(', ')}${q.tags.length > 5 ? '...' : ''}`)
    lines.push(`   ${formatDate(q.creation_date)} | ${q.view_count.toLocaleString()} views`)
    lines.push(`   ${q.link}`)
    lines.push('')
  }

  return lines.join('\n')
}

/**
 * Search GitHub repositories.
 */
async function searchGitHubRepos(query: string, limit: number): Promise<string> {
  const url = `${GH_API_BASE}/search/repositories?q=${encodeURIComponent(query)}&sort=stars&order=desc&per_page=${limit}`

  const response = await fetch(url, {
    headers: {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    },
  })

  if (!response.ok) {
    const text = await response.text().catch(() => 'unknown error')
    if (response.status === 403 || response.status === 429) {
      throw new Error('GitHub API rate limit reached. Try again in a minute.')
    }
    throw new Error(`GitHub API error ${response.status}: ${text}`)
  }

  const data = await response.json() as { items: GHRepo[] }
  const items = data.items ?? []

  if (items.length === 0) {
    return `No GitHub repository results for "${query}".`
  }

  const lines: string[] = [`## GitHub Repositories (${items.length} result${items.length > 1 ? 's' : ''} for "${query}")`, '']

  for (let i = 0; i < items.length; i++) {
    const r = items[i]!
    lines.push(`${i + 1}. **${r.full_name}** ⭐ ${r.stargazers_count.toLocaleString()}`)
    if (r.description) {
      lines.push(`   ${r.description}`)
    }
    lines.push(`   ${r.language ?? 'N/A'} | ${r.forks_count.toLocaleString()} forks | Updated ${formatISODate(r.updated_at)}`)
    lines.push(`   ${r.html_url}`)
    lines.push('')
  }

  return lines.join('\n')
}

/**
 * Search GitHub issues.
 */
async function searchGitHubIssues(query: string, limit: number): Promise<string> {
  const url = `${GH_API_BASE}/search/issues?q=${encodeURIComponent(query)}&sort=updated&order=desc&per_page=${limit}`

  const response = await fetch(url, {
    headers: {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    },
  })

  if (!response.ok) {
    const text = await response.text().catch(() => 'unknown error')
    if (response.status === 403 || response.status === 429) {
      throw new Error('GitHub API rate limit reached. Try again in a minute.')
    }
    throw new Error(`GitHub API error ${response.status}: ${text}`)
  }

  const data = await response.json() as { items: GHIssue[] }
  const items = data.items ?? []

  if (items.length === 0) {
    return `No GitHub issue results for "${query}".`
  }

  const lines: string[] = [`## GitHub Issues (${items.length} result${items.length > 1 ? 's' : ''} for "${query}")`, '']

  for (let i = 0; i < items.length; i++) {
    const issue = items[i]!
    const state = issue.state === 'open' ? '🟢' : '🔴'
    lines.push(`${i + 1}. ${state} **${issue.title}** #${issue.number}`)
    if (issue.body) {
      const excerpt = stripHtml(issue.body).slice(0, 120)
      lines.push(`   ${excerpt}${issue.body.length > 120 ? '...' : ''}`)
    }
    lines.push(`   @${issue.user.login} | ${formatISODate(issue.created_at)}`)
    lines.push(`   ${issue.html_url}`)
    lines.push('')
  }

  return lines.join('\n')
}

/**
 * Search GitHub code.
 */
async function searchGitHubCode(query: string, limit: number): Promise<string> {
  const url = `${GH_API_BASE}/search/code?q=${encodeURIComponent(query)}&per_page=${limit}`

  const response = await fetch(url, {
    headers: {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    },
  })

  if (!response.ok) {
    const text = await response.text().catch(() => 'unknown error')
    if (response.status === 403 || response.status === 429) {
      throw new Error('GitHub API rate limit reached. Try again in a minute.')
    }
    if (response.status === 422) {
      throw new Error('GitHub code search requires a qualifier (e.g., language:, repo:, user:). Try adding one to your query.')
    }
    throw new Error(`GitHub API error ${response.status}: ${text}`)
  }

  const data = await response.json() as { items: GHCodeItem[] }
  const items = data.items ?? []

  if (items.length === 0) {
    return `No GitHub code results for "${query}".`
  }

  const lines: string[] = [`## GitHub Code (${items.length} result${items.length > 1 ? 's' : ''} for "${query}")`, '']

  for (let i = 0; i < items.length; i++) {
    const item = items[i]!
    lines.push(`${i + 1}. **${item.name}** in ${item.repository.full_name}`)
    lines.push(`   Path: ${item.path}`)
    lines.push(`   ${item.html_url}`)
    lines.push('')
  }

  return lines.join('\n')
}

/**
 * Register the web_search tool with the Pi extension API.
 */
export function registerWebSearchTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: 'web_search',
    label: 'Web Search',
    description:
      'Search for programming content across StackOverflow, GitHub, and documentation sites (via llms.txt). Returns clean, formatted results with titles, scores, and direct links.',
    promptSnippet:
      'Search StackOverflow, GitHub, and documentation sites for programming questions, repos, code, or docs',
    promptGuidelines: [
      'Use web_search to find programming answers, libraries, code examples, or bug reports.',
      'Set source=stackoverflow for Q&A, source=github for repos/code/issues, source=docs for documentation sites.',
      'For GitHub code search, add qualifiers like language:js, repo:owner/name, or user:username.',
      'For docs search, set site to filter by a specific site (vuejs, nuxt, inertia, react, filament, laravel, tailwind, livewire).',
      'For versioned docs (laravel, livewire), set version to override the default (e.g., 12.x, 3.x).',
      'Use web_fetch to read the full content of interesting search results.',
      'StackOverflow API: 300 req/day. GitHub API: 10 req/min (unauthenticated).',
    ],
    parameters: Type.Object({
      query: Type.String({ description: 'Search query' }),
      source: Type.Optional(
        StringEnum(['stackoverflow', 'github', 'docs', 'all'] as const, {
          description: 'Source to search (default: all)',
        }),
      ),
      site: Type.Optional(
        Type.String({
          description: 'Docs site to search (vuejs, nuxt, inertia, filament, laravel, tailwind, livewire). Searches all docs sites if not specified.',
        }),
      ),
      version: Type.Optional(
        Type.String({
          description: 'Docs version for versioned sites (e.g., 13.x for Laravel, 4.x for Livewire). Uses default if not specified.',
        }),
      ),
      github_type: Type.Optional(
        StringEnum(['repositories', 'code', 'issues'] as const, {
          description: 'GitHub search type (default: repositories)',
        }),
      ),
      limit: Type.Optional(
        Type.Number({
          description: `Max results per source (default: ${DEFAULT_LIMIT}, max: ${MAX_LIMIT})`,
        }),
      ),
    }),

    async execute(_toolCallId, params, _signal, onUpdate, _ctx) {
      const { query, source = 'all', github_type = 'repositories', limit = DEFAULT_LIMIT, site, version } = params
      const cappedLimit = Math.min(Math.max(1, limit), MAX_LIMIT)

      onUpdate?.({
        content: [{ type: 'text', text: `Searching for "${query}"...` }],
        details: {},
      })

      // Handle docs search
      if (source === 'docs') {
        const text = await searchDocs(query, site, version)
        return {
          content: [{ type: 'text', text }],
          details: { query, source, site: site ?? null, version: version ?? null } as Record<string, unknown>,
        }
      }

      const parts: string[] = []

      const searchSO = source === 'all' || source === 'stackoverflow'
      const searchGH = source === 'all' || source === 'github'

      if (searchSO) {
        try {
          parts.push(await searchStackOverflow(query, cappedLimit))
        }
        catch (error) {
          const msg = error instanceof Error ? error.message : String(error)
          parts.push(`## StackOverflow\nError: ${msg}`)
        }
      }

      if (searchGH) {
        try {
          if (github_type === 'repositories') {
            parts.push(await searchGitHubRepos(query, cappedLimit))
          }
          else if (github_type === 'issues') {
            parts.push(await searchGitHubIssues(query, cappedLimit))
          }
          else {
            parts.push(await searchGitHubCode(query, cappedLimit))
          }
        }
        catch (error) {
          const msg = error instanceof Error ? error.message : String(error)
          parts.push(`## GitHub\nError: ${msg}`)
        }
      }

      const text = parts.join('\n\n')

      return {
        content: [{ type: 'text', text }],
        details: {
          query,
          source,
          github_type,
          limit: cappedLimit,
          site: site ?? null,
          version: version ?? null,
        } as Record<string, unknown>,
      }
    },
  })
}
