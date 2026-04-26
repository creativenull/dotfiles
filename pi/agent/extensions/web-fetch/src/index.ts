/**
 * Web Fetch Extension for Pi
 *
 * Provides tools for:
 * - web_fetch: Fetch URLs with clean parsed output (HTML→text, JSON→formatted)
 * - web_search: Search StackOverflow and GitHub for programming content
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import { registerWebFetchTool } from './web-fetch-tool.js'
import { registerWebSearchTool } from './web-search.js'

export default function webFetchExtension(pi: ExtensionAPI): void {
  registerWebFetchTool(pi)
  registerWebSearchTool(pi)
}
