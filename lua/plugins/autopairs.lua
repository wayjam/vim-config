local function config()
    local npairs = require("nvim-autopairs")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')

    npairs.setup({check_ts = true, enable_check_bracket_line = true, disable_filetype = {"TelescopePrompt"}})
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())
end

return {config = config}
