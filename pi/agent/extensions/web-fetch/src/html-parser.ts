/**
 * HTML-to-text converter
 *
 * Strips tags, scripts, styles, navigation chrome, and normalises
 * whitespace to produce clean readable text from HTML content.
 */

/**
 * Replace HTML entities with their character equivalents.
 */
function decodeEntities(html: string): string {
  const entities: Record<string, string> = {
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&#39;': '\'',
    '&apos;': '\'',
    '&nbsp;': ' ',
    '&#160;': ' ',
    '&mdash;': '—',
    '&ndash;': '–',
    '&hellip;': '…',
    '&laquo;': '«',
    '&raquo;': '»',
    '&bull;': '•',
    '&middot;': '·',
    '&copy;': '©',
    '&reg;': '®',
    '&trade;': '™',
    '&rsquo;': '\'',
    '&lsquo;': '\'',
    '&rdquo;': '"',
    '&ldquo;': '"',
  }

  let result = html
  // Named entities first
  for (const [entity, char] of Object.entries(entities)) {
    result = result.replaceAll(entity, char)
  }
  // Numeric entities like &#1234; or &#x1F600;
  result = result.replaceAll(/&#(\d+);/g, (_, code) =>
    String.fromCodePoint(Number.parseInt(code, 10)))
  result = result.replaceAll(/&#x([0-9a-fA-F]+);/g, (_, code) =>
    String.fromCodePoint(Number.parseInt(code, 16)))

  return result
}

/**
 * Convert block-level tags to newlines for readability.
 */
const BLOCK_TAGS = new Set([
  'address',
  'article',
  'aside',
  'blockquote',
  'br',
  'dd',
  'div',
  'dl',
  'dt',
  'fieldset',
  'figcaption',
  'figure',
  'footer',
  'form',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'header',
  'hr',
  'li',
  'main',
  'nav',
  'ol',
  'p',
  'pre',
  'section',
  'table',
  'ul',
])

/**
 * Escape special regex characters.
 */
function escapeRegExp(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

/**
 * Remove all instances of a tag with their full content (handles nesting).
 */
function stripTag(html: string, tag: string): string {
  const openRe = new RegExp(`<${tag}(?:\\s[^>]*)?>`, 'gi')
  const closeStr = `</${tag}>`

  let result = ''
  let lastEnd = 0
  let m: RegExpExecArray | null

  // eslint-disable-next-line no-cond-assign
  while ((m = openRe.exec(html)) !== null) {
    result += html.slice(lastEnd, m.index)

    let depth = 1
    let pos = m.index + m[0].length

    while (depth > 0 && pos < html.length) {
      const oIdx = html.indexOf(`<${tag}`, pos)
      const cIdx = html.indexOf(closeStr, pos)
      if (cIdx < 0)
        break
      if (oIdx >= 0 && oIdx < cIdx && html[oIdx + tag.length + 1] !== '/') {
        depth++
        pos = oIdx + tag.length + 1
      }
      else {
        depth--
        pos = cIdx + closeStr.length
      }
    }

    lastEnd = pos
  }

  return result + html.slice(lastEnd)
}

/**
 * Remove an element identified by its id attribute.
 */
function stripById(html: string, id: string): string {
  const re = new RegExp(`<([a-zA-Z][a-zA-Z0-9]*)[^>]*\\bid\\s*=\\s*["']${escapeRegExp(id)}["'][^>]*>`, 'i')
  const m = re.exec(html)
  if (!m)
    return html

  const tag = m[1]!
  const openEnd = m.index + m[0].length
  const closeStr = `</${tag}>`

  let depth = 1
  let pos = openEnd

  while (depth > 0 && pos < html.length) {
    const oIdx = html.indexOf(`<${tag}`, pos)
    const cIdx = html.indexOf(closeStr, pos)
    if (cIdx < 0)
      break
    if (oIdx >= 0 && oIdx < cIdx && html[oIdx + tag.length + 1] !== '/') {
      depth++
      pos = oIdx + tag.length + 1
    }
    else {
      depth--
      pos = cIdx + closeStr.length
    }
  }

  return html.slice(0, m.index) + html.slice(pos)
}

/**
 * Strip navigation chrome from HTML before text conversion.
 *
 * Removes <nav>, <header>, <footer> elements and elements with
 * common sidebar IDs. This prevents sidebar navigation from eating
 * the head budget and puts actual article content first.
 */
function stripNavigation(html: string): string {
  // Remove standard nav/header/footer elements
  for (const tag of ['nav', 'header', 'footer']) {
    html = stripTag(html, tag)
  }

  // Remove elements with common sidebar/navigation IDs
  for (const id of [
    'sidebar',
    'side-nav',
    'indexed-nav',
    'nav-trigger',
    'sidebar-content',
    'sidebar-title',
    'navbar',
    'navbar-transition',
    'navigation-items',
    'options-menu',
    'table-of-contents',
  ]) {
    html = stripById(html, id)
  }

  return html
}

/**
 * Convert HTML to plain text.
 *
 * This is a lightweight converter — no DOM dependency. It strips
 * scripts, styles, navigation chrome, and converts block elements
 * to newlines.
 */
export function htmlToText(html: string): string {
  // Strip navigation chrome (sidebar, topbar, menus) first
  let text = stripNavigation(html)

  // Remove script and style blocks entirely (including content)
  text = text.replace(/<script[\s\S]*?<\/script>/gi, '')
  text = text.replace(/<style[\s\S]*?<\/style>/gi, '')
  // Remove HTML comments
  text = text.replace(/<!--[\s\S]*?-->/g, '')
  // Replace <br> and <hr> with newlines
  text = text.replace(/<br\s*\/?>/gi, '\n')
  text = text.replace(/<hr\s*\/?>/gi, '\n---\n')
  // Add newlines before block-level tags
  text = text.replace(
    new RegExp(`<(/?)(${Array.from(BLOCK_TAGS).join('|')})[^>]*>`, 'gi'),
    '\n<$1$2>',
  )
  // Remove all remaining tags
  text = text.replace(/<[^>]+>/g, '')
  // Decode HTML entities
  text = decodeEntities(text)
  // Collapse excessive blank lines (3+ newlines → 2)
  text = text.replace(/\n{3,}/g, '\n\n')
  // Trim
  text = text.trim()

  return text
}
