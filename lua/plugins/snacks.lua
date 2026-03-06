return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Smart buffer deletion: keeps window layout intact
    bufdelete = { enabled = true },
    -- Open current file/line in GitHub/GitLab/Gitea
    gitbrowse = { enabled = true },
    -- Toggle keymaps with status indicator in which-key
    toggle = { enabled = true },
    -- Faster file opening
    quickfile = { enabled = true },
  },
  keys = {
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bD", function() require("snacks").bufdelete.other() end, desc = "Delete Other Buffers" },
    { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
  },
}
