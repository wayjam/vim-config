return {
  "saghen/blink.cmp",
  version = "*",
  event = {
    "InsertEnter",
  },
  dependencies = {
    "L3MON4D3/LuaSnip",
    {
      "olimorris/codecompanion.nvim",
      optional = true,
    },
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
    },
  },
  opts = {
    enabled = function()
      return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
    end,
    snippets = {
      preset = "luasnip",
    },
    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    cmdline = {
      enabled = false,
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
          kind_resolution = {
            blocked_filetypes = { "typescriptreact", "javascriptreact", "vue", "codecompanion" },
          },
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = false,
      },
    },

    -- experimental signature help support
    signature = { enabled = true },

    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      compat = {},
      default = { "lsp", "path", "snippets", "buffer" },
    },

    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
      ["<C-e>"] = { "show" },
      ["<S-CR>"] = { "hide" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-b>"] = { "scroll_documentation_up" },
    },
  },
  config = function(_, opts)
    local utils = require "utils"

    -- setup compat sources
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend(
        "force",
        { name = source, module = "blink.compat.source" },
        opts.sources.providers[source] or {}
      )
      if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then table.insert(enabled, source) end
    end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil
    opts.sources.providers = opts.sources.providers or {}

    if utils.has_plugin "codecompanion.nvim" then
      table.insert(opts.sources.compat or {}, "codecompanion")
      opts.sources.providers["codecompanion"] = {
        name = "CodeCompanion",
        module = "codecompanion.providers.completion.blink",
        enabled = true,
      }
    end

    -- check if we need to override symbol kinds
    for _, provider in pairs(opts.sources.providers or {}) do
      if provider.kind then
        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
        local kind_idx = #CompletionItemKind + 1

        CompletionItemKind[kind_idx] = provider.kind
        ---@diagnostic disable-next-line: no-unknown
        CompletionItemKind[provider.kind] = kind_idx

        local transform_items = provider.transform_items
        provider.transform_items = function(ctx, items)
          items = transform_items and transform_items(ctx, items) or items
          for _, item in ipairs(items) do
            item.kind = kind_idx or item.kind
          end
          return items
        end

        -- Unset custom prop to pass blink.cmp validation
        provider.kind = nil
      end
    end

    -- custom kind icon
    local icons = require("lsp.kind").icons
    opts.appearance.kind_icons = {}
    for key, icon in pairs(require("blink.cmp.config.appearance").default.kind_icons) do
      if icons[key] ~= nil then opts.appearance.kind_icons[key] = icons[key] end
    end

    require("blink.cmp").setup(opts)
  end,
}
