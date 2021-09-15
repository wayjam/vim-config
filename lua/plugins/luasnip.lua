local luasnip = require "luasnip"

local function jump(dir) if luasnip.jumpable(dir) then luasnip.jump(dir) end end

local function expand_or_jump()
    if luasnip.expand_or_jumpable() then return luasnip.expand_or_jump() end
end

local function config()
    require("luasnip.config").setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged,TextChangedI"
    }

    require("luasnip.loaders.from_vscode").load {}

    local opt = {noremap = true, silent = true}
    vim.api.nvim_set_keymap("i", "<C-j>",
                            [[<Cmd>lua require('plugins.luasnip').expand_or_jump() <CR>]],
                            opt)
    vim.api.nvim_set_keymap("i", "<C-k>",
                            [[<Cmd>lua require('plugins.luasnip').jump(-1) <CR>]],
                            opt)
    vim.api.nvim_set_keymap("s", "<C-j>",
                            [[<Cmd>lua require('plugins.luasnip').jump(1) <CR>]],
                            opt)
    vim.api.nvim_set_keymap("s", "<C-k>",
                            [[<Cmd>lua require('plugins.luasnip').jump(-1) <CR>]],
                            opt)

end

return {config = config, jump = jump, expand_or_jump = expand_or_jump}
