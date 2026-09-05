# Extensions

Three standalone extensions for [pi coding agent](https://github.com/earendil-works/pi-coding-agent).
Each is a self-contained TypeScript module exporting a default extension entry
point.

## notify.ts — Terminal Notifications

Sends a desktop/terminal notification when the agent finishes a turn, using
OSC 777 escape sequences (OSC 99 for the Kitty terminal, so notifications
stack instead of replacing each other). On success it shows a short preview
of the assistant's answer; on provider error it shows just the status code,
and it stays silent on user abort. Optional config lives at
`~/.pi/agent/notify.json` (`title`, `maxPreviewLength`).

## permission.ts — Confirmation Gates

Gates `bash`, `write`, and `edit` tool calls behind a confirmation dialog
driven by a single declarative policy table (`RULES`), where each rule is a
regex with a scope: `"always"` prompt (e.g. `rm`, `git push --force`,
`npm install`) or `"outside-cwd"` prompt only when the action touches paths
outside pi's launch directory (e.g. `mv`, `cp`, redirection). Triggering a
gate sends a brief notification naming just the tool (`Permission required:
bash`). The dialog offers Allow, Always Allow (per session), Deny, or
Provide Feedback; without a UI, gated actions block by default. Path
detection is a best-effort heuristic, not a sandbox.

## web-fetch.ts — Web Fetch Tool

Registers a `web_fetch` tool plus `/fetch` and `/web-fetch-status` commands
that fetch any URL through the [Jina AI Reader API](https://jina.ai/reader/),
which renders JavaScript, handles redirects, extracts the main content, and
returns clean markdown. Content up to 10,000 characters goes straight to the
LLM; larger content is saved to a temp file for searching with `rg`, and the
temp dir is cleaned up on session shutdown. Requires the
`JINA_AI_READER_API_KEY` environment variable (free key at
<https://jina.ai/reader/>); the extension fails to load without it.
