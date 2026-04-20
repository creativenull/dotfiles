/**
 * HTML-to-text converter
 *
 * Strips tags, scripts, styles, and normalises whitespace to produce
 * clean readable text from HTML content.
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
 * Convert HTML to plain text.
 *
 * This is a lightweight converter — no DOM dependency. It strips
 * scripts, styles, comments, and converts block elements to newlines.
 */
export function htmlToText(html: string): string {
  // Remove script and style blocks entirely (including content)
  let text = html.replace(/<script[\s\S]*?<\/script>/gi, '')
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
