import type { Config } from './types'
import fs from 'node:fs'
import os from 'node:os'
import path from 'node:path'

const defaultConfig: Config = {
  maxPreviewLength: 80,
  title: 'pi coding agent',
}

export function loadConfig(): Config {
  try {
    const configPath = path.join(os.homedir(), '.pi', 'agent', 'notify.json')

    if (fs.existsSync(configPath)) {
      const raw = fs.readFileSync(configPath, 'utf-8')
      const userConfig = JSON.parse(raw) as Partial<Config>
      return { ...defaultConfig, ...userConfig }
    }
  }
  catch {
    // Silently ignore config errors, use defaults
  }

  return defaultConfig
}
