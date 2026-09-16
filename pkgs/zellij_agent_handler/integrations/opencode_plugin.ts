/**
 * Zellij integration plugin for OpenCode.
 *
 * Sends agent state to the zellij-agent-handler WASM plugin via `zellij pipe`.
 * The WASM plugin renders a clickable HUD in the status bar.
 *
 * States:
 *   Idle       → agent finished, waiting for user prompt
 *   Busy       → agent is working
 *   Permission → agent needs permission approval
 *   Retry      → agent is retrying after an error
 */

import { type ChildProcess, spawn } from "node:child_process";
import { Plugin } from "@opencode/plugin";

function getPaneId() {
	return process.env.ZELLIJ_PANE_ID || "0";
}

// Run a zellij command without a shell. Resolves with stdout (empty on error)
// and never throws, mirroring the fire-and-forget behavior of the V1 plugin.
function zellij(
	args: string[],
	{ capture = false }: { capture?: boolean } = {},
): Promise<string> {
	return new Promise((resolve) => {
		let child: ChildProcess;
		try {
			child = spawn("zellij", args, {
				stdio: ["ignore", capture ? "pipe" : "ignore", "ignore"],
			});
		} catch {
			resolve("");
			return;
		}
		let out = "";
		if (capture && child.stdout) {
			child.stdout.on("data", (chunk) => {
				out += chunk.toString();
			});
		}
		child.on("error", () => resolve(""));
		child.on("close", () => resolve(out));
	});
}

async function sendState(activity, name, action, snippet) {
	const payload = JSON.stringify({
		pane_id: parseInt(getPaneId(), 10),
		activity,
		name,
		action: action || undefined,
		snippet: snippet || undefined,
	});
	await zellij(["pipe", "--name", "agent-handler", "--", payload]);
}

export default Plugin.define({
	id: "zellij",
	async setup(ctx) {
		if (!process.env.ZELLIJ) return;

		const paneId = getPaneId();

		// Derive pane name from zellij pane list.
		let paneName = "agent";
		try {
			const stdout = await zellij(["action", "list-panes", "--json"], {
				capture: true,
			});
			const panes = JSON.parse(stdout);
			const self = panes.find((p) => String(p.id) === paneId && !p.is_plugin);
			if (self?.title) paneName = self.title;
		} catch {}

		let lastAction = null;
		let lastSnippet = null;

		await sendState("Idle", paneName, null, null);

		const controller = new AbortController();

		void (async () => {
			for await (const event of ctx.event.subscribe({
				signal: controller.signal,
			})) {
				switch (event.type) {
					case "session.status": {
						const status = event.properties.status.type;
						const activity =
							status === "busy"
								? "Busy"
								: status === "retry"
									? "Retry"
									: "Idle";
						if (activity === "Idle") {
							lastAction = null;
						}
						await sendState(activity, paneName, lastAction, lastSnippet);
						break;
					}
					case "session.idle": {
						lastAction = null;
						await sendState("Idle", paneName, null, lastSnippet);
						break;
					}
					case "permission.updated": {
						lastAction = "waiting for permission";
						await sendState("Permission", paneName, lastAction, lastSnippet);
						break;
					}
					case "permission.replied": {
						lastAction = null;
						await sendState("Busy", paneName, null, lastSnippet);
						break;
					}
					case "message.part.updated": {
						const part = event.properties;
						if (part.type === "tool-invocation") {
							lastAction = part.toolName || "tool";
						} else if (part.type === "text") {
							const text = part.text || "";
							lastSnippet = text.slice(-60).replace(/\n/g, " ").trim();
						}
						await sendState("Busy", paneName, lastAction, lastSnippet);
						break;
					}
				}
			}
		})();

		return () => controller.abort();
	},
});
