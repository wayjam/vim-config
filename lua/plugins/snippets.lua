return {
  "L3MON4D3/LuaSnip",
  event = "VeryLazy",
  version = "v2.*",
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
    { "Saghen/blink.cmp", optional = true, opts = { snippets = { preset = "luasnip" } } },
  },
  config = function(_, opts)
    require("luasnip").config.setup(opts)
    vim.tbl_map(function(type)
      require("luasnip.loaders.from_" .. type).lazy_load()
      require("luasnip.loaders.from_" .. type).lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
    end, { "vscode", "snipmate", "lua" })
  end,
}
