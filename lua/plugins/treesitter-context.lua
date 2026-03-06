return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    max_lines = 3,
    min_window_height = 20,
    trim_scope = "outer",
  },
  keys = {
    {
      "[C",
      function() require("treesitter-context").go_to_context(vim.v.count1) end,
      desc = "Jump to context (upward)",
    },
  },
}
