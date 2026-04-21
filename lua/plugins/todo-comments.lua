return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "]T", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[T", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },
    { "<leader>st", "<cmd>TodoFzfLua<cr>", desc = "Todo (FzfLua)" },
    { "<leader>sT", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
  },
}
