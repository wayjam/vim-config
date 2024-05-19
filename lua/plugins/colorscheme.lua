local function onedark()
  local theme = require "onedark"
  theme.setup {
    style = "dark",
    transparent = true,
    term_colors = true,
    diagnostics = {
      darker = true,
      undercurl = false,
    },
  }
  theme.load()

  -- fix pmenu background color
  -- vim.cmd("au VimEnter * highlight Pmenu guibg=" .. colors.bg0)
end

local function onedarkpro()
  local colors = require("onedarkpro.helpers").get_colors()
  require("onedarkpro").setup {
    highlights = {
      NeoTreeDirectoryIcon = { fg = colors.blue },
    },
  }
  vim.cmd "colorscheme onedark"
end

local function nord() vim.cmd [[colorscheme nord]] end

return {
  "navarasu/onedark.nvim",
  -- "olimorris/onedarkpro.nvim",
  -- "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function() onedark() end,
}
