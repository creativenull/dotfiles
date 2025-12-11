#!/usr/bin/env -S deno run --allow-read

type StdinResponse = {
  hook_event_name: string;
  session_id: string;
  transcript_path: string;
  cwd: string;
  model: {
    id: string;
    display_name: string;
  };
  workspace: {
    current_dir: string;
    project_dir: string;
  };
  version: string;
  output_style: {
    name: string;
  };
  cost: {
    total_cost_usd: number;
    total_duration_ms: number;
    total_api_duration_ms: number;
    total_lines_added: number;
    total_lines_removed: number;
  };
};

type TranscriptData = {
  message?: {
    usage?: {
      input_tokens?: number;
      output_tokens?: number;
      cache_read_input_tokens?: number;
      cache_creation_input_tokens?: number;
    };
  };
};

function getToolInfo(r: StdinResponse) {
  const ver = `v${r.version}`;
  const model =  r.model.display_name;

  return `${ver} - ${model}`;
}

function getCost(r: StdinResponse): string {
  const rawCost = r.cost.total_cost_usd;
  let cost = rawCost.toFixed(4);

  // Show green if < $5
  // Show warning if < $10
  // Show error otherwise
  if (rawCost < 5) {
    // Make sure to reset the color after
    cost = `\x1b[32m${cost}\x1b[0m`;
  } else if (rawCost < 10) {
    cost = `\x1b[33m${cost}\x1b[0m`;
  } else {
    cost = `\x1b[31m${cost}\x1b[0m`;
  }

  return `Cost: $${cost}`;
}

function getUnitNumber(n: number): string {
  if (n >= 0 && n < 1000) {
    return n.toString();
  } else if (n >= 1000 && n < 1000000) {
    return `${(n / 1000).toFixed(1)}k`;
  } else if (n >= 1000000) {
    return `${(n / 1000000).toFixed(1)}M`;
  } else {
    return n.toString();
  }
}

async function getContextLength(r: StdinResponse): Promise<string> {
  try {
    const path = r.transcript_path;
    const content = await Deno.readTextFile(path);

    // Parse all valid transcript lines
    const messages = content
      .split("\n")
      .map((line) => {
        try {
          return JSON.parse(line) as TranscriptData;
        } catch {
          return null;
        }
      })
      .filter((d): d is TranscriptData =>
        d !== null && d.message?.usage !== undefined
      );

    // Get the last message's usage (represents current context)
    const lastMessage = messages.at(-1);

    if (!lastMessage?.message?.usage) {
      return "";
    }

    const usage = lastMessage.message.usage;
    const inTokens = (usage.input_tokens ?? 0) +
      (usage.cache_read_input_tokens ?? 0) +
      (usage.cache_creation_input_tokens ?? 0);
    const outTokens = usage.output_tokens ?? 0;
    const totalTokens = inTokens + outTokens;
    const maxTokens = 200_000;
    const freeSpace = maxTokens - totalTokens;

    const items = [
      `${getUnitNumber(totalTokens)}/${getUnitNumber(maxTokens)}`,
      `free: ${getUnitNumber(freeSpace)}`,
    ];

    return items.join(" - ");
  } catch (_e) {
    return "No context info";
  }
}

async function main(input: string) {
  try {
    const r = JSON.parse(input) as StdinResponse;

    const items = await Promise.all([
      getToolInfo(r),
      getCost(r),
      getContextLength(r),
    ]);

    console.log(items.filter((i) => !!i).join(" | "));
  } catch (_e) {
    console.log("Status line error", _e);
  }
}

const inputDecoder = new TextDecoder();
let input = "";

for await (const chunk of Deno.stdin.readable) {
  input += inputDecoder.decode(chunk);
}

await main(input);
