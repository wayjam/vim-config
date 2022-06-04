local function config()
    require("trouble").setup {use_diagnostic_signs = true}
end

local function setup()
    vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap(
        "n", "<leader>ew", "<cmd>Trouble lsp_workspace_diagnostics<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap(
        "n", "<leader>ed", "<cmd>Trouble lsp_document_diagnostics<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", {silent = true, noremap = true})
    vim.api.nvim_set_keymap("n", "gr", "<cmd>Trouble lsp_references<cr>", {silent = true, noremap = true})
end

return {setup = setup, config = config}
