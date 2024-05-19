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
    vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, opts)
    -- Test File
    vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand "%") end, opts)
    -- Debug Test
    vim.keymap.set("n", "<leader>td", function() neotest.run.run { strategy = "dap" } end, opts)
    --- Test Stop
    vim.keymap.set("n", "<leader>ts", function() neotest.run.stop() end, opts)
    -- Attach Test
    vim.keymap.set("n", "<leader>ta", function() neotest.run.attach() end, opts)
    -- Output
    vim.keymap.set("n", "<leader>to", function() neotest.output.open { enter = true } end, opts)
    -- Output Panel
    vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.open() end, opts)
    vim.keymap.set("n", "<leadaer>tS", function() require("neotest").summary.toggle() end, opts)
  end,
}
