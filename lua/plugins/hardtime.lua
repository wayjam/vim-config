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
    -- Navigational UIs where hjkl restriction is counterproductive.
    -- Each entry is merged with hardtime's built-in defaults; patterns
    -- using Lua pattern matching (% . - etc.) are supported.
    disabled_filetypes = {
      -- CodeDiff: Explorer and History windows
      ["codediff%-.*"] = true,
      -- Toggleterm: terminal buffers
      ["toggleterm"] = true,
      -- Snacks: picker (list/input/preview), terminal, notification history
      ["snacks_picker.*"] = true,
      ["snacks_terminal"] = true,
      ["snacks_notif.*"] = true,
      -- fzf-lua: file/content picker
      ["fzf.*"] = true,
      -- Outline: sidebar symbol navigator
      ["Outline"] = true,
      -- neotest: all panels (summary, output, output-panel, attach)
      -- (defaults only cover neotest-summary)
      ["neotest%-.*"] = true,
      -- CodeCompanion: AI chat buffers
      ["codecompanion.*"] = true,
    },
  },
}
