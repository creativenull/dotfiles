/**
 * Extract content from HTML pages (for documentation sites without llms.txt)
 */

import type { LlmsDocument } from './types.js'

/**
 * Find the closing tag matching an opening tag
 */
function findCloseTag(html: string, tag: string, startIdx: number): number {
  let depth = 1
  let pos = startIdx
  const closeTag = `</${tag}>`

  while (depth > 0 && pos < html.length) {
    const nextOpen = html.indexOf(`<${tag}`, pos)
    const nextClose = html.indexOf(closeTag, pos)

    if (nextClose === -1)
      break

    if (nextOpen !== -1 && nextOpen < nextClose) {
      // Check if it's an opening tag, not closing
      const afterOpen = html.slice(nextOpen, nextOpen + tag.length + 2)
      if (!afterOpen.startsWith(`</${tag}`))
        depth++
      pos = nextOpen + tag.length + 1
    }
    else {
      depth--
      pos = nextClose + closeTag.length
    }
  }

  return depth === 0 ? pos : -1
}

/**
 * Extract content by CSS selector (simple #id or .class)
 */
export function extractBySelector(html: string, selector: string, linkPattern: RegExp, baseUrl: string): LlmsDocument {
  const doc: LlmsDocument = {
    title: '',
    description: '',
    links: [],
  }

  // Parse selector
  const idMatch = selector.match(/#([\w-]+)/)
  const classMatch = selector.match(/\.([\w-]+)/)
  const tagMatch = selector.match(/^([a-z]+)/i)

  const tag = tagMatch ? tagMatch[1]! : 'div'

  // Build tag pattern
  let tagPattern: RegExp
  if (idMatch) {
    tagPattern = new RegExp(`<${tag}[^>]*\\bid=["']${idMatch[1]}["'][^>]*>`, 'i')
  }
  else if (classMatch) {
    tagPattern = new RegExp(`<${tag}[^>]*\\bclass=["'][^"']*\\b${classMatch[1]}\\b[^"']*["'][^>]*>`, 'i')
  }
  else {
    return doc
  }

  const tagMatchResult = tagPattern.exec(html)
  if (!tagMatchResult)
    return doc

  // Extract container
  const startIdx = tagMatchResult.index + tagMatchResult[0].length
  const endIdx = findCloseTag(html, tag, startIdx)

  if (endIdx === -1)
    return doc

  const containerHtml = html.slice(tagMatchResult.index, endIdx)

  // Extract links
  const seen = new Set<string>()
  const globalPattern = new RegExp(linkPattern.source, 'gi')
  let match: RegExpExecArray | null = globalPattern.exec(containerHtml)

  while (match !== null) {
    const path = match[1] || match[0]
    if (seen.has(path)) {
      match = globalPattern.exec(containerHtml)
      continue
    }
    seen.add(path)

    const url = path.startsWith('http') ? path : `${baseUrl}${path}`
    const title = match[2]?.trim() || path.split('/').pop()!.replace(/[-_]/g, ' ')

    doc.links.push({
      title,
      url,
      section: 'Documentation',
    })

    match = globalPattern.exec(containerHtml)
  }

  return doc
}

/**
 * Extract links by pattern from full HTML
 */
export function extractByPattern(html: string, pattern: RegExp, baseUrl: string): LlmsDocument {
  const doc: LlmsDocument = {
    title: '',
    description: '',
    links: [],
  }

  const seen = new Set<string>()
  const globalPattern = new RegExp(pattern.source, 'gi')
  let match: RegExpExecArray | null = globalPattern.exec(html)

  while (match !== null) {
    const path = match[1]
    if (seen.has(path)) {
      match = globalPattern.exec(html)
      continue
    }
    seen.add(path)

    const url = path.startsWith('http') ? path : `${baseUrl}${path}`
    const title = path.split('/').pop()!.replace(/[-_]/g, ' ')

    doc.links.push({
      title,
      url,
      section: 'Documentation',
    })

    match = globalPattern.exec(html)
  }

  return doc
}

/**
 * Extract title from HTML
 */
export function extractTitle(html: string): string {
  const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i)
  return titleMatch ? titleMatch[1]!.trim() : ''
}

/**
 * Extract meta description from HTML
 */
export function extractMetaDescription(html: string): string {
  const descMatch = html.match(/<meta[^>]*name=["']description["'][^>]*content=["']([^"']+)["']/i)
  return descMatch ? descMatch[1]!.trim() : ''
}
