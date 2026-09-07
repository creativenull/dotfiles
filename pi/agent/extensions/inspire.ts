/**
 * Inspire — replaces pi's default "Working..." streaming message with a
 * randomly picked inspiring quote, formatted like `php artisan inspire`.
 *
 * Quotes are curated from Laravel's Illuminate\Foundation\Inspiring class:
 * https://github.com/laravel/framework/blob/11.x/src/Illuminate/Foundation/Inspiring.php
 *
 * Artisan renders each quote as bold/gray styled text; here it is shown as
 * plain theme-colored text (`text — author`, author bold) so it stays readable
 * in both light and dark themes.
 *
 * While the agent is working, the quote rotates to a new random one every 10
 * seconds until the run ends.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const QUOTES: Array<[text: string, author: string]> = [
	["Act only according to that maxim whereby you can, at the same time, will that it should become a universal law.", "Immanuel Kant"],
	["An unexamined life is not worth living.", "Socrates"],
	["Be present above all else.", "Naval Ravikant"],
	["Do what you can, with what you have, where you are.", "Theodore Roosevelt"],
	["Happiness is not something readymade. It comes from your own actions.", "Dalai Lama"],
	["He who is contented is rich.", "Laozi"],
	["I begin to speak only when I am certain what I will say is not better left unsaid.", "Cato the Younger"],
	["I have not failed. I've just found 10,000 ways that won't work.", "Thomas Edison"],
	["If you do not have a consistent goal in life, you can not live it in a consistent way.", "Marcus Aurelius"],
	["It is never too late to be what you might have been.", "George Eliot"],
	["It is not the man who has too little, but the man who craves more, that is poor.", "Seneca"],
	["It is quality rather than quantity that matters.", "Lucius Annaeus Seneca"],
	["Knowing is not enough; we must apply. Being willing is not enough; we must do.", "Leonardo da Vinci"],
	["Let all your things have their places; let each part of your business have its time.", "Benjamin Franklin"],
	["Live as if you were to die tomorrow. Learn as if you were to live forever.", "Mahatma Gandhi"],
	["No surplus words or unnecessary actions.", "Marcus Aurelius"],
	["Nothing worth having comes easy.", "Theodore Roosevelt"],
	["Order your soul. Reduce your wants.", "Augustine"],
	["People find pleasure in different ways. I find it in keeping my mind clear.", "Marcus Aurelius"],
	["Simplicity is an acquired taste.", "Katharine Gerould"],
	["Simplicity is the consequence of refined emotions.", "Jean D'Alembert"],
	["Simplicity is the essence of happiness.", "Cedric Bledsoe"],
	["Simplicity is the ultimate sophistication.", "Leonardo da Vinci"],
	["Smile, breathe, and go slowly.", "Thich Nhat Hanh"],
	["The only way to do great work is to love what you do.", "Steve Jobs"],
	["The whole future lies in uncertainty: live immediately.", "Seneca"],
	["Very little is needed to make a happy life.", "Marcus Aurelius"],
	["Waste no more time arguing what a good man should be, be one.", "Marcus Aurelius"],
	["Well begun is half done.", "Aristotle"],
	["When there is no desire, all things are at peace.", "Laozi"],
	["Walk as if you are kissing the Earth with your feet.", "Thich Nhat Hanh"],
	["Because you are alive, everything is possible.", "Thich Nhat Hanh"],
	["Breathing in, I calm body and mind. Breathing out, I smile.", "Thich Nhat Hanh"],
	["Life is available only in the present moment.", "Thich Nhat Hanh"],
	["The best way to take care of the future is to take care of the present moment.", "Thich Nhat Hanh"],
	["Nothing in life is to be feared, it is only to be understood. Now is the time to understand more, so that we may fear less.", "Marie Curie"],
	["The biggest battle is the war against ignorance.", "Mustafa Kemal Atatürk"],
	["Always remember that you are absolutely unique. Just like everyone else.", "Margaret Mead"],
	["You must be the change you wish to see in the world.", "Mahatma Gandhi"],
	["We must ship.", "Taylor Otwell"],
];

const BOLD = "\x1b[1m";
const RESET_BOLD = "\x1b[22m";
const QUOTE_INTERVAL_MS = 10_000;

function formatQuote(): string {
	const [text, author] = QUOTES[Math.floor(Math.random() * QUOTES.length)]!;
	// Quote text in the plain theme color, author in bold — no dim/gray ANSI
	// styling, so it stays readable in both light and dark themes.
	return `${text} — ${BOLD}${author}${RESET_BOLD}`;
}

export default function (pi: ExtensionAPI) {
	let rotateTimer: ReturnType<typeof setInterval> | undefined;

	const stopRotation = () => {
		if (rotateTimer) {
			clearInterval(rotateTimer);
			rotateTimer = undefined;
		}
	};

	const startRotation = (ctx: ExtensionContext) => {
		stopRotation();
		rotateTimer = setInterval(() => {
			ctx.ui.setWorkingMessage(formatQuote());
		}, QUOTE_INTERVAL_MS);
	};

	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setWorkingMessage(formatQuote());
	});

	// Fresh quote for each agent run (each time pi starts "working"), then
	// rotate to a new random quote every 10s until the run ends.
	pi.on("agent_start", async (_event, ctx) => {
		ctx.ui.setWorkingMessage(formatQuote());
		startRotation(ctx);
	});

	pi.on("agent_end", async () => {
		stopRotation();
	});

	pi.on("session_shutdown", async () => {
		stopRotation();
	});
}
