local function setup()
    vim.g.onedark_diagnostics_undercurl = false
    vim.g.onedark_darker_diagnostics = false
    vim.g.onedark_disable_toggle_style = true
    require("onedark").setup()
    local colors = require("onedark.colors")
    vim.cmd("au VimEnter * highlight Pmenu guibg=" .. colors.bg0)
end

return {setup = setup}
