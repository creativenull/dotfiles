/**
 * Permission Extension
 *
 * Gates bash commands and file tools (write, edit) behind a confirmation
 * dialog driven by a single declarative policy table (RULES). Each rule
 * declares a regex to match and a scope: "always", or "outside-cwd" to
 * only apply when the command touches paths outside pi's launch directory.
 *
 * File ops (mkdir, touch, mv, cp, write, edit) are free within the launch
 * directory. An "Always Allow" choice remembers approvals for the rest of
 * the session. Without a UI (-p / JSON mode), gated actions block by default.
 *
 * Path detection is a best-effort heuristic, not a sandbox: it catches
 * absolute paths, ~ expansion, ../ traversal, and redirection targets, but
 * not env-var indirection, subshell output, or symlink escapes.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  DynamicBorder,
  isToolCallEventType,
} from "@earendil-works/pi-coding-agent";
import { notify } from "./notify.ts";
import {
  Container,
  type SelectItem,
  SelectList,
  Text,
  Input,
  Spacer,
} from "@earendil-works/pi-tui";
import { homedir } from "node:os";
import { isAbsolute, resolve, sep } from "node:path";

type PermissionResult =
  | { action: "allow" }
  | { action: "allow-always" }
  | { action: "deny" }
  | { action: "feedback"; message: string };

type Rule = {
  label: string;
  pattern: RegExp;
  scope: "always" | "outside-cwd";
};

const RULES: Rule[] = [
  { label: "rm", pattern: /\brm\s+/, scope: "always" },
  { label: "rmdir", pattern: /\brmdir\s+/, scope: "always" },
  { label: "unlink", pattern: /\bunlink\s+/, scope: "always" },
  { label: "mkfs", pattern: /\bmkfs\s+/, scope: "always" },
  { label: "fdisk", pattern: /\bfdisk\s+/, scope: "always" },
  { label: "parted", pattern: /\bparted\s+/, scope: "always" },
  { label: "dd (disk copy)", pattern: /\bdd\s+if=/, scope: "always" },
  {
    label: "kill -9 1 (kill init)",
    pattern: /\bkill\s+-9\s+1\b/,
    scope: "always",
  },
  { label: "killall", pattern: /\bkillall\s+/, scope: "always" },
  { label: "pkill", pattern: /\bpkill\s+/, scope: "always" },
  {
    label: "git push --force",
    pattern: /\bgit\s+push\s+--force\b/,
    scope: "always",
  },
  {
    label: "git reset --hard",
    pattern: /\bgit\s+reset\s+--hard\b/,
    scope: "always",
  },
  {
    label: "git clean -fd",
    pattern: /\bgit\s+clean\s+-fd?\b/,
    scope: "always",
  },
  {
    label: "write to disk device",
    pattern: />\s*\/dev\/(sda|hda|nvme)/,
    scope: "always",
  },
  { label: "chmod 777 /", pattern: /\bchmod\s+-R\s+777\s+\//, scope: "always" },
  {
    label: "npm install/uninstall -g",
    pattern:
      /\bnpm\s+(i|install|r|uninstall|add|remove)\b[^\n]*\s(?:-g|--global)(?:\s|$)/,
    scope: "always",
  },
  {
    label: "npm install/uninstall",
    pattern: /\bnpm\s+(i|install|r|uninstall|add|remove)\b/,
    scope: "always",
  },
  { label: "npm run", pattern: /\bnpm\s+run\b/, scope: "always" },
  {
    label: "composer global",
    pattern: /\bcomposer\s+global\b/,
    scope: "always",
  },
  {
    label: "composer require/remove",
    pattern: /\bcomposer\s+(require|remove)\b/,
    scope: "always",
  },
  {
    label: "npm start/test",
    pattern: /\bnpm\s+(start|test)\b/,
    scope: "always",
  },
  { label: "npx", pattern: /\bnpx\b/, scope: "always" },
  {
    label: "npm publish/unpublish",
    pattern: /\bnpm\s+(un)?publish\b/,
    scope: "always",
  },
  {
    label: "npm config set registry",
    pattern: /\bnpm\s+config\s+set\s+registry\b/,
    scope: "always",
  },
  {
    label: "php artisan migrate",
    pattern: /\bphp\s+artisan\s+migrate\b/,
    scope: "always",
  },
  {
    label: "php artisan make",
    pattern: /\bphp\s+artisan\s+make\b/,
    scope: "always",
  },
  { label: "mv", pattern: /\bmv\s+/, scope: "outside-cwd" },
  { label: "cp", pattern: /\bcp\s+/, scope: "outside-cwd" },
  { label: "mkdir", pattern: /\bmkdir\s+/, scope: "outside-cwd" },
  { label: "touch", pattern: /\btouch\s+/, scope: "outside-cwd" },
  { label: "chmod", pattern: /\bchmod\s+/, scope: "outside-cwd" },
  { label: "chown", pattern: /\bchown\s+/, scope: "outside-cwd" },
  { label: "chgrp", pattern: /\bchgrp\s+/, scope: "outside-cwd" },
  { label: "ln", pattern: /\bln\s+/, scope: "outside-cwd" },
  { label: "tee", pattern: /\btee\s+/, scope: "outside-cwd" },
  { label: "dd", pattern: /\bdd\b/, scope: "outside-cwd" },
  { label: "truncate", pattern: /\btruncate\s+/, scope: "outside-cwd" },
  { label: "shred", pattern: /\bshred\s+/, scope: "outside-cwd" },
  {
    label: "sed -i",
    pattern: /\bsed\s+(-[a-zA-Z]*i[a-zA-Z]*\s|--in-place\b)/,
    scope: "outside-cwd",
  },
  {
    label: "output redirection (>)",
    pattern: /(^|\s)>\s*\S/,
    scope: "outside-cwd",
  },
  {
    label: "append redirection (>>)",
    pattern: /(^|\s)>>/,
    scope: "outside-cwd",
  },
];

const SAFE_DEV_PATHS = new Set([
  "/dev/null",
  "/dev/stdin",
  "/dev/stdout",
  "/dev/stderr",
  "/dev/tty",
]);

const sessionAllowlist = new Set<string>();

function isPathOutsideCwd(path: string, cwd: string): boolean {
  if (!path || path === ".") return false;

  let abs: string;
  if (path.startsWith("~")) {
    abs = resolve(homedir(), path.slice(1));
  } else if (isAbsolute(path)) {
    abs = resolve(path);
  } else {
    if (!/(^|\/)\.\.(\/|$)/.test(path)) return false;
    abs = resolve(cwd, path);
  }

  const root = resolve(cwd);
  return abs !== root && !abs.startsWith(root + sep);
}

function hasPathOutsideCwd(command: string, cwd: string): boolean {
  const tokens = command.match(/[^\s;|&()]+/g) ?? [];

  for (const raw of tokens) {
    let token = raw.replace(/^[0-9]*[<>]+/, "").replace(/^["']+|["']+$/g, "");
    if (!token) continue;

    if (token.startsWith("-")) {
      const eq = token.indexOf("=");
      if (eq === -1) continue;
      token = token.slice(eq + 1);
    }

    if (SAFE_DEV_PATHS.has(token)) continue;
    if (isPathOutsideCwd(token, cwd)) return true;
  }

  return false;
}

function findMatchingRule(
  command: string,
  outsideCwd: boolean,
): Rule | undefined {
  return RULES.find(
    ({ pattern, scope }) =>
      (scope === "always" || outsideCwd) && pattern.test(command),
  );
}

async function showPermissionDialog(
  ctx: { ui: any },
  title: string,
  description: string,
): Promise<PermissionResult> {
  notify(`Permission required: ${title}`, description);

  const items: SelectItem[] = [
    {
      value: "allow",
      label: "✓ Allow",
      description: "Proceed with the action",
    },
    {
      value: "allow-always",
      label: "✓✓ Always Allow (this session)",
      description: "Skip future prompts for this command type",
    },
    { value: "deny", label: "✗ Deny", description: "Block this action" },
    {
      value: "feedback",
      label: "✏ Provide Feedback",
      description: "Type instructions to redirect the agent",
    },
  ];

  const choice = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
    const container = new Container();
    container.addChild(
      new DynamicBorder((s: string) => theme.fg("warning", s)),
    );
    container.addChild(
      new Text(theme.fg("warning", theme.bold(`⚠ ${title}`)), 1, 0),
    );
    container.addChild(new Spacer());

    for (const line of description.split("\n")) {
      container.addChild(new Text(theme.fg("text", line), 1, 0));
    }
    container.addChild(new Spacer());

    const selectList = new SelectList(items, items.length, {
      selectedPrefix: (text: string) => theme.fg("accent", text),
      selectedText: (text: string) => theme.fg("accent", text),
      description: (text: string) => theme.fg("muted", text),
      scrollInfo: (text: string) => theme.fg("dim", text),
      noMatch: (text: string) => theme.fg("warning", text),
    });

    selectList.onSelect = (item) => done(item.value);
    selectList.onCancel = () => done(null);
    container.addChild(selectList);
    container.addChild(
      new Text(
        theme.fg("dim", "↑↓ navigate • enter select • esc cancel"),
        1,
        0,
      ),
    );
    container.addChild(
      new DynamicBorder((s: string) => theme.fg("warning", s)),
    );

    return {
      render(width: number) {
        return container.render(width);
      },
      invalidate() {
        container.invalidate();
      },
      handleInput(data: string) {
        selectList.handleInput(data);
        tui.requestRender();
      },
    };
  });

  if (choice === null || choice === "deny") {
    return { action: "deny" };
  }

  if (choice === "allow") {
    return { action: "allow" };
  }

  if (choice === "allow-always") {
    return { action: "allow-always" };
  }

  const feedback = await ctx.ui.custom<string | null>(
    (tui, theme, _kb, done) => {
      const container = new Container();
      container.addChild(
        new DynamicBorder((s: string) => theme.fg("accent", s)),
      );
      container.addChild(
        new Text(theme.fg("accent", theme.bold("✏ Provide Feedback")), 1, 0),
      );
      container.addChild(new Spacer());
      container.addChild(
        new Text(theme.fg("muted", "Type instructions for the agent:"), 1, 0),
      );
      container.addChild(new Spacer());

      for (const line of description.split("\n")) {
        container.addChild(new Text(theme.fg("dim", line), 1, 0));
      }
      container.addChild(new Spacer());

      const input = new Input();
      input.onSubmit = (value: string) => done(value || null);
      input.onEscape = () => done(null);
      container.addChild(input);
      container.addChild(new Spacer());
      container.addChild(
        new Text(theme.fg("dim", "enter submit • esc cancel"), 1, 0),
      );
      container.addChild(
        new DynamicBorder((s: string) => theme.fg("accent", s)),
      );

      return {
        render(width: number) {
          return container.render(width);
        },
        invalidate() {
          container.invalidate();
        },
        handleInput(data: string) {
          input.handleInput(data);
          tui.requestRender();
        },
      };
    },
  );

  if (feedback === null || feedback.trim() === "") {
    return { action: "deny" };
  }

  return { action: "feedback", message: feedback.trim() };
}

function handlePermissionResult(
  result: PermissionResult,
  tool: "bash" | "write" | "edit",
): { block: true; reason: string } | undefined {
  if (result.action === "deny") {
    return { block: true, reason: `Blocked by user: ${tool}` };
  }

  if (result.action === "feedback") {
    return {
      block: true,
      reason: `Blocked by user: ${tool} — ${result.message}`,
    };
  }

  return undefined;
}

async function gate(
  ctx: { ui: any; hasUI: boolean },
  tool: "bash" | "write" | "edit",
  title: string,
  description: string,
  allowlistKey: string,
): Promise<{ block: true; reason: string } | undefined> {
  if (!ctx.hasUI) {
    return {
      block: true,
      reason: `Blocked: ${tool} requires permission but no UI is available for confirmation`,
    };
  }

  const result = await showPermissionDialog(ctx, title, description);

  if (result.action === "allow-always") {
    sessionAllowlist.add(allowlistKey);
  }

  return handlePermissionResult(result, tool);
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    const cwd = ctx.cwd;

    if (isToolCallEventType("bash", event)) {
      const command = event.input.command ?? "";
      const lower = command.toLowerCase();
      const outside = hasPathOutsideCwd(lower, cwd);

      const rule = findMatchingRule(lower, outside);
      if (!rule || sessionAllowlist.has(rule.label)) return undefined;

      const title = outside
        ? `Outside working directory: ${rule.label}`
        : `Command requires permission: ${rule.label}`;

      return gate(
        ctx,
        "bash",
        title,
        `${command}\n(working directory: ${cwd})`,
        rule.label,
      );
    }

    if (
      isToolCallEventType("write", event) ||
      isToolCallEventType("edit", event)
    ) {
      const filePath = event.input.path ?? "";

      if (!isPathOutsideCwd(filePath, cwd)) return undefined;

      const absPath = isAbsolute(filePath)
        ? resolve(filePath)
        : resolve(cwd, filePath);
      const key = `${event.toolName}-outside-cwd`;
      if (sessionAllowlist.has(key)) return undefined;

      return gate(
        ctx,
        event.toolName as "write" | "edit",
        `${event.toolName} file outside working directory`,
        `${absPath}\n(working directory: ${cwd})`,
        key,
      );
    }

    return undefined;
  });
}
