# Extensions

Five standalone extensions for [pi coding agent](https://github.com/earendil-works/pi-coding-agent).
Each is a self-contained TypeScript module exporting a default extension entry
point.

## title.ts - Spinner in Tab Title

Cycles a spinner frame in the terminal tab title while the agent is working,
such as: spinner frame, then the pi symbol, the session name, and the working
directory name, updating every 120ms. When the agent settles, the spinner
stops and the original title (pi symbol, session name, working directory) is
restored, matching pi's own session-start format. The pi symbol is hardcoded
since pi's app title constant is not part of its public API.

## notify.ts — Terminal Notifications

Sends a desktop/terminal notification when the agent finishes a turn, using
OSC 777 escape sequences (OSC 99 for the Kitty terminal, so notifications
stack instead of replacing each other). On success it shows a short preview
of the assistant's answer; on provider error it shows just the status code,
and it stays silent on user abort. Optional config lives at
`~/.pi/agent/notify.json` (`title`, `maxPreviewLength`).

## permission.ts — Working Directory Boundary

Blocks tool calls from touching anything outside the current working
directory: inside is free, outside prompts with Allow once, Allow for
this session, Deny, or Deny with feedback. Covers `bash` (including
fail-closed prompts for `$(…)`, `eval`, `sudo`, etc.),
`read`/`write`/`edit`, and path-like inputs to any other tool, sends a
notification via `notify.ts` when a prompt triggers, and blocks by
default without a UI. Best-effort heuristic, not a sandbox.

## inspire.ts — Inspiring Working Messages

Replaces pi's default "Working..." streaming message with a randomly picked
inspiring quote, formatted the same way `php artisan inspire` prints to
stdout (bold `“ quote ”` plus a dim `— author` line). A fresh quote is drawn
on session start and on every agent run, and rotates to a new random quote
every 10 seconds while the agent is working. Shamelessly copied from:
<https://github.com/laravel/framework/blob/11.x/src/Illuminate/Foundation/Inspiring.php>

## web-fetch.ts — Web Fetch Tool

Registers a `web_fetch` tool plus `/fetch` and `/web-fetch-status` commands
that fetch any URL through the [Jina AI Reader API](https://jina.ai/reader/),
which renders JavaScript, handles redirects, extracts the main content, and
returns clean markdown. Content up to 10,000 characters goes straight to the
LLM; larger content is saved to a temp file for searching with `rg`, and the
temp dir is cleaned up on session shutdown. Requires the
`JINA_AI_READER_API_KEY` environment variable (free key at
<https://jina.ai/reader/>); the extension fails to load without it.
