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

local kanagawa = {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    "xiyaowong/transparent.nvim",
    config = function() require("transparent").setup() end,
  },
  config = function() vim.cmd "colorscheme kanagawa" end,
}

local arcticColor = {
  pink = "#c586c0",
  red = "#c72e0f",
  orange = "#cc6633",
  green = "#16825d",
  blue = "#007acc",
  violet = "#646695",
  purple = "#68217a",
  white = "#ffffff",
  lightgray = "#454545",
  gray = "#252526",
}

local arctic = {
  "rockyzhang24/arctic.nvim",
  dependencies = {
    "rktjmp/lush.nvim",
    {
      "xiyaowong/transparent.nvim",
      config = function() require("transparent").setup {} end,
    },
  },
  name = "arctic",
  branch = "v2",
  priority = 1000,
  lazy = false,
  config = function() vim.cmd "colorscheme arctic" end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = {
            normal = {
              a = { fg = arcticColor.white, bg = arcticColor.blue },
              b = { fg = arcticColor.white, bg = arcticColor.lightgray },
              c = { fg = arcticColor.white, bg = arcticColor.gray },
            },
            insert = {
              a = { fg = arcticColor.white, bg = arcticColor.orange },
            },
            visual = {
              a = { fg = arcticColor.white, bg = arcticColor.purple },
            },
            replace = {
              a = { fg = arcticColor.white, bg = arcticColor.pink },
            },
            command = {
              a = { fg = arcticColor.white, bg = arcticColor.green },
            },
            terminal = {
              a = { fg = arcticColor.white, bg = arcticColor.violet },
            },
            pending = {
              a = { fg = arcticColor.white, bg = arcticColor.red },
            },
            inactive = {
              a = { fg = arcticColor.white, bg = arcticColor.gray },
            },
          },
        },
      },
    },
  },
}

return arctic
