local function config()
  require("onedark").setup {
    style = "dark",
    transparent = false,
    term_colors = true,
    diagnostics = {
      darker = false,
      undercurl = false,
    },
  }
  require("onedark").load()

  -- fix pmenu background color
  local colors = require "onedark.colors"
  vim.cmd("au VimEnter * highlight Pmenu guibg=" .. colors.bg0)
end

return { config = config }
