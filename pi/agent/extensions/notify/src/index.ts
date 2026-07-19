/**
 * Pi Notify Extension
 *
 * Sends a terminal notification when the Pi agent finishes responding,
 * with a preview of the first sentence of the answer.
 *
 * Supports:
 * - OSC 777: Ghostty, iTerm2, WezTerm, rxvt-unicode
 * - OSC 99: Kitty (with stacking via incrementing IDs)
 *
 * Configuration: ~/.pi/agent/notify.json
 */

import type { AgentEndEvent, ExtensionAPI } from '@earendil-works/pi-coding-agent'
import { loadConfig } from './config'
import { notify } from './notifier'
import { extractPreview } from './preview'

export default function notifyExtension(pi: ExtensionAPI) {
  const config = loadConfig()

  pi.on('agent_end', async (event: AgentEndEvent) => {
    const { messages } = event
    let lastAssistantText = ''

    for (let i = messages.length - 1; i >= 0; i--) {
      const msg = messages[i]

      if (msg.role === 'assistant') {
        const textParts: string[] = []
        for (const block of msg.content) {
          if (block.type === 'text') {
            textParts.push(block.text)
          }
        }
        lastAssistantText = textParts.join('\n')
        break
      }
    }

    const preview = extractPreview(lastAssistantText, config.maxPreviewLength)
    notify(config.title, preview)
  })
}
