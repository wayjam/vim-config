return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  -- enable = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    -- max_count = 10,
    restricted_keys = {
      ["h"] = {},
      ["j"] = {},
      ["k"] = {},
      ["l"] = {},
    },
    disabled_keys = {
      ["<Up>"] = false,
      ["<Down>"] = false,
      ["<Left>"] = false,
      ["<Right>"] = false,
    },
  },
}
