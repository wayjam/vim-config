return {
  "tpope/vim-fugitive",
  event = "VimEnter",
  config = function()
    -- Git mappings
    local keymap = require("utils").keymap
    keymap("n", "<Leader>gs", ":Git status<CR>", { silent = true })
    keymap("n", "<Leader>gd", ":Gdiff<CR>", { silent = true })
    keymap("n", "<Leader>gc", ":Git commit<CR>", { silent = true })
    keymap("n", "<Leader>gb", ":Git blame<CR>", { silent = true })
    keymap("n", "<Leader>gl", ":Git log<CR>", { silent = true })
    keymap("n", "<Leader>gp", ":Git push<CR>", { silent = true })
    keymap("n", "<Leader>gr", ":Gread<CR>", { silent = true })
    keymap("n", "<Leader>gw", ":Gwrite<CR>", { silent = true })
    keymap("n", "<Leader>ge", ":Gedit<CR>", { silent = true })
    keymap("n", "<Leader>gF", ":diffget //2<CR>", { silent = true })
    keymap("n", "<Leader>gJ", ":diffget //3<CR>", { silent = true })
    -- Mnemonic _i_nteractive
    keymap("n", "<leader>gi", ":Git add -p %<CR>", { silent = true })
  end,
}
