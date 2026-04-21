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
    -- Smooth scrolling (replaces neoscroll.nvim)
    scroll = { enabled = true },
    -- Highlight word references under cursor (replaces vim-illuminate)
    words = { enabled = true },
    -- Disable features for large files (replaces lunarvim/bigfile.nvim)
    bigfile = { enabled = true },
    -- Inline image preview (requires external deps; see :help snacks-image)
    image = { enabled = true },
  },
  keys = {
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bD", function() require("snacks").bufdelete.other() end, desc = "Delete Other Buffers" },
    { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    -- Reference navigation (replaces <A-n>/<A-p> from vim-illuminate)
    { "<A-n>", function() require("snacks").words.jump(vim.v.count1, true) end, desc = "Next Reference" },
    { "<A-p>", function() require("snacks").words.jump(-vim.v.count1, true) end, desc = "Prev Reference" },
  },
}
