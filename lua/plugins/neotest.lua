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
  init = function()
    local neotest = require "neotest"
    local keymaps = {
      { "n", "<leader>tt", function() neotest.run.run() end, "Run Nearest Test" },
      { "n", "<leader>tf", function() neotest.run.run(vim.fn.expand "%") end, "Run File Test" },
      { "n", "<leader>td", function() neotest.run.run { strategy = "dap" } end, "Debug Test" },
      { "n", "<leader>ts", function() neotest.run.stop() end, "Stop Test" },
      { "n", "<leader>ta", function() neotest.run.attach() end, "Attach Test" },
      { "n", "<leader>to", function() neotest.output.open { enter = true } end, "Open Test Output" },
      { "n", "<leader>tO", function() require("neotest").output_panel.open() end, "Open Test Output Panel" },
      { "n", "<leader>tS", function() require("neotest").summary.toggle() end, "Toggle Test Summary" },
    }

    for _, item in ipairs(keymaps) do
      local mode, lhs, rhs, desc = unpack(item)
      require("utils").keymap(mode, lhs, rhs, {
        desc = desc,
      })
    end
  end,
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
