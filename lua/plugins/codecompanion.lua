local getenv = require("utils").getenv_with_default

local function get_provider_opts(name)
  local prefix = "NVIM_AI_" .. string.upper(name) .. "_"
  return {
    name = name,
    enabled = getenv(prefix .. "ENABLED", "false") == "true",
    url = getenv(prefix .. "URL", ""),
    key = getenv(prefix .. "KEY", ""),
    chat_endpoint = getenv(prefix .. "CHAT_ENDPOINT", "/v1/chat/completions"),
    models_endpoint = getenv(prefix .. "MODELS_ENDPOINT", "/v1/models"),
    default_model = getenv(prefix .. "DEFAULT_MODEL", ""),
    is_default = getenv(prefix .. "IS_DEFAULT", "false"),
  }
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>ac",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion actions",
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion chat",
      },
      {
        "<leader>ad",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        noremap = true,
        silent = true,
        desc = "CodeCompanion add to chat",
      },
    },
    opts = {
      adapters = { acp = {}, http = {} },
      display = {
        chat = {
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            height = 0.8,
            width = 0.6,
          },
        },
      },
      interactions = {
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
        chat = {
          adapter = "copilot",
          roles = {
            llm = "CodeCompanion",
            user = "Me",
          },
          keymaps = {
            send = {
              modes = { n = "<CR>", i = "<C-CR>" },
            },
            close = {
              modes = { n = "q" },
            },
            stop = {
              modes = { n = "<C-c>" },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local getenv = require("utils").getenv_with_default
      local default_provider = "ollama"

      if getenv("NVIM_AI_OLLAMA_ENABLED", "false") == "true" then
        opts.adapters.http["ollama"] = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = getenv("NVIM_AI_OLLAMA_URL", "http://127.0.0.1:11434"),
              api_key = getenv("NVIM_AI_OLLAMA_KEY", ""),
            },
          })
        end
      end

      local private_provider = get_provider_opts "private_provider"
      if private_provider.enabled then
        default_provider = "private_provider"
        opts.adapters.http[private_provider.name] = function()
          local args = {
            env = {
              url = private_provider.url,
              api_key = private_provider.key,
              chat_url = private_provider.chat_endpoint,
              models_endpoint = private_provider.models_endpoint,
            },
          }
          if private_provider.default_model ~= "" and private_provider.default_model ~= nil then
            args["schema"] = {
              model = {
                default = private_provider.default_model,
              },
            }
          end
          return require("codecompanion.adapters").extend("openai_compatible", args)
        end
      end

      opts.interactions.chat.adapter = default_provider

      -- ACP providers (e.g. claude_code, gemini_cli)
      -- Env: NVIM_AI_ACP_<NAME>_ENABLED, NVIM_AI_ACP_<NAME>_MODEL, NVIM_AI_ACP_<NAME>_IS_DEFAULT
      local acp_names_raw = getenv("NVIM_AI_ACP_PROVIDERS", "")
      if acp_names_raw ~= "" then
        for name in acp_names_raw:gmatch("[^,]+") do
          name = name:match("^%s*(.-)%s*$") -- trim whitespace
          local prefix = "NVIM_AI_ACP_" .. string.upper(name) .. "_"
          local enabled = getenv(prefix .. "ENABLED", "false") == "true"
          if enabled then
            local model = getenv(prefix .. "MODEL", "")
            local is_default = getenv(prefix .. "IS_DEFAULT", "false") == "true"
            opts.adapters.acp[name] = function()
              local args = {}
              if model ~= "" then
                args["defaults"] = { model = model }
              end
              return require("codecompanion.adapters").extend(name, args)
            end
            if is_default then
              opts.interactions.chat.adapter = name
              opts.interactions.inline.adapter = name
              opts.interactions.cmd.adapter = name
            end
          end
        end
      end

      local ok, customize = pcall(require, "customize.codecompanion")
      if ok then customize.config(_, opts) end

      require("codecompanion").setup(opts)

      vim.cmd [[cab cc CodeCompanion]]
    end,
  },
}
