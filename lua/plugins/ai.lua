local prefix = "<Leader>a"

---@diagnostic disable-next-line: unused-local
local function generate_slash_commands()
  local commands = {}
  local picker = "telescope"
  for _, command in ipairs { "buffer", "file", "help", "symbols" } do
    commands[command] = {
      opts = {
        provider = picker, -- dynamically resolve the provider
      },
    }
  end
  return commands
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    opts = {
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:11434",    -- optional: default value is ollama url http://127.0.0.1:11434
              -- api_key = "",                      -- optional: if your endpoint is authenticated
              chat_url = "/v1/chat/completions", -- optional: default value, override if different
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "ollama",
          roles = {
            llm = "CodeCompanion",
            user = "Me",
          },
          slash_commands = generate_slash_commands(),
          keymaps = {
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
      inline = {
        adapter = "ollama",
      },
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
  },
}
