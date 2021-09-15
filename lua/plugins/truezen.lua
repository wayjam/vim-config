local function setup()
    vim.api.nvim_set_keymap("n", "<leader>Z", [[<Cmd>TZAtaraxis<CR>]], {noremap = true, silent = true})
end

return {setup = setup}
