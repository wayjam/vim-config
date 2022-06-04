local function config()
    require("tabline").setup({padding = 1, separator = "", close_icon = "", show_index = true, right_separator = false})
end

return {config = config}
