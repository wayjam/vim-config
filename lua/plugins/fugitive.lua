return {
  "tpope/vim-fugitive",
  event = "VimEnter",
  config = function()
    -- Git mappings
    local keymap = require("utils").keymap
    -- keymap("n", "<Leader>Gs", ":Git status<CR>", { silent = true })
    keymap("n", "<Leader>Gd", ":Gdiff<CR>", { silent = true })
    keymap("n", "<Leader>GC", ":Git commit<CR>", { silent = true })
    keymap("n", "<Leader>Gb", ":Git blame<CR>", { silent = true })
    keymap("n", "<Leader>Gl", ":Git log<CR>", { silent = true })
    keymap("n", "<Leader>Gp", ":Git push<CR>", { silent = true })
    -- keymap("n", "<Leader>gr", ":Gread<CR>", { silent = true })
    -- keymap("n", "<Leader>gw", ":Gwrite<CR>", { silent = true })
    -- keymap("n", "<Leader>ge", ":Gedit<CR>", { silent = true })
    keymap("n", "<Leader>GF", ":diffget //2<CR>", { silent = true })
    keymap("n", "<Leader>GJ", ":diffget //3<CR>", { silent = true })
    -- Mnemonic _i_nteractive
    keymap("x", "<leader>Gi", ":Git add -p %<CR>", { silent = true })
  end,
}
