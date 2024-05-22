local function config() require("trouble").setup { use_diagnostic_signs = true } end

local function setup()
  local keymap = require("utils").keymap
  keymap("n", "<leader>xx", function() require("trouble").open() end)
  keymap("n", "<leader>xw", function() require("trouble").open "workspace_diagnostics" end)
  keymap("n", "<leader>xd", function() require("trouble").open "document_diagnostics" end)
  keymap("n", "<leader>xq", function() require("trouble").open "quickfix" end)
  keymap("n", "<leader>xl", function() require("trouble").open "loclist" end)
  keymap("n", "gr", function() require("trouble").open "lsp_references" end)
end

return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  dependencies = { "neovim/nvim-lspconfig" },
  init = setup,
  config = config,
}
