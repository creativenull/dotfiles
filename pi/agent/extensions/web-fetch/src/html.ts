/**
 * HTML parsing utilities.
 *
 * Extracts structured content from raw HTML using node-html-parser.
 */

import type { HtmlContent } from './types.js'
import { parse } from 'node-html-parser'

/**
 * Parse raw HTML string into structured content.
 */
export function parseHtml(rawHtml: string, maxTextLength = 50000): HtmlContent {
  const root = parse(rawHtml)

  // Extract <title>
  const titleEl = root.querySelector('title')
  const title = cleanText(titleEl?.textContent ?? '')

  // Extract <meta name="description">
  const descEl = root.querySelector('meta[name="description"]')
  const description = descEl?.getAttribute('content') ?? ''

  // Extract Open Graph / Twitter metadata
  const metadata: Record<string, string> = {}
  for (const meta of root.querySelectorAll('meta')) {
    const name = meta.getAttribute('name') || meta.getAttribute('property')
    const content = meta.getAttribute('content')
    if (name && content) {
      metadata[name] = content
    }
  }

  // Remove script, style, noscript, svg elements
  const removalTags = ['script', 'style', 'noscript', 'svg', 'iframe', 'template']
  for (const tag of removalTags) {
    for (const el of root.querySelectorAll(tag)) {
      el.remove()
    }
  }

  // Extract headings (h1-h6)
  const headings: Array<{ level: number, text: string }> = []
  for (let level = 1; level <= 6; level++) {
    for (const el of root.querySelectorAll(`h${level}`)) {
      const text = cleanText(el.textContent)
      if (text)
        headings.push({ level, text })
    }
  }

  // Extract links
  const links: Array<{ text: string, href: string }> = []
  for (const el of root.querySelectorAll('a[href]')) {
    const href = el.getAttribute('href')?.trim()
    const text = cleanText(el.textContent)
    if (href && text && href !== '#' && !href.startsWith('javascript:')) {
      links.push({ text, href })
    }
  }

  // Extract body text with block structure
  const text = extractTextContent(root, maxTextLength)

  return {
    type: 'html',
    title,
    description,
    headings,
    links,
    text,
    metadata,
  }
}

/**
 * Extract readable text content from the parsed DOM.
 * Attempts to preserve some structure (paragraphs, lists).
 */
function extractTextContent(root: ReturnType<typeof parse>, maxLen: number): string {
  const body = root.querySelector('body') || root
  const blocks: string[] = []

  // Content-bearing block elements
  const blockTags = ['p', 'li', 'td', 'th', 'dt', 'dd', 'blockquote', 'pre', 'figcaption']
  for (const tag of blockTags) {
    for (const el of body.querySelectorAll(tag)) {
      const text = cleanText(el.textContent)
      if (text.length > 5) {
        blocks.push(text)
      }
    }
  }

  // If we got good blocks, use them; otherwise fall back to raw text
  let result: string
  if (blocks.length > 0) {
    result = blocks.join('\n\n')
  }
  else {
    result = cleanText(body.textContent)
  }

  if (result.length > maxLen) {
    result = `${result.slice(0, maxLen)}\n\n[... truncated]`
  }

  return result
}

/**
 * Collapse whitespace and strip empty lines.
 */
function cleanText(raw: string): string {
  return raw
    .replace(/[\t ]+/g, ' ')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
}
