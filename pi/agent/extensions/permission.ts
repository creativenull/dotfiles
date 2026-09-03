/**
 * Permission Extension
 *
 * Blocks destructive bash commands and asks for user confirmation.
 * Also prompts when creating new files via the write tool.
 *
 * Features:
 * - Detects dangerous commands (rm, dd, mkfs, git push --force, etc.)
 * - Shows a styled TUI dialog with three choices: Allow, Deny, or Provide Feedback
 * - Feedback lets the user type instructions to redirect the agent
 * - Blocks command if user denies, feeds back to agent
 * - Prompts when creating new files via write tool
 *
 * No npm dependencies required - uses only Pi's built-in types and TUI components.
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
import { existsSync } from "node:fs";

/** Result of the permission dialog */
type PermissionResult =
  | { action: "allow" }
  | { action: "deny" }
  | { action: "feedback"; message: string };

/**
 * Destructive command patterns to block.
 * Each pattern is tested against the bash command.
 */
const DESTRUCTIVE_PATTERNS: Array<{ pattern: RegExp; label: string }> = [
  // File deletion
  { pattern: /\brm\s+/, label: "rm" },
  { pattern: /\brmdir\s+/, label: "rmdir" },
  { pattern: /\bunlink\s+/, label: "unlink" },

  // File creation
  { pattern: /\btouch\s+/, label: "touch" },

  // Disk operations
  { pattern: /\bmkfs\s+/, label: "mkfs" },
  { pattern: /\bfdisk\s+/, label: "fdisk" },
  { pattern: /\bparted\s+/, label: "parted" },
  { pattern: /\bdd\s+if=/, label: "dd (disk copy)" },

  // Process/system
  { pattern: /\bkill\s+-9\s+1\b/, label: "kill -9 1 (kill init)" },
  { pattern: /\bkillall\s+/, label: "killall" },
  { pattern: /\bpkill\s+/, label: "pkill" },

  // Git force operations
  { pattern: /\bgit\s+push\s+--force\b/, label: "git push --force" },
  { pattern: /\bgit\s+reset\s+--hard\b/, label: "git reset --hard" },
  { pattern: /\bgit\s+clean\s+-fd?\b/, label: "git clean -fd" },

  // System overwrites
  { pattern: />\s*\/dev\/(sda|hda|nvme)/, label: "write to disk device" },

  // Insecure permissions on root
  { pattern: /\bchmod\s+-R\s+777\s+\//, label: "chmod 777 /" },
];

/**
 * Package/scaffolding command patterns that require permission.
 * Each pattern is tested against the bash command.
 */
const PACKAGE_PATTERNS: Array<{ pattern: RegExp; label: string }> = [
  // npm install/uninstall globally (including i/r aliases)
  {
    pattern:
      /\bnpm\s+(i|install|r|uninstall|add|remove)\b[^\n]*\s(?:-g|--global)(?:\s|$)/,
    label: "npm install/uninstall -g",
  },

  // npm install / uninstall (including i/r aliases)
  {
    pattern: /\bnpm\s+(i|install|r|uninstall|add|remove)\b/,
    label: "npm install/uninstall",
  },

  // npm run scripts
  { pattern: /\bnpm\s+run\b/, label: "npm run" },

  // composer global commands
  { pattern: /\bcomposer\s+global\b/, label: "composer global" },

  // composer require / remove
  {
    pattern: /\bcomposer\s+(require|remove)\b/,
    label: "composer require/remove",
  },

  // npm start / test scripts
  { pattern: /\bnpm\s+(start|test)\b/, label: "npm start/test" },

  // npx (arbitrary package execution)
  { pattern: /\bnpx\b/, label: "npx" },

  // npm publish / unpublish (supply-chain risk)
  { pattern: /\bnpm\s+(un)?publish\b/, label: "npm publish/unpublish" },

  // npm registry config change (supply-chain risk)
  {
    pattern: /\bnpm\s+config\s+set\s+registry\b/,
    label: "npm config set registry",
  },

  // php artisan migrations
  { pattern: /\bphp\s+artisan\s+migrate\b/, label: "php artisan migrate" },

  // php artisan scaffolding
  { pattern: /\bphp\s+artisan\s+make\b/, label: "php artisan make" },
];

/**
 * Show a styled permission dialog with three choices.
 *
 * Choices:
 * - Allow: proceed with the action
 * - Deny: block the action
 * - Provide Feedback: type a message to redirect the agent
 *
 * Uses a two-phase UI: first a SelectList for the choice,
 * then an Input field if the user picks "Provide Feedback".
 */
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
    { value: "deny", label: "✗ Deny", description: "Block this action" },
    {
      value: "feedback",
      label: "✏ Provide Feedback",
      description: "Type instructions to redirect the agent",
    },
  ];

  // Phase 1: Select an action
  const choice = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
    const container = new Container();
    container.addChild(
      new DynamicBorder((s: string) => theme.fg("warning", s)),
    );

    // Title
    container.addChild(
      new Text(theme.fg("warning", theme.bold(`⚠ ${title}`)), 1, 0),
    );
    container.addChild(new Spacer());

    // Description (the command or file path)
    const descLines = description.split("\n");
    for (const line of descLines) {
      container.addChild(new Text(theme.fg("text", line), 1, 0));
    }
    container.addChild(new Spacer());

    // SelectList with themed styling
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

    // Footer hint
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

  // Handle escape / cancel
  if (choice === null || choice === "deny") {
    return { action: "deny" };
  }

  if (choice === "allow") {
    return { action: "allow" };
  }

  // Phase 2: Collect feedback input
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

      // Description reminder
      const descLines = description.split("\n");
      for (const line of descLines) {
        container.addChild(new Text(theme.fg("dim", line), 1, 0));
      }
      container.addChild(new Spacer());

      // Input field
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

export default function (pi: ExtensionAPI) {
  // Intercept bash tool calls for destructive commands
  pi.on("tool_call", async (event, ctx) => {
    if (isToolCallEventType("bash", event)) {
      const command = event.input.command?.toLowerCase() ?? "";

      for (const { pattern, label } of [
        ...DESTRUCTIVE_PATTERNS,
        ...PACKAGE_PATTERNS,
      ]) {
        if (pattern.test(command)) {
          const result = await showPermissionDialog(
            ctx,
            `Command requires permission: ${label}`,
            event.input.command,
          );

          if (result.action === "deny") {
            return { block: true, reason: "Blocked by user: bash" };
          }

          if (result.action === "feedback") {
            return {
              block: true,
              reason: `Blocked by user: bash — ${result.message}`,
            };
          }

          // action === 'allow' → proceed
          break;
        }
      }
    }

    // Intercept write tool for new files
    if (isToolCallEventType("write", event)) {
      const filePath = event.input.path;

      if (!existsSync(filePath)) {
        const result = await showPermissionDialog(
          ctx,
          "Create new file",
          filePath,
        );

        if (result.action === "deny") {
          return { block: true, reason: "Blocked by user: write" };
        }

        if (result.action === "feedback") {
          return {
            block: true,
            reason: `Blocked by user: write — ${result.message}`,
          };
        }

        // action === 'allow' → proceed
      }
    }
  });
}
