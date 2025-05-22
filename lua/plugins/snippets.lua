return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  lazy = true,
  dependencies = {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  opts = {
    history = true,
    delete_check_events = "TextChanged",
    region_check_events = "CursorMoved",
  },
  specs = {
    {
      "Saghen/blink.cmp",
      optional = true,
      opts = {
        snippets = {
          preset = "luasnip",
        },
        sources = {
          providers = {
            snippets = {
              should_show_items = function(ctx) return ctx.trigger.initial_kind ~= "trigger_character" end,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("luasnip").config.setup(opts)
    vim.tbl_map(function(type)
      require("luasnip.loaders.from_" .. type).lazy_load()
      require("luasnip.loaders.from_" .. type).lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
    end, { "vscode", "snipmate", "lua" })
  end,
}
