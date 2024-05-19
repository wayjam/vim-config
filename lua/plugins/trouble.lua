local function config() require("trouble").setup { use_diagnostic_signs = true } end

local function setup()
  vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
  vim.keymap.set("n", "<leader>xw", function() require("trouble").open "workspace_diagnostics" end)
  vim.keymap.set("n", "<leader>xd", function() require("trouble").open "document_diagnostics" end)
  vim.keymap.set("n", "<leader>xq", function() require("trouble").open "quickfix" end)
  vim.keymap.set("n", "<leader>xl", function() require("trouble").open "loclist" end)
  vim.keymap.set("n", "gr", function() require("trouble").open "lsp_references" end)
end

return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  dependencies = { "neovim/nvim-lspconfig" },
  init = setup,
  config = config,
}
