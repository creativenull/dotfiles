/**
 * Theme Switcher Extension
 *
 * Automatically syncs pi's theme with macOS system appearance (dark/light mode).
 * Uses `defaults read -g AppleInterfaceStyle` for fast, reliable detection.
 *
 * Theme switching uses `ctx.ui.getTheme()` + `ctx.ui.setTheme(Theme)` which
 * applies the theme in-memory only — it does NOT write to settings.json.
 * (Passing a string name to setTheme() would persist to settings.json.)
 */

import type { ExtensionAPI, ExtensionContext } from '@mariozechner/pi-coding-agent'
import { exec } from 'node:child_process'
import { promisify } from 'node:util'

const execAsync = promisify(exec)

/**
 * Check if macOS is in dark mode.
 * AppleInterfaceStyle is set to "Dark" when dark mode is active.
 * If the key doesn't exist, light mode is active.
 */
export async function isDarkMode(): Promise<boolean> {
  try {
    const { stdout } = await execAsync(
      'defaults read -g AppleInterfaceStyle 2>/dev/null',
    )
    return stdout.trim().toLowerCase() === 'dark'
  }
  catch {
    // Key doesn't exist = light mode
    return false
  }
}

const POLL_INTERVAL_MS = 3000

export default function (pi: ExtensionAPI) {
  let intervalId: ReturnType<typeof setInterval> | null = null
  let currentTheme: 'dark' | 'light' | null = null

  /**
   * Apply a theme by name using the in-memory-only path.
   *
   * `ctx.ui.setTheme(string)` writes to settings.json, but
   * `ctx.ui.setTheme(Theme)` only sets it in memory.
   * We load the Theme object first via `getTheme()`, then pass it.
   */
  function applyTheme(ctx: ExtensionContext, name: 'dark' | 'light') {
    const theme = ctx.ui.getTheme(name)
    if (theme) {
      ctx.ui.setTheme(theme)
    }
    else {
      // Fallback: if custom theme not found, use string (will persist)
      ctx.ui.setTheme(name)
    }
  }

  pi.on('session_start', async (_event, ctx) => {
    // Set theme immediately on startup
    const dark = await isDarkMode()
    currentTheme = dark ? 'dark' : 'light'
    applyTheme(ctx, currentTheme)

    if (ctx.hasUI) {
      ctx.ui.setStatus('theme-switcher', `theme: ${currentTheme}`)
    }

    // Poll for changes
    intervalId = setInterval(async () => {
      try {
        const newDark = await isDarkMode()
        const newTheme: 'dark' | 'light' = newDark ? 'dark' : 'light'

        if (newTheme !== currentTheme) {
          currentTheme = newTheme
          applyTheme(ctx, newTheme)

          if (ctx.hasUI) {
            ctx.ui.setStatus('theme-switcher', `theme: ${currentTheme}`)
            ctx.ui.notify(`Switched to ${currentTheme} theme`, 'info')
          }
        }
      }
      catch {
        // Silently ignore errors during polling
      }
    }, POLL_INTERVAL_MS)
  })

  pi.on('session_shutdown', () => {
    if (intervalId) {
      clearInterval(intervalId)
      intervalId = null
    }
  })
}
