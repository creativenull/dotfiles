/**
 * Documentation site search via llms.txt or HTML side-menu parsing.
 *
 * For each site we store a CSS selector (or extraction strategy) that targets
 * the side-menu container. On every search we fetch the docs page fresh,
 * extract the menu HTML using the selector, parse links, score against the
 * query, and return matches.
 *
 * Supported sites:
 *   vuejs.org        – llms.txt at root
 *   nuxt.com         – llms.txt at root
 *   inertiajs.com    – llms.txt at /docs/llms.txt (Mintlify, sidebar is client-rendered)
 *   react.dev         – llms.txt at root
 *   filamentphp.com  – llms.txt at /docs/llms.txt
 *   laravel.com      – HTML nav#indexed-nav (default version 13.x)
 *   tailwindcss.com  – HTML nav.flex.flex-col.gap-8
 *   livewire.laravel.com – HTML a[wire:navigate] pattern
 */

import type { LlmsDocument } from './llms-txt-parser.js'
import { parseLlmsTxt, scoreLinks } from './llms-txt-parser.js'

interface DocsSiteConfig {
  /** Display name */
  name: string
  /** Base domain */
  baseUrl: string
  /** Docs entry-point path (supports {version} placeholder) */
  docsPath: string
  /** Default version (for sites with versioned docs) */
  defaultVersion: string | null
  /** How to extract the side menu */
  extractStrategy: 'llms-txt' | 'html-selector' | 'html-pattern'
  /** llms.txt path (when strategy is llms-txt) */
  llmsPath?: string
  /** CSS selector for the menu container (when strategy is html-selector) */
  menuSelector?: string
  /** Regex to extract links from the menu HTML (when strategy is html-selector/html-pattern) */
  linkPattern: RegExp
  /** How to build the full URL from a captured path */
  urlBuilder: (path: string, baseUrl: string) => string
  /** How to extract link text from a match */
  textExtractor: (match: RegExpExecArray) => string
}

const DOCS_SITES: Record<string, DocsSiteConfig> = {
  vuejs: {
    name: 'Vue.js',
    baseUrl: 'https://vuejs.org',
    docsPath: '',
    defaultVersion: null,
    extractStrategy: 'llms-txt',
    llmsPath: '/llms.txt',
    linkPattern: /href="(\/[^"]+\.md)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
  nuxt: {
    name: 'Nuxt',
    baseUrl: 'https://nuxt.com',
    docsPath: '',
    defaultVersion: null,
    extractStrategy: 'llms-txt',
    llmsPath: '/llms.txt',
    linkPattern: /href="(\/raw\/docs\/[^"]+\.md)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
  inertia: {
    name: 'Inertia.js',
    baseUrl: 'https://inertiajs.com',
    docsPath: '/docs',
    defaultVersion: null,
    extractStrategy: 'llms-txt',
    llmsPath: '/docs/llms.txt',
    linkPattern: /href="(\/docs\/[^"]+)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
  react: {
    name: 'React',
    baseUrl: 'https://react.dev',
    docsPath: '',
    defaultVersion: null,
    extractStrategy: 'llms-txt',
    llmsPath: '/llms.txt',
    linkPattern: /href="([^"]+)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
  filament: {
    name: 'Filament',
    baseUrl: 'https://filamentphp.com',
    docsPath: '/docs',
    defaultVersion: null,
    extractStrategy: 'llms-txt',
    llmsPath: '/docs/llms.txt',
    linkPattern: /href="(\/docs\/[^"]+)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
  laravel: {
    name: 'Laravel',
    baseUrl: 'https://laravel.com',
    docsPath: '/docs/{version}',
    defaultVersion: '13.x',
    extractStrategy: 'html-selector',
    menuSelector: 'nav#indexed-nav',
    linkPattern: /<a[^>]*href="(\/docs\/[^"]+)"[^>]*>([^<]+)<\/a>/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: m => m[2]!.trim(),
  },
  tailwind: {
    name: 'Tailwind CSS',
    baseUrl: 'https://tailwindcss.com',
    docsPath: '/docs',
    defaultVersion: null,
    extractStrategy: 'html-selector',
    menuSelector: 'nav',
    linkPattern: /<a[^>]*href="(\/docs\/[^"]+)"[^>]*>([^<]+)<\/a>/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: m => m[2]!.trim(),
  },
  livewire: {
    name: 'Livewire',
    baseUrl: 'https://livewire.laravel.com',
    docsPath: '/docs/4.x',
    defaultVersion: '4.x',
    extractStrategy: 'html-pattern',
    linkPattern: /href="(\/docs\/4\.x\/[^"]+)"/g,
    urlBuilder: (path, base) => `${base}${path}`,
    textExtractor: () => '',
  },
}

const KNOWN_SITES = Object.keys(DOCS_SITES)

/**
 * Resolve the docs path for a site, substituting the version placeholder.
 */
function resolveDocsPath(config: DocsSiteConfig, version?: string): string {
  const v = version ?? config.defaultVersion ?? ''
  return config.docsPath.replace('{version}', v)
}

/**
 * Extract links from llms.txt content.
 */
function extractFromLlmsTxt(content: string): LlmsDocument {
  return parseLlmsTxt(content)
}

/**
 * Extract links from HTML using a CSS selector.
 *
 * Since we don't have a DOM parser, we use string matching to find the
 * container by its opening tag (id/class attributes) and then extract
 * links from within that container's content.
 */
function extractFromHtmlSelector(
  html: string,
  config: DocsSiteConfig,
): LlmsDocument {
  const doc: LlmsDocument = {
    title: config.name,
    description: '',
    details: '',
    links: [],
    sections: [],
  }

  const selector = config.menuSelector!

  // Parse simple selectors: #id, .class, tag#id, tag.class
  const idMatch = selector.match(/#([\w-]+)/)
  const classMatch = selector.match(/\.([\w-]+)/)
  const tagMatch = selector.match(/^([a-z]+)/)

  const tag = tagMatch ? tagMatch[1]! : 'div'
  const id = idMatch ? idMatch[1]! : null
  const cls = classMatch ? classMatch[1]! : null

  // Build opening-tag pattern
  let tagPattern: RegExp
  if (id) {
    tagPattern = new RegExp(`<${tag}[^>]*\\bid=["']${id}["'][^>]*>`, 'i')
  }
  else if (cls) {
    tagPattern = new RegExp(`<${tag}[^>]*\\bclass=["'][^"']*\\b${cls}\\b[^"']*["'][^>]*>`, 'i')
  }
  else {
    tagPattern = new RegExp(`<${tag}[^>]*>`, 'i')
  }

  const tagMatchResult = tagPattern.exec(html)
  if (!tagMatchResult) {
    return doc
  }

  // Extract the container content by finding the matching closing tag
  const startIdx = tagMatchResult.index + tagMatchResult[0].length
  let depth = 1
  let pos = startIdx
  const closeTag = `</${tag}>`

  while (depth > 0 && pos < html.length) {
    const nextOpen = html.indexOf(`<${tag}`, pos)
    const nextClose = html.indexOf(closeTag, pos)
    if (nextClose === -1)
      break
    if (nextOpen !== -1 && nextOpen < nextClose) {
      // Make sure it's an opening tag, not a closing one
      const afterOpen = html.slice(nextOpen, nextOpen + tag.length + 2)
      if (!afterOpen.startsWith(`</${tag}`)) {
        depth++
      }
      pos = nextOpen + tag.length + 1
    }
    else {
      depth--
      pos = nextClose + closeTag.length
    }
  }

  const containerHtml = html.slice(tagMatchResult.index, pos)

  // Extract links from the container
  const seen = new Set<string>()
  let match: RegExpExecArray | null
  const pattern = new RegExp(config.linkPattern.source, `${config.linkPattern.flags.replace('g', '')}g`)

  // eslint-disable-next-line no-cond-assign
  while ((match = pattern.exec(containerHtml)) !== null) {
    const path = match[1]!
    if (seen.has(path))
      continue
    seen.add(path)

    const url = config.urlBuilder(path, config.baseUrl)
    const title = config.textExtractor(match) || path.split('/').pop()!.replace(/-/g, ' ')

    doc.links.push({
      title,
      url,
      description: '',
      section: 'Documentation',
      isOptional: false,
    })
  }

  if (doc.links.length > 0) {
    doc.sections.push('Documentation')
  }

  return doc
}

/**
 * Extract links from the full HTML using a pattern match.
 * Used when there is no single clean container (e.g. Livewire).
 */
function extractFromHtmlPattern(
  html: string,
  config: DocsSiteConfig,
): LlmsDocument {
  const doc: LlmsDocument = {
    title: config.name,
    description: '',
    details: '',
    links: [],
    sections: [],
  }

  const seen = new Set<string>()
  let match: RegExpExecArray | null
  const pattern = new RegExp(config.linkPattern.source, `${config.linkPattern.flags.replace('g', '')}g`)

  // eslint-disable-next-line no-cond-assign
  while ((match = pattern.exec(html)) !== null) {
    const path = match[1]!
    if (seen.has(path))
      continue
    seen.add(path)

    const url = config.urlBuilder(path, config.baseUrl)
    const title = config.textExtractor(match) || path.split('/').pop()!.replace(/-/g, ' ')

    doc.links.push({
      title,
      url,
      description: '',
      section: 'Documentation',
      isOptional: false,
    })
  }

  if (doc.links.length > 0) {
    doc.sections.push('Documentation')
  }

  return doc
}

/**
 * Search a single docs site.
 */
async function searchSite(
  config: DocsSiteConfig,
  query: string,
  version?: string,
): Promise<string> {
  if (config.extractStrategy === 'llms-txt') {
    const llmsUrl = `${config.baseUrl}${config.llmsPath}`
    const response = await fetch(llmsUrl, {
      headers: { Accept: 'text/plain,text/markdown,*/*' },
      redirect: 'follow',
    })

    if (!response.ok) {
      throw new Error(`llms.txt not found at ${llmsUrl} (${response.status})`)
    }

    const content = await response.text()
    const doc = extractFromLlmsTxt(content)
    return formatResults(config, doc, query, llmsUrl)
  }

  // HTML-based extraction
  const docsPath = resolveDocsPath(config, version)
  const url = `${config.baseUrl}${docsPath}`
  const response = await fetch(url, {
    headers: { Accept: 'text/html' },
    redirect: 'follow',
  })

  if (!response.ok) {
    throw new Error(`Docs page not found at ${url} (${response.status})`)
  }

  const html = await response.text()

  let doc: LlmsDocument
  if (config.extractStrategy === 'html-selector') {
    doc = extractFromHtmlSelector(html, config)
  }
  else {
    doc = extractFromHtmlPattern(html, config)
  }

  return formatResults(config, doc, query, url)
}

/**
 * Format search results for a single site.
 */
function formatResults(config: DocsSiteConfig, doc: LlmsDocument, query: string, sourceUrl: string): string {
  const lines: string[] = []
  lines.push(`## ${doc.title || config.name}`)
  lines.push('')

  if (doc.description) {
    lines.push(`> ${doc.description}`)
    lines.push('')
  }

  if (doc.links.length === 0) {
    lines.push(`No navigation links found.`)
    lines.push(`*Source: ${sourceUrl}*`)
    return lines.join('\n')
  }

  const scored = scoreLinks(doc.links, query)
  const matches = scored.filter(l => l.score > 0).slice(0, 5)

  if (matches.length > 0) {
    lines.push(`### Top matches for "${query}"`)
    lines.push('')
    for (let i = 0; i < matches.length; i++) {
      const link = matches[i]!
      lines.push(`${i + 1}. **[${link.title}](${link.url})**`)
      if (link.description) {
        lines.push(`   ${link.description}`)
      }
      if (link.section && link.section !== 'Documentation') {
        lines.push(`   Section: ${link.section}${link.isOptional ? ' (optional)' : ''}`)
      }
      lines.push('')
    }
  }
  else {
    lines.push(`*No direct matches for "${query}". Showing all available pages:*`)
    lines.push('')
  }

  // Show all sections
  lines.push('### All pages')
  lines.push('')
  for (const section of doc.sections) {
    const sectionLinks = doc.links.filter(l => l.section === section)
    lines.push(`- **${section}** (${sectionLinks.length} page${sectionLinks.length !== 1 ? 's' : ''})`)
    for (const link of sectionLinks.slice(0, 5)) {
      lines.push(`  - [${link.title}](${link.url})`)
    }
    if (sectionLinks.length > 5) {
      lines.push(`  - ...and ${sectionLinks.length - 5} more`)
    }
  }

  lines.push('')
  lines.push(`*Source: ${sourceUrl}*`)

  return lines.join('\n')
}

/**
 * Search across documentation sites.
 */
export async function searchDocs(query: string, siteFilter?: string, version?: string): Promise<string> {
  const sitesToSearch = siteFilter
    ? (KNOWN_SITES.includes(siteFilter) ? [siteFilter] : [])
    : KNOWN_SITES

  if (sitesToSearch.length === 0) {
    return `Unknown docs site "${siteFilter}". Known sites: ${KNOWN_SITES.join(', ')}`
  }

  const results: string[] = []

  for (const siteKey of sitesToSearch) {
    const config = DOCS_SITES[siteKey]!
    try {
      const result = await searchSite(config, query, version)
      results.push(result)
    }
    catch (error) {
      const msg = error instanceof Error ? error.message : String(error)
      results.push(`## ${config.name}\nError: ${msg}`)
    }
  }

  return results.join('\n\n')
}

/**
 * Get list of supported documentation sites.
 */
export function getSupportedDocsSites(): string[] {
  return [...KNOWN_SITES]
}
