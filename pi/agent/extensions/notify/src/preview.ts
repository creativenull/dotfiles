/**
 * Strip inline markdown formatting from a string.
 * See README for full list of supported transformations.
 */
export function stripMarkdown(text: string): string {
  return text
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/``([^`]+)``/g, '$1')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/(\*\*|__)(.*?)\1/g, '$2')
    .replace(/\*{3}(.*?)\*{3}/g, '$1')
    .replace(/(\*|_)(.*?)\1/g, '$2')
    .replace(/~~(.*?)~~/g, '$1')
    .trim()
}

/**
 * Extract the first sentence of the assistant's answer for the notification preview.
 * See README for the full extraction logic.
 */
export function extractPreview(text: string, maxLength: number): string {
  if (!text || text.trim().length === 0) {
    return 'Ready for input'
  }

  const lines = text.split('\n')
  let firstProse = ''
  let insideCodeBlock = false

  for (const line of lines) {
    const trimmed = line.trim()

    if (trimmed.startsWith('```')) {
      insideCodeBlock = !insideCodeBlock
      continue
    }

    if (insideCodeBlock)
      continue

    if (trimmed.length === 0)
      continue

    if (/^#{1,6}\s/.test(trimmed))
      continue

    if (/^[-*]\s*$/.test(trimmed))
      continue

    firstProse = trimmed
    break
  }

  if (!firstProse) {
    for (const line of lines) {
      const trimmed = line.trim()
      if (trimmed.length > 0) {
        firstProse = trimmed.replace(/^#{1,6}\s+/, '')
        break
      }
    }
  }

  if (!firstProse) {
    return 'Ready for input'
  }

  firstProse = stripMarkdown(firstProse)

  if (!firstProse || firstProse.trim().length === 0) {
    return 'Ready for input'
  }

  const sentenceEndMatch = firstProse.match(/^(.+?[.!?])(?:\s|$)/)
  if (sentenceEndMatch && sentenceEndMatch[1].length <= maxLength) {
    return sentenceEndMatch[1]
  }

  if (firstProse.length <= maxLength) {
    return firstProse
  }

  const truncated = firstProse.substring(0, maxLength)
  const lastSpace = truncated.lastIndexOf(' ')
  if (lastSpace > maxLength * 0.5) {
    return `${truncated.substring(0, lastSpace)}…`
  }

  return `${truncated}…`
}
