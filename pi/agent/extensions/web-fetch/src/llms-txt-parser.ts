/**
 * llms.txt parser
 *
 * Parses llms.txt files into structured data.
 * Format spec: https://llmstxt.org
 *
 * Structure:
 *   # Site Name        (H1 — required)
 *   > Description      (blockquote — required)
 *   [optional paragraphs]
 *   ## Section         (H2 sections with file lists)
 *   - [name](url): desc
 *   ## Optional        (skippable links)
 */

export interface LlmsLink {
  /** Link title from [title](url) */
  title: string
  /** Full URL */
  url: string
  /** Optional description after the colon */
  description: string
  /** Which H2 section this link belongs to */
  section: string
  /** Whether this is in the "Optional" section */
  isOptional: boolean
}

export interface LlmsDocument {
  /** Site/project name from H1 */
  title: string
  /** Description from blockquote */
  description: string
  /** Optional detail paragraphs */
  details: string
  /** All parsed links */
  links: LlmsLink[]
  /** Section names found */
  sections: string[]
}

/**
 * Parse an llms.txt content string into structured data.
 */
export function parseLlmsTxt(content: string): LlmsDocument {
  const lines = content.split('\n')
  const doc: LlmsDocument = {
    title: '',
    description: '',
    details: '',
    links: [],
    sections: [],
  }

  let currentSection = ''
  let inBlockquote = false
  const blockquoteLines: string[] = []
  let detailLines: string[] = []
  let afterBlockquote = false

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!
    const trimmed = line.trim()

    // H1: title
    if (trimmed.startsWith('# ') && !doc.title) {
      doc.title = trimmed.slice(2).trim()
      continue
    }

    // Blockquote start
    if (trimmed.startsWith('> ') && !afterBlockquote) {
      inBlockquote = true
      blockquoteLines.push(trimmed.slice(2).trim())
      continue
    }

    // Continuation of blockquote (indented or another >)
    if (inBlockquote && (trimmed.startsWith('> ') || (trimmed === '' && blockquoteLines.length > 0))) {
      if (trimmed.startsWith('> ')) {
        blockquoteLines.push(trimmed.slice(2).trim())
      }
      continue
    }

    if (inBlockquote) {
      inBlockquote = false
      afterBlockquote = true
      doc.description = blockquoteLines.join(' ')
    }

    // H2: section header
    if (trimmed.startsWith('## ')) {
      currentSection = trimmed.slice(3).trim()
      doc.sections.push(currentSection)
      detailLines = [] // reset detail accumulation between sections
      continue
    }

    // List item with link: - [title](url): description
    if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
      const itemText = trimmed.slice(2)
      const linkMatch = itemText.match(/^\[(.+?)\]\((.+?)\)(?:: ?(.*))?$/) ?? itemText.match(/^\[(.+?)\]\((.+?)\)(?::(.*))?$/) ?? null
      if (linkMatch) {
        const isOptional = currentSection.toLowerCase() === 'optional'
        doc.links.push({
          title: linkMatch[1]!.trim(),
          url: linkMatch[2]!.trim(),
          description: (linkMatch[3] ?? '').trim(),
          section: currentSection,
          isOptional,
        })
      }
      continue
    }

    // Accumulate detail paragraphs (between blockquote and first H2)
    if (afterBlockquote && doc.sections.length === 0 && trimmed) {
      detailLines.push(trimmed)
    }
  }

  doc.details = detailLines.join('\n')

  return doc
}

/**
 * Score links against a search query using simple keyword matching.
 * Returns links sorted by relevance (highest first).
 */
export function scoreLinks(links: LlmsLink[], query: string): Array<LlmsLink & { score: number }> {
  const terms = query.toLowerCase().split(/\s+/).filter(t => t.length > 2)
  if (terms.length === 0) {
    return links.map(l => ({ ...l, score: 0 }))
  }

  const scored = links.map((link) => {
    const haystack = `${link.title} ${link.description} ${link.section}`.toLowerCase()
    let score = 0
    for (const term of terms) {
      if (haystack.includes(term))
        score++
    }
    // Boost non-optional links
    if (!link.isOptional)
      score += 0.5
    return { ...link, score }
  })

  return scored.sort((a, b) => b.score - a.score)
}
