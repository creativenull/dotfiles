import type { LspConfig, LspServerConfig } from "./types.js";
import { existsSync } from "node:fs";
import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import process from "node:process";

function expandEnv(value: string): string {
  return value.replace(
    /\$\{([^}]+)\}/g,
    (_, name: string) => process.env[name] ?? "",
  );
}

function expandConfigEnv(config: LspServerConfig): LspServerConfig {
  const expanded: LspServerConfig = {
    command: expandEnv(config.command),
    args: config.args?.map(expandEnv),
    extensions: config.extensions,
    disabled: config.disabled,
  };

  if (config.env) {
    expanded.env = {};
    for (const [key, value] of Object.entries(config.env)) {
      expanded.env[key] = expandEnv(value);
    }
  }

  if (config.initializationOptions) {
    expanded.initializationOptions = config.initializationOptions;
  }

  return expanded;
}

export async function loadLspConfig(projectDir?: string): Promise<LspConfig> {
  const configs: LspConfig[] = [];

  const globalPath = join(homedir(), ".agents", "lsp.json");
  if (existsSync(globalPath)) {
    try {
      const content = await readFile(globalPath, "utf-8");
      configs.push(JSON.parse(content));
    } catch (error) {
      console.error(`Failed to load global LSP config: ${error}`);
    }
  }

  if (projectDir) {
    const projectPath = join(projectDir, ".agents", "lsp.json");
    if (existsSync(projectPath)) {
      try {
        const content = await readFile(projectPath, "utf-8");
        configs.push(JSON.parse(content));
      } catch (error) {
        console.error(`Failed to load project LSP config: ${error}`);
      }
    }
  }

  const merged: LspConfig = { lspServers: {} };
  for (const config of configs) {
    for (const [name, serverConfig] of Object.entries(
      config.lspServers ?? {},
    )) {
      merged.lspServers![name] = expandConfigEnv(serverConfig);
    }
  }

  return merged;
}

export function validateLspServerConfig(
  name: string,
  config: LspServerConfig,
): string | undefined {
  if (!config.command || typeof config.command !== "string") {
    return `LSP server '${name}': missing or invalid 'command' field`;
  }
  if (
    !config.extensions ||
    !Array.isArray(config.extensions) ||
    config.extensions.length === 0
  ) {
    return `LSP server '${name}': 'extensions' must be a non-empty array`;
  }
  if (config.args !== undefined && !Array.isArray(config.args)) {
    return `LSP server '${name}': 'args' must be an array`;
  }
  if (config.env !== undefined && typeof config.env !== "object") {
    return `LSP server '${name}': 'env' must be an object`;
  }
  return undefined;
}
