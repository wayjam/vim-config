local function config()
    require("trouble").setup {use_lsp_diagnostic_signs = true}
end

local function setup()
    vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
end

return {setup = setup, config = config}
