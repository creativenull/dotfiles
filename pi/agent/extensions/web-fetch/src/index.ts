/**
 * Web Fetch Extension for Pi
 *
 * Provides tools for:
 * - web_fetch: Fetch URLs with clean parsed output
 *   Modes: llms_txt (fetch llms.txt), html (fetch HTML), jina (Jina Reader API), raw (fetch any URL)
 * - web_search: Search the web using LangSearch (free with API key) or DuckDuckGo (free, no key)
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import { registerWebFetchTool } from './web-fetch.js'
import { registerWebSearchTool } from './web-search.js'

export default function webFetchExtension(pi: ExtensionAPI): void {
  registerWebFetchTool(pi)
  registerWebSearchTool(pi)
}
