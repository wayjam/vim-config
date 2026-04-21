-- Active colorscheme: onedark. Kept as a single return for simplicity.
-- Add alternatives as new files if you want to swap (lazy will only load
-- what is imported).
return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local theme = require "onedark"
    theme.setup {
      style = "dark",
      transparent = true,
      term_colors = true,
      diagnostics = {
        darker = true,
        undercurl = false,
        background = true,
      },
    }
    theme.load()
  end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "onedark",
        },
      },
    },
  },
}
