return {
  "Pocco81/TrueZen.nvim",
  cmd = { "TZAtaraxis", "TZFocus", "TZMinimailist" },
  init = function()
    require("utils").keymap("n", "<leader>Z", [[<Cmd>TZAtaraxis<CR>]], { noremap = true, silent = true })
  end,
}
