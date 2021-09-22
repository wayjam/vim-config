local function config()
    require('nvim-autopairs').setup(
        {check_ts = true, enable_check_bracket_line = true, disable_filetype = {"TelescopePrompt"}})

    require("nvim-autopairs.completion.cmp").setup(
        {
            map_cr = true, --  map <CR> on insert mode
            map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
            auto_select = true, -- automatically select the first item
            insert = false, -- use insert confirm behavior instead of replace
            map_char = { -- modifies the function or method delimiter by filetypes
                all = '(',
                tex = '{'
            }
        })

end

return {config = config}
