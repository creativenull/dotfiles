/**
 * title.ts - spinner in the terminal tab title while the agent is working.
 * See README.md in this directory for details.
 */
import { basename } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// pi's window title prefix (APP_TITLE in pi's config, not part of the public API)
const APP_TITLE = "π";

const SPINNER_FRAMES = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
const SPINNER_INTERVAL_MS = 120;

export default function (pi: ExtensionAPI) {
	let spinnerTimer: ReturnType<typeof setInterval> | undefined;

	function baseTitle(cwd: string): string {
		const sessionName = pi.getSessionName();
		const cwdBasename = basename(cwd);
		return sessionName
			? `${APP_TITLE} - ${sessionName} - ${cwdBasename}`
			: `${APP_TITLE} - ${cwdBasename}`;
	}

	function stopSpinner(ctx: ExtensionContext) {
		if (spinnerTimer) {
			clearInterval(spinnerTimer);
			spinnerTimer = undefined;
		}
		// Restore the original title
		ctx.ui.setTitle(baseTitle(ctx.cwd));
	}

	pi.on("agent_start", (_event, ctx) => {
		if (!ctx.hasUI) return;
		const base = baseTitle(ctx.cwd);
		let frame = 0;
		stopSpinner(ctx); // guard against overlapping runs
		spinnerTimer = setInterval(() => {
			ctx.ui.setTitle(`${SPINNER_FRAMES[frame++ % SPINNER_FRAMES.length]} ${base}`);
		}, SPINNER_INTERVAL_MS);
		// Show first frame immediately
		ctx.ui.setTitle(`${SPINNER_FRAMES[frame++ % SPINNER_FRAMES.length]} ${base}`);
	});

	pi.on("agent_settled", (_event, ctx) => {
		stopSpinner(ctx);
	});

	pi.on("session_shutdown", (_event, ctx) => {
		if (spinnerTimer) clearInterval(spinnerTimer);
		spinnerTimer = undefined;
	});
}
