return {
  "lunarvim/bigfile.nvim",
  event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  config = function() require("bigfile").config {} end,
}
