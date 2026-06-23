-- Kept as a single return for simplicity.
-- Add alternatives as new files if you want to swap (lazy will only load
-- what is imported).

local onedark = {
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

local edge = {
  "sainnhe/edge",
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.edge_enable_italic = true
    vim.g.edge_style = "default"
    vim.g.edge_transparent_background = 1
    vim.g.edge_current_word = "high contrast background"
    vim.cmd.colorscheme "edge"
  end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "edge",
        },
      },
    },
  },
}

return edge
