/**
 * Web Fetch Extension for Pi
 *
 * Provides a `web_fetch` tool that intelligently fetches and parses web content.
 * Replaces raw curl calls with structured output for HTML, JSON, and text responses.
 *
 * Features:
 * - Auto-detects response content type (JSON, HTML, text, binary)
 * - HTML: extracts title, description, headings, links, and readable body text
 * - JSON: pretty-prints structured data
 * - Text: returns raw content
 * - Binary: returns metadata only
 * - Proper output truncation with temp file fallback
 * - Custom TUI rendering for tool calls and results
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import { registerWebFetchTool } from './fetch.js'

export default function webFetchExtension(pi: ExtensionAPI): void {
  registerWebFetchTool(pi)
}
