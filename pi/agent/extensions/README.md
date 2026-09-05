# Extensions

Three standalone extensions for [pi coding agent](https://github.com/earendil-works/pi-coding-agent). Each is a self-contained TypeScript module exporting a default extension entry point.

## notify.ts — Terminal Notifications

Sends a desktop/terminal notification when the agent finishes a turn, using
OSC 777 escape sequences (OSC 99 for the Kitty terminal, so notifications
stack instead of replacing each other).

- On success: shows the first sentence of the assistant's answer as a
  preview, stripped of markdown and truncated sensibly.
- On user abort: stays silent.
- On provider error: shows just the status code, e.g.
  `Provider error (429)`.
- Optional config at `~/.pi/agent/notify.json`:
  `{ "title": string, "maxPreviewLength": number }`.

## permission.ts — Confirmation Gates

Gates `bash`, `write`, and `edit` tool calls behind a confirmation dialog
driven by a single declarative policy table (`RULES`). Each rule is a regex
with a scope:

- `"always"` — always prompt (e.g. `rm`, `git push --force`, `npm install`,
  `npx`, `sed -i`, output redirection).
- `"outside-cwd"` — only prompt when the command touches paths outside
  pi's launch directory (e.g. `mv`, `cp`, `chmod`, writes outside cwd).

File ops are free within the launch directory. The dialog offers
**Allow**, **Always Allow** (remembered for the rest of the session), **Deny**,
or **Provide Feedback** (send instructions back to the agent). Without a UI
(`-p` / JSON mode), gated actions block by default.

Path detection is a best-effort heuristic — it catches absolute paths, `~`
expansion, `../` traversal, and redirection targets, but is **not a sandbox**:
env-var indirection, subshell output, and symlink escapes can get around it.

## web-fetch.ts — Web Fetch Tool

Registers a `web_fetch` tool plus `/fetch` and `/web-fetch-status` commands.
Content is fetched through the [Jina AI Reader API](https://jina.ai/reader/),
which renders JavaScript, handles redirects, extracts the main content
(removing nav, ads, sidebars), and returns clean markdown.

- Content ≤ 10,000 characters is returned directly to the LLM.
- Larger content is saved to a temp file; the tool returns the path and
  suggests using `rg` to search it.
- Only `http` and `https` URLs are allowed; the temp dir is cleaned up on
  session shutdown.

Requires the `JINA_AI_READER_API_KEY` environment variable (free key at
<https://jina.ai/reader/>); the extension fails to load without it.
