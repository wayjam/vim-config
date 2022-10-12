local function config() require("trouble").setup { use_diagnostic_signs = true } end

local function setup()
  vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xw",
    "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xd",
    "<cmd>TroubleToggle lsp_document_diagnostics<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
end

return { setup = setup, config = config }
