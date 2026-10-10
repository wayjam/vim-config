return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- v3 spec format: replaces the old `register` API.
    spec = {
      { "<leader>a", group = "AI" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>e", group = "diagnostic" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunk" },
      { "<leader>G", group = "Git" },
      { "<leader>l", group = "last" },
      { "<leader>r", group = "rename/resume" },
      { "<leader>t", group = "toggle/test" },
      -- venv group only shows when venv-selector is usable (fd exists)
      {
        "<leader>v",
        group = "venv",
        cond = function()
          return vim.fn.executable("fd") == 1
            or vim.fn.executable("fdfind") == 1
            or vim.fn.executable("fd_find") == 1
        end,
      },
      { "<leader>w", group = "workspace/save" },
      { "<leader>x", group = "trouble" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "z", group = "fold" },
    },
  },
  keys = {
    {
      "<leader>sh",
      function() require("which-key").show { global = false } end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<leader>sH",
      function() require("which-key").show { global = true } end,
      desc = "All Keymaps (which-key)",
    },
  },
}
