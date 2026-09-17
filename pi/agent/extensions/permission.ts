/**
 * Permission Extension
 *
 * Single rule: tool calls must stay inside the current working directory.
 * Anything inside the cwd runs freely. Anything touching a path outside
 * the cwd prompts with four choices: allow once, allow for the rest of
 * the session, deny, or deny with feedback for the agent. Without a UI
 * (-p / JSON mode), calls that reach outside the cwd are blocked.
 *
 * Layers:
 * - bash: quote-aware token scan for absolute paths, ~, $VAR, ../ and
 *   redirection targets, resolved lexically AND through symlinks.
 * - bash: constructs that can't be checked statically (command
 *   substitution, eval, source, shell -c, find -exec, xargs, sudo)
 *   always prompt — fail-closed instead of silently missing them.
 * - read/write/edit: direct path check.
 * - any other tool (MCP, custom): string inputs that look like paths
 *   are checked too.
 *
 * This is a heuristic guardrail, not a security boundary: paths computed
 * at runtime by earlier statements in a script can't be seen statically.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";
import { realpathSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, isAbsolute, resolve, sep } from "node:path";
import { notify } from "./notify.ts";

const sessionAllow = new Set<string>();

// ---------------------------------------------------------------------------
// Path resolution
// ---------------------------------------------------------------------------

/** Lexically resolve a path token against cwd. "unknown" if unresolvable. */
function resolvePath(path: string, cwd: string): string | "unknown" {
  if (path.startsWith("~")) return resolve(homedir(), path.slice(1));
  const env = path.match(/^\$\{?([A-Za-z_][A-Za-z0-9_]*)\}?/);
  if (env) {
    const value = process.env[env[1]] ?? "";
    if (!value) return "unknown";
    return resolve(cwd, value + path.slice(env[0].length));
  }
  return isAbsolute(path) ? resolve(path) : resolve(cwd, path);
}

/** realpath of the nearest existing ancestor, rejoined with the rest. */
function resolveReal(path: string): string {
  let current = path;
  for (;;) {
    try {
      return realpathSync(current) + path.slice(current.length);
    } catch {
      const parent = dirname(current);
      if (parent === current) return path;
      current = parent;
    }
  }
}

function insideRoots(abs: string, roots: string[]): boolean {
  return roots.some((r) => abs === r || abs.startsWith(r + sep));
}

function isOutside(path: string, cwd: string, roots: string[]): boolean {
  if (!path) return false;
  const abs = resolvePath(path, cwd);
  if (abs === "unknown") return true; // can't resolve → confirm
  // Both the lexical path and its real (symlink-resolved) location must
  // be inside the cwd.
  return !insideRoots(abs, roots) || !insideRoots(resolveReal(abs), roots);
}

// ---------------------------------------------------------------------------
// Bash analysis
// ---------------------------------------------------------------------------

/** Constructs we can't reason about statically → always confirm. */
const DYNAMIC: Array<{ label: string; pattern: RegExp }> = [
  { label: "command substitution $(…) or `…`", pattern: /\$\(|`/ },
  { label: "eval", pattern: /(^|[\s;|&])eval\s/ },
  { label: "source / dot-command", pattern: /(^|[\s;|&])(source|\.)\s/ },
  {
    label: "shell invocation (sh -c …)",
    pattern: /\b(?:bash|sh|zsh|dash|fish)\s+[^\n]*\s-c\s/,
  },
  { label: "find -exec", pattern: /\bfind\b[^|;&]*\s-exec/ },
  { label: "xargs", pattern: /(^|[\s;|&])xargs(\s|$)/ },
  { label: "sudo", pattern: /(^|[\s;|&])sudo(\s|$)/ },
];

/** Quote-aware tokenizer: splits on whitespace and shell operators. */
function* tokens(command: string): Generator<string> {
  let cur = "";
  let quote: string | null = null;
  let active = false;
  for (const ch of command) {
    if (quote) {
      if (ch === quote) quote = null;
      else cur += ch;
    } else if (ch === "'" || ch === '"') {
      quote = ch;
      active = true;
    } else if (/[\s;|&()]/.test(ch)) {
      if (active) {
        yield cur;
        cur = "";
        active = false;
      }
    } else {
      cur += ch;
      active = true;
    }
  }
  if (active) yield cur;
}

const SAFE_PATHS = new Set([
  "/dev/null",
  "/dev/stdin",
  "/dev/stdout",
  "/dev/stderr",
  "/dev/tty",
]);

/** Returns a description of the risk, or undefined if the command is fine. */
function checkCommand(
  command: string,
  cwd: string,
  roots: string[],
): string | undefined {
  const dynamic = DYNAMIC.find((d) => d.pattern.test(command));
  if (dynamic) return `uses ${dynamic.label}, which can't be checked statically`;

  for (const raw of tokens(command)) {
    let token = raw.replace(/^[0-9]*[<>]+/, "");
    if (!token) continue;
    if (token.startsWith("-")) {
      const eq = token.indexOf("=");
      if (eq === -1) continue;
      token = token.slice(eq + 1);
    }
    if (SAFE_PATHS.has(token)) continue;
    if (isOutside(token, cwd, roots)) return `references ${token}`;
  }
  return undefined;
}

// ---------------------------------------------------------------------------
// Confirmation
// ---------------------------------------------------------------------------

const CHOICES = [
  "Allow once",
  "Allow for this session",
  "Deny",
  "Deny with feedback",
] as const;

async function confirmOutsideCwd(
  ctx: { hasUI: boolean; ui: any },
  key: string,
  title: string,
  detail: string,
): Promise<{ block: true; reason: string } | undefined> {
  if (sessionAllow.has(key)) return undefined;

  if (!ctx.hasUI) {
    return {
      block: true,
      reason: `Blocked: ${title} (outside working directory, no UI to confirm)`,
    };
  }

  notify(`Permission required: ${key}`, "");

  const choice = await ctx.ui.select(
    `Outside working directory: ${title}\n\n${detail}`,
    [...CHOICES],
  );

  if (choice === "Allow once") return undefined;

  if (choice === "Allow for this session") {
    sessionAllow.add(key);
    return undefined;
  }

  if (choice === "Deny with feedback") {
    const feedback = await ctx.ui.input(
      "Feedback for the agent:",
      "e.g. use a path inside the project",
    );
    if (feedback?.trim()) {
      return {
        block: true,
        reason: `Blocked by user: ${title} — ${feedback.trim()}`,
      };
    }
  }

  // "Deny", empty feedback, or Esc.
  return { block: true, reason: `Blocked by user: ${title}` };
}

// ---------------------------------------------------------------------------
// Extension
// ---------------------------------------------------------------------------

const KNOWN_TOOLS = new Set(["bash", "read", "write", "edit"]);

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    const cwd = ctx.cwd;
    // Follow symlinks in the cwd itself (e.g. macOS /tmp → /private/tmp).
    const roots = [...new Set([resolve(cwd), resolveReal(resolve(cwd))])];

    if (isToolCallEventType("bash", event)) {
      const command = event.input.command ?? "";
      const risk = checkCommand(command, cwd, roots);
      if (!risk) return undefined;
      return confirmOutsideCwd(
        ctx,
        "bash",
        `bash command ${risk}`,
        `${command}\n(cwd: ${cwd})`,
      );
    }

    if (
      isToolCallEventType("read", event) ||
      isToolCallEventType("write", event) ||
      isToolCallEventType("edit", event)
    ) {
      const path = event.input.path ?? "";
      if (!isOutside(path, cwd, roots)) return undefined;
      return confirmOutsideCwd(
        ctx,
        event.toolName,
        `${event.toolName} touches a file outside the working directory`,
        `${resolvePath(path, cwd)}\n(cwd: ${cwd})`,
      );
    }

    // Any other tool (MCP, custom): scan string inputs for outside paths.
    if (!KNOWN_TOOLS.has(event.toolName)) {
      for (const value of Object.values(event.input ?? {})) {
        if (typeof value !== "string") continue;
        if (!/^([/~$]|\.\.?\/)/.test(value) && !value.includes("/../"))
          continue;
        if (!isOutside(value, cwd, roots)) continue;
        return confirmOutsideCwd(
          ctx,
          event.toolName,
          `${event.toolName} received a path outside the working directory`,
          `${value}\n(cwd: ${cwd})`,
        );
      }
    }

    return undefined;
  });
}
