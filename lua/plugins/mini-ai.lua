return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  version = "*",
  opts = function()
    local ai = require "mini.ai"
    return {
      n_lines = 500,
      custom_textobjects = {
        -- function definition (treesitter)
        f = ai.gen_spec.treesitter {
          a = "@function.outer",
          i = "@function.inner",
        },
        -- class definition (treesitter)
        c = ai.gen_spec.treesitter {
          a = "@class.outer",
          i = "@class.inner",
        },
      },
    }
  end,
}
