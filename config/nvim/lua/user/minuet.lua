local M = {}

function M.setup()
  require("minuet").setup({
    virtualtext = {
      auto_trigger_ft = {},
      keymap = {
        -- accept whole completion
        accept = "<Tab>",
        -- accept one line
        accept_line = nil,
        -- accept n lines (prompts for number)
        -- e.g. "A-z 2 CR" will accept 2 lines
        accept_n_lines = nil,
        -- Cycle to prev completion item, or manually invoke completion
        prev = "<A-[>",
        -- Cycle to next completion item, or manually invoke completion
        next = "<A-]>",
        dismiss = "<A-e>",
      },
    },
    provider = "openai_fim_compatible",
    n_completions = 1, -- recommend for local model for resource saving
    context_window = 1024,
    request_timeout = 5,
    throttle = 1500, -- Increase to reduce costs and avoid rate limits
    debounce = 600, -- Increase to reduce costs and avoid rate limits
    provider_options = {
      openai_compatible = {
        api_key = "OPENROUTER_API_KEY",
        end_point = "https://openrouter.ai/api/v1/chat/completions",
        model = "qwen/qwen3-coder-30b-a3b-instruct",
        name = "Openrouter",
        optional = {
          max_tokens = 56,
          top_p = 0.9,
        },
      },
      openai_fim_compatible = {
        api_key = "TERM",
        name = "Ollama",
        end_point = "http://127.0.0.1:11434/v1/completions",
        model = "codegemma:2b",
        optional = {
          max_tokens = 256,
          top_p = 0.9,
        },
      },
    },
  })
end

return M
