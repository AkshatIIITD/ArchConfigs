-- Per-machine AI setup. Shared logic lives here; machine-specific values
-- (endpoint, models, token env var name) live in the untracked
-- lua/config/ai_local.lua. Without that file the AI plugins stay unloaded.

local ok, cfg = pcall(require, "config.ai_local")
if not ok or type(cfg) ~= "table" then
  cfg = {}
end
local enabled = cfg.provider ~= nil

-- ── CodeCompanion: chat, inline edits, actions ──────────────────────────────
local function codecompanion_opts()
  if not enabled then
    return {}
  end

  local env = { url = cfg.url, api_key = cfg.api_key_env }
  if cfg.provider ~= "ollama" then
    env.api_key = cfg.api_key_env or "none" -- literal placeholder for keyless servers
    env.chat_url = cfg.chat_path -- nil keeps the default /v1/chat/completions
  end

  return {
    adapters = {
      http = {
        llm = function()
          return require("codecompanion.adapters").extend(cfg.provider, {
            formatted_name = cfg.label or "LLM",
            env = env,
            schema = { model = { default = cfg.chat_model } },
          })
        end,
      },
    },
    interactions = {
      chat = { adapter = "llm" },
      inline = { adapter = "llm" },
      cmd = { adapter = "llm" },
      background = { adapter = "llm" },
    },
  }
end

-- ── minuet: ghost-text completion ────────────────────────────────────────────
local function minuet_opts()
  if not enabled then
    return {}
  end

  -- Ollama speaks FIM (fill-in-the-middle). Other OpenAI-compatible servers
  -- default to chat-style completion; override with complete_style = "fim".
  local style = cfg.complete_style or (cfg.provider == "ollama" and "fim" or "chat")
  local fim = style == "fim"
  local api_key = cfg.api_key_env or "TERM" -- minuet wants the NAME of a non-empty env var
  local optional = vim.tbl_extend("force", { max_tokens = 56, top_p = 0.9 }, cfg.complete_optional or {})
  local model = cfg.complete_model or cfg.chat_model

  local provider_options = {}
  if fim then
    provider_options.openai_fim_compatible = {
      api_key = api_key,
      name = cfg.label or "LLM",
      end_point = cfg.url .. "/v1/completions",
      model = model,
      optional = optional,
    }
  else
    provider_options.openai_compatible = {
      api_key = api_key,
      name = cfg.label or "LLM",
      end_point = cfg.url .. (cfg.chat_path or "/v1/chat/completions"),
      model = model,
      optional = optional,
    }
  end

  return {
    provider = fim and "openai_fim_compatible" or "openai_compatible",
    provider_options = provider_options,
    n_completions = 1,
    context_window = cfg.complete_context or 1024, -- characters; raise once latency is known
    request_timeout = fim and 3 or 5,
    throttle = fim and 400 or 1500,
    debounce = fim and 150 or 600,
    notify = cfg.debug and "debug" or "warn",
    -- Auto-trigger only: skip prompt buffers and obviously sensitive files.
    -- Manual completion still works everywhere.
    enable_predicates = {
      function()
        if vim.bo.buftype ~= "" then
          return false
        end
        local name = vim.fn.expand("%:t"):lower()
        return not (
          name:match("^%.env")
          or name:match("secret")
          or name:match("credential")
          or name:match("%.pem$")
          or name:match("%.key$")
        )
      end,
    },
    virtualtext = {
      auto_trigger_ft = cfg.complete_auto and { "*" } or {},
      auto_trigger_ignore_ft = { "oil", "gitcommit", "markdown" },
      keymap = {
        accept = "<A-A>",
        accept_line = "<A-a>",
        accept_n_lines = "<A-z>",
        prev = "<A-[>",
        next = "<A-]>",
        dismiss = "<A-e>",
      },
    },
  }
end

return {
  {
    "olimorris/codecompanion.nvim",
    cond = enabled,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ic", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI: toggle chat" },
      { "<leader>ia", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "AI: actions" },
      { "<leader>ii", ":CodeCompanion ", mode = { "n", "x" }, desc = "AI: inline prompt" },
      { "<leader>is", ":CodeCompanionChat Add<cr>", mode = "x", desc = "AI: send selection to chat" },
    },
    opts = codecompanion_opts,
  },
  {
    "milanglacier/minuet-ai.nvim",
    cond = enabled,
    main = "minuet",
    event = "VeryLazy",
    opts = minuet_opts,
  },
}
