/**
 * Permission Extension
 *
 * Blocks destructive bash commands and asks for user confirmation.
 * Also prompts when creating new files via the write tool.
 *
 * Features:
 * - Detects dangerous commands (rm, dd, mkfs, git push --force, etc.)
 * - Prompts user for confirmation before execution
 * - Blocks command if user denies, feeds back to agent
 * - Prompts when creating new files via write tool
 *
 * No npm dependencies required - uses only Pi's built-in types.
 */

import type { ExtensionAPI } from '@earendil-works/pi-coding-agent'
import { isToolCallEventType } from '@earendil-works/pi-coding-agent'
import { existsSync } from 'node:fs'

/**
 * Destructive command patterns to block.
 * Each pattern is tested against the bash command.
 */
const DESTRUCTIVE_PATTERNS: Array<{ pattern: RegExp; label: string }> = [
  // File deletion
  { pattern: /\brm\s+/, label: 'rm' },
  { pattern: /\brmdir\s+/, label: 'rmdir' },
  { pattern: /\bunlink\s+/, label: 'unlink' },

  // Disk operations
  { pattern: /\bmkfs\s+/, label: 'mkfs' },
  { pattern: /\bfdisk\s+/, label: 'fdisk' },
  { pattern: /\bparted\s+/, label: 'parted' },
  { pattern: /\bdd\s+if=/, label: 'dd (disk copy)' },

  // Process/system
  { pattern: /\bkill\s+-9\s+1\b/, label: 'kill -9 1 (kill init)' },
  { pattern: /\bkillall\s+/, label: 'killall' },
  { pattern: /\bpkill\s+/, label: 'pkill' },

  // Git force operations
  { pattern: /\bgit\s+push\s+--force\b/, label: 'git push --force' },
  { pattern: /\bgit\s+reset\s+--hard\b/, label: 'git reset --hard' },
  { pattern: /\bgit\s+clean\s+-fd?\b/, label: 'git clean -fd' },

  // System overwrites
  { pattern: />\s*\/dev\/(sda|hda|nvme)/, label: 'write to disk device' },

  // Insecure permissions on root
  { pattern: /\bchmod\s+-R\s+777\s+\//, label: 'chmod 777 /' },
]

export default function (pi: ExtensionAPI) {
  // Intercept bash tool calls for destructive commands
  pi.on('tool_call', async (event, ctx) => {
    if (isToolCallEventType('bash', event)) {
      const command = event.input.command?.toLowerCase() ?? ''

      for (const { pattern, label } of DESTRUCTIVE_PATTERNS) {
        if (pattern.test(command)) {
          const confirmed = await ctx.ui.confirm(
            `Destructive command detected: ${label}`,
            `Allow execution?\n\n${event.input.command}`,
          )

          if (!confirmed) {
            // Block the command but let the agent continue and formulate a response
            return {
              block: true,
              reason: `Blocked by user: ${label}`,
            }
          }

          break
        }
      }
    }

    // Intercept write tool for new files
    if (isToolCallEventType('write', event)) {
      const filePath = event.input.path

      if (!existsSync(filePath)) {
        const confirmed = await ctx.ui.confirm(
          'Create new file',
          `Allow creation of new file?\n\n${filePath}`,
        )

        if (!confirmed) {
          // Block the command but let the agent continue and formulate a response
          return {
            block: true,
            reason: 'Blocked by user: new file creation',
          }
        }
      }
    }
  })
}
