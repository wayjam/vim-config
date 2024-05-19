return {
  "lunarvim/bigfile.nvim",
  config = function() require("bigfile").config {} end,
  event = { "FileReadPre", "BufReadPre", "User FileOpened" },
}
