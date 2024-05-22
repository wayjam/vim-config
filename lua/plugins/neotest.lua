return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
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
  config = function()
    local keymap = require("utils").keymap
    local neotest = require "neotest"

    neotest.setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
        },
        require "neotest-go",
        require "neotest-vitest",
        require "neotest-vim-test" {
          ignore_file_types = { "python", "vim", "lua", "javascript", "typescript" },
        },
      },
    }
    local opts = {
      expr = true,
    }

    -- Test Nearest
    keymap("n", "<leader>tt", function() neotest.run.run() end, opts)
    -- Test File
    keymap("n", "<leader>tf", function() neotest.run.run(vim.fn.expand "%") end, opts)
    -- Debug Test
    keymap("n", "<leader>td", function() neotest.run.run { strategy = "dap" } end, opts)
    --- Test Stop
    keymap("n", "<leader>ts", function() neotest.run.stop() end, opts)
    -- Attach Test
    keymap("n", "<leader>ta", function() neotest.run.attach() end, opts)
    -- Output
    keymap("n", "<leader>to", function() neotest.output.open { enter = true } end, opts)
    -- Output Panel
    keymap("n", "<leader>tO", function() require("neotest").output_panel.open() end, opts)
    keymap("n", "<leadaer>tS", function() require("neotest").summary.toggle() end, opts)
  end,
}
