local function config()
    require('lsp-status').config(
        {
            indicator_separator = ':',
            component_separator = '|',
            indicator_errors = 'E',
            indicator_warnings = 'W',
            indicator_info = 'I',
            indicator_hint = '!',
            indicator_ok = 'OK',
            status_symbol = 'LSP'
        })
    require('lualine').setup {
        options = {
            theme = 'onedark',
            component_separators = '',
            section_separators = '',
            disabled_filetypes = {"NvimTree"}
        },
        sections = {
            lualine_a = {{'mode', lower = false, color = {cterm = 'none', gui = 'none'}}},
            lualine_c = {"filename", "os.data('%a')", 'data', require'lsp-status'.status}
        }

    }
    vim.g.qf_disable_statusline = true
end

return {config = config}
