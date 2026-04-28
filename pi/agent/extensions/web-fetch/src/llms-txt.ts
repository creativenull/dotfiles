/**
 * LLMs.txt discovery and parsing
 */

import type { DocLink, LlmsDocument } from './types.js'
import { fetchUrl } from './fetcher.js'

const LLMS_TXT_PATHS = ['/llms.txt', '/.well-known/llms.txt']

/**
 * Normalize URL to origin
 */
function getOrigin(url: string): string {
  try {
    const u = new URL(url.startsWith('http') ? url : `https://${url}`)
    return u.origin
  }
  catch {
    return url
  }
}

/**
 * Try to fetch llms.txt from a domain
 */
export async function fetchLlmsTxt(
  domain: string,
  signal?: AbortSignal,
): Promise<{ text: string, found: boolean, url: string }> {
  const origin = getOrigin(domain)

  for (const path of LLMS_TXT_PATHS) {
    try {
      const url = `${origin}${path}`
      const result = await fetchUrl(url, { signal, headers: { Accept: 'text/plain,text/markdown' } })

      if (result.status === 200 && result.body.trim()) {
        return {
          text: result.body.trim(),
          found: true,
          url,
        }
      }
    }
    catch {
      // Try next path
    }
  }

  return {
    text: `No llms.txt found for ${origin}. Tried:\n  ${LLMS_TXT_PATHS.map(p => `${origin}${p}`).join('\n  ')}`,
    found: false,
    url: '',
  }
}

/**
 * Parse llms.txt content
 */
export function parseLlmsTxt(content: string): LlmsDocument {
  const lines = content.split('\n')
  const doc: LlmsDocument = {
    title: '',
    description: '',
    links: [],
  }

  let currentSection = 'General'

  for (const line of lines) {
    const trimmed = line.trim()

    // Skip empty lines and comments
    if (!trimmed || trimmed.startsWith('#'))
      continue

    // Section header (lines ending with :)
    if (trimmed.endsWith(':') && !trimmed.includes('http')) {
      currentSection = trimmed.slice(0, -1).trim()
      continue
    }

    // Details (lines starting with >)
    if (trimmed.startsWith('>'))
      continue

    // Link: [title](url) format
    const linkMatch = trimmed.match(/^\[([^\]]+)\]\(([^)]+)\)$/)
    if (linkMatch) {
      doc.links.push({
        title: linkMatch[1]!.trim(),
        url: linkMatch[2]!.trim(),
        section: currentSection,
      })
      continue
    }

    // Plain URL
    if (trimmed.startsWith('http')) {
      const title = trimmed.split('/').pop()!.replace(/[-_]/g, ' ') || trimmed
      doc.links.push({
        title,
        url: trimmed,
        section: currentSection,
      })
      continue
    }

    // Title/description (first non-link line)
    if (doc.links.length === 0) {
      if (doc.description) {
        doc.description += ` ${trimmed}`
      }
      else {
        doc.description = trimmed
        doc.title = trimmed
      }
    }
  }

  doc.description = doc.description.trim()

  // Default title
  if (!doc.title) {
    doc.title = doc.links[0]?.title || 'Documentation'
  }

  return doc
}

/**
 * Score links against a query
 */
export function scoreLinks(links: DocLink[], query: string): Array<DocLink & { score: number }> {
  const queryLower = query.toLowerCase()
  const queryWords = queryLower.split(/\s+/).filter(w => w.length >= 2)

  return links.map((link) => {
    const titleLower = link.title.toLowerCase()
    const urlLower = link.url.toLowerCase()
    let score = 0

    // Exact title match
    if (titleLower === queryLower)
      score += 100

    // Title contains query
    if (titleLower.includes(queryLower))
      score += 50

    // URL contains query
    if (urlLower.includes(queryLower))
      score += 30

    // Word matches in title
    for (const word of queryWords) {
      if (titleLower.includes(word))
        score += 10
    }

    // Word matches in URL
    for (const word of queryWords) {
      if (urlLower.includes(word))
        score += 5
    }

    return { ...link, score }
  }).sort((a, b) => b.score - a.score)
}

/**
 * Format llms.txt for display
 */
export function formatLlmsTxt(doc: LlmsDocument, sourceUrl: string, query?: string): string {
  const lines: string[] = []

  lines.push(`# ${doc.title}`)

  if (doc.description) {
    lines.push('')
    lines.push(doc.description)
  }

  if (doc.links.length === 0) {
    lines.push('')
    lines.push('*No links found*')
  }
  else {
    // Get scored links if query provided
    let displayLinks = doc.links
    if (query) {
      const scored = scoreLinks(doc.links, query)
      const matches = scored.filter(l => l.score > 0).slice(0, 5)

      if (matches.length > 0) {
        lines.push('')
        lines.push(`### Top matches for "${query}"`)
        lines.push('')

        for (const link of matches) {
          lines.push(`- [${link.title}](${link.url})`)
          if (link.section && link.section !== 'General')
            lines.push(`  *Section: ${link.section}*`)
          lines.push('')
        }
      }

      displayLinks = doc.links
    }

    // Group by section
    const sections = new Map<string, DocLink[]>()
    for (const link of displayLinks) {
      const section = link.section || 'General'
      if (!sections.has(section))
        sections.set(section, [])
      sections.get(section)!.push(link)
    }

    // Show all sections
    lines.push('')
    lines.push('### All pages')
    lines.push('')

    for (const [section, links] of sections) {
      lines.push(`**${section}** (${links.length})`)
      for (const link of links.slice(0, 10)) {
        lines.push(`  - [${link.title}](${link.url})`)
      }
      if (links.length > 10) {
        lines.push(`  - ...and ${links.length - 10} more`)
      }
      lines.push('')
    }
  }

  lines.push(`*Source: ${sourceUrl}*`)

  return lines.join('\n')
}
