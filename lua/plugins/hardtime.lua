return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  -- enable = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    -- Warn/restrict after N consecutive uses of the same restricted key.
    -- Defaults to 3; 10 is a gentle nudge that still lets you survive.
    max_count = 10,
    -- Keep hjkl under default restriction (that's hardtime's whole point).
    -- Add arrow keys to the restriction list so they're ALSO capped at 10.
    restricted_keys = {
      ["<Up>"] = { "n", "x" },
      ["<Down>"] = { "n", "x" },
      ["<Left>"] = { "n", "x" },
      ["<Right>"] = { "n", "x" },
    },
  },
}
