local function status()
    if #vim.lsp.buf_get_clients() > 0 then return require('lsp-status').status() end
    return ''
end

local function config()
    require('lualine').setup {
        options = {
            theme = 'onedark',
            component_separators = '',
            section_separators = '',
            disabled_filetypes = {"NvimTree"}
        },
        sections = {
            lualine_a = {{'mode', lower = false, color = {cterm = 'none', gui = 'none'}}},
            lualine_c = {"filename", "os.data('%a')", 'data', status}
        }

    }
    vim.g.qf_disable_statusline = true
end

return {config = config}
