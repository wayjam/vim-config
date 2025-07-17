local getenv = require("utils").getenv_with_default

local function get_provider_opts(name)
  local prefix = "AI_" .. string.upper(name) .. "_"
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
      adapters = {},
      display = {
        chat = {
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            height = 0.8,
            width = 0.6,
          },
        },
      },
      strategies = {
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
              modes = {
                n = "q",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
      },
    },
    config = function(_, opts)
      local getenv = require("utils").getenv_with_default
      local default_provider = "ollama"

      if getenv("AI_OLLAMA_ENABLED", "false") == "true" then
        opts.adapters["ollama"] = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = getenv("AI_OLLAMA_URL", "http://127.0.0.1:11434"),
              api_key = getenv("AI_OLLAMA_KEY", ""),
            },
          })
        end
      end

      local private_provider = get_provider_opts "private_provider"
      if private_provider.enabled then
        default_provider = "private_provider"
        opts.adapters[private_provider.name] = function()
          local args = {
            env = {
              url = private_provider.url,
              api_key = private_provider.key,
              chat_url = private_provider.chat_endpoint,
              models_endpoint = private_provider.models_endpoint,
            },
          }
          if private_provider.default_model ~= "" or private_provider.default_model ~= nil then
            args["schema"] = {
              model = {
                default = private_provider.default_model, -- define llm model to be used
              },
            }
          end
          return require("codecompanion.adapters").extend("openai_compatible", args)
        end
      end

      opts.strategies.chat.adapter = default_provider

      local ok, customize = pcall(require, "customize.codecompanion")
      if ok then customize.config(_, opts) end

      require("codecompanion").setup(opts)

      vim.cmd [[cab cc CodeCompanion]]
    end,
  },
}
