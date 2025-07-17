return {
  "nvim-neotest/neotest",
  cmd = { "Neotest" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- general tests
    "nvim-neotest/neotest-vim-test",
    -- language specific tests
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-go",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, mode = { "n" }, desc = "Run Nearest Test" },
    {
      "<leader>tf",
      function() require("neotest").run.run(vim.fn.expand "%") end,
      mode = { "n" },
      desc = "Run File Test",
    },
    {
      "<leader>td",
      function() require("neotest").run.run { strategy = "dap" } end,
      mode = { "n" },
      desc = "Debug Test",
    },
    { "<leader>ts", function() require("neotest").run.stop() end, mode = { "n" }, desc = "Stop Test" },
    { "<leader>ta", function() require("neotest").run.attach() end, mode = { "n" }, desc = "Attach Test" },
    {
      "<leader>to",
      function() require("neotest").output.open { enter = true } end,
      mode = { "n" },
      desc = "Open Test Output",
    },
    {
      "<leader>tO",
      function() require("neotest").output_panel.toggle() end,
      mode = { "n" },
      desc = "Open Test Output Panel",
    },
    { "<leader>tS", function() require("neotest").summary.toggle() end, mode = { "n" }, desc = "Toggle Test Summary" },
    {
      "<leader>tC",
      function() require("neotest").output_panel.clear() end,
      mode = { "n" },
      desc = "Clear Test Output Panel",
    },
  },
  config = function()
    local neotest = require "neotest"

    neotest.setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
        },
        require "neotest-go",
        require "neotest-vitest",
        require "neotest-rust",
        require "neotest-vim-test" {
          ignore_file_types = { "python", "vim", "lua", "javascript", "typescript" },
        },
      },
    }
  end,
}
