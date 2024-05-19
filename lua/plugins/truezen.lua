local function setup()
  vim.api.nvim_set_keymap("n", "<leader>Z", [[<Cmd>TZAtaraxis<CR>]], { noremap = true, silent = true })
end

return {
  "Pocco81/TrueZen.nvim",
  cmd = { "TZAtaraxis", "TZFocus", "TZMinimailist" },
  init = setup,
}
