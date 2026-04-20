/**
 * Web Fetch Extension for Pi
 *
 * Provides a `web_fetch` tool for making HTTP requests and returning
 * clean, parsed content (HTML→text, JSON→formatted). Avoids the noise
 * of raw curl output.
 */

import type { ExtensionAPI } from '@mariozechner/pi-coding-agent'
import { registerWebFetchTool } from './web-fetch-tool.js'

export default function webFetchExtension(pi: ExtensionAPI): void {
  registerWebFetchTool(pi)
}
