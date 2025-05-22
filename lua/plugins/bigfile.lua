return {
  "lunarvim/bigfile.nvim",
  event = { "FileReadPre", "BufReadPre" },
  config = function() require("bigfile").config {} end,
}
