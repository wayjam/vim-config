local function config()
    require('gitsigns').setup {
        signs = {
            add = {hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn'},
            change = {hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'},
            delete = {hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn'},
            topdelete = {hl = 'GitSignsDelete', text = '^', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'}
        },
        preview_config = {border = 'rounded'},
        update_debounce = 200,
        sign_priority = 6
    }
end

return {config = config}
