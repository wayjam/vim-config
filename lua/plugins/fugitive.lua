return {
  config = function()
    -- Git mappings
    vim.api.nvim_set_keymap("n", "<Leader>gs", ":Git status<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gd", ":Gdiff<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gc", ":Git commit<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gb", ":Git blame<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gl", ":Git log<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gp", ":Git push<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gr", ":Gread<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gw", ":Gwrite<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>ge", ":Gedit<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gF", ":diffget //2<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<Leader>gJ", ":diffget //3<CR>", { silent = true })
    -- Mnemonic _i_nteractive
    vim.api.nvim_set_keymap("n", "<leader>gi", ":Git add -p %<CR>", { silent = true })
  end,
}
