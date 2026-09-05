/**
 * Terminal notification on agent completion (OSC 777 / OSC 99 for Kitty).
 * Config: ~/.pi/agent/notify.json
 */

import type {
  AgentEndEvent,
  ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import type { AssistantMessage } from "@earendil-works/pi-ai";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import process from "node:process";

interface Config {
  maxPreviewLength: number;
  title: string;
}

const defaultConfig: Config = {
  maxPreviewLength: 80,
  title: "pi coding agent",
};

function loadConfig(): Config {
  try {
    const configPath = path.join(os.homedir(), ".pi", "agent", "notify.json");

    if (fs.existsSync(configPath)) {
      const raw = fs.readFileSync(configPath, "utf-8");
      const userConfig = JSON.parse(raw) as Partial<Config>;
      return { ...defaultConfig, ...userConfig };
    }
  } catch {
    // Use defaults
  }

  return defaultConfig;
}

let notificationId = 0;

function notifyOSC777(title: string, body: string): void {
  process.stdout.write(`\x1B]777;notify;${title};${body}\x07`);
}

/**
 * Kitty OSC 99: two-part sequence so notifications stack, not replace.
 */
function notifyOSC99(title: string, body: string): void {
  notificationId++;
  const id = notificationId;
  process.stdout.write(`\x1B]99;i=${id}:d=0;${title}\x1B\\`);
  process.stdout.write(`\x1B]99;i=${id}:d=1:p=body;${body}\x1B\\`);
}

export function notify(title: string, body: string): void {
  if (process.env.KITTY_WINDOW_ID) {
    notifyOSC99(title, body);
  } else {
    notifyOSC777(title, body);
  }
}

/** Strip inline markdown. */
function stripMarkdown(text: string): string {
  return text
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/``([^`]+)``/g, "$1")
    .replace(/`([^`]+)`/g, "$1")
    .replace(/(\*\*|__)(.*?)\1/g, "$2")
    .replace(/\*{3}(.*?)\*{3}/g, "$1")
    .replace(/(\*|_)(.*?)\1/g, "$2")
    .replace(/~~(.*?)~~/g, "$1")
    .trim();
}

/**
 * HTTP status code from a pi-ai provider error message, e.g. "429:",
 * "Provider (429):", "HTTP 429", "403 status code".
 */
function extractStatusCode(errorMessage?: string): number | undefined {
  if (!errorMessage) return undefined;
  const match = errorMessage.match(
    /\((\d{3})\)|\b(\d{3}):|HTTP\s*(\d{3})|\b(\d{3}) status code/i,
  );
  return match
    ? Number(match[1] ?? match[2] ?? match[3] ?? match[4])
    : undefined;
}

/**
 * First sentence of the answer, for the notification preview.
 */
function extractPreview(text: string, maxLength: number): string {
  if (!text || text.trim().length === 0) {
    return "Ready for input";
  }

  const lines = text.split("\n");
  let firstProse = "";
  let insideCodeBlock = false;

  for (const line of lines) {
    const trimmed = line.trim();

    if (trimmed.startsWith("```")) {
      insideCodeBlock = !insideCodeBlock;
      continue;
    }

    if (insideCodeBlock) continue;

    if (trimmed.length === 0) continue;

    if (/^#{1,6}\s/.test(trimmed)) continue;

    if (/^[-*]\s*$/.test(trimmed)) continue;

    firstProse = trimmed;
    break;
  }

  if (!firstProse) {
    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed.length > 0) {
        firstProse = trimmed.replace(/^#{1,6}\s+/, "");
        break;
      }
    }
  }

  if (!firstProse) {
    return "Ready for input";
  }

  firstProse = stripMarkdown(firstProse);

  if (!firstProse || firstProse.trim().length === 0) {
    return "Ready for input";
  }

  const sentenceEndMatch = firstProse.match(/^(.+?[.!?])(?:\s|$)/);
  if (sentenceEndMatch && sentenceEndMatch[1].length <= maxLength) {
    return sentenceEndMatch[1];
  }

  if (firstProse.length <= maxLength) {
    return firstProse;
  }

  const truncated = firstProse.substring(0, maxLength);
  const lastSpace = truncated.lastIndexOf(" ");
  if (lastSpace > maxLength * 0.5) {
    return `${truncated.substring(0, lastSpace)}…`;
  }

  return `${truncated}…`;
}

export default function notifyExtension(pi: ExtensionAPI) {
  const config = loadConfig();

  pi.on("agent_end", async (event: AgentEndEvent) => {
    const { messages } = event;
    let lastAssistant: AssistantMessage | undefined;

    for (let i = messages.length - 1; i >= 0; i--) {
      const msg = messages[i];

      if (msg.role === "assistant") {
        lastAssistant = msg as AssistantMessage;
        break;
      }
    }

    // No response yet
    if (!lastAssistant) {
      return;
    }

    // User abort: stay silent
    if (lastAssistant.stopReason === "aborted") {
      return;
    }

    // API error: code only, details are in the agent UI
    if (lastAssistant.stopReason === "error") {
      const status = extractStatusCode(lastAssistant.errorMessage);
      notify(
        config.title,
        status ? `Provider error (${status})` : "Provider error",
      );
      return;
    }

    const textParts: string[] = [];
    for (const block of lastAssistant.content) {
      if (block.type === "text") {
        textParts.push(block.text);
      }
    }
    const lastAssistantText = textParts.join("\n");

    const preview = extractPreview(lastAssistantText, config.maxPreviewLength);
    notify(config.title, preview);
  });
}
