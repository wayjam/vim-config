local function config()
    require("toggleterm").setup {shade_terminals = false, open_mapping = [[<localleader><tab>]]}
end

return {config = config}
