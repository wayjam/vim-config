local function onedark()
  require("onedark").setup {
    style = "dark",
    transparent = true,
    term_colors = true,
    diagnostics = {
      darker = true,
      undercurl = false,
    },
  }
  require("onedark").load()

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

return { config = function() onedark() end }
