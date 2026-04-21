return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      -- Pick whichever picker is installed; venv-selector supports both.
      { "ibhagwan/fzf-lua", optional = true },
      { "nvim-telescope/telescope.nvim", optional = true },
      { "mfussenegger/nvim-dap", optional = true },
      { "mfussenegger/nvim-dap-python", optional = true },
    },
    ft = "python",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
    opts = {
      -- Let the plugin auto-detect poetry / uv / venv / conda layouts.
      -- Customize via :h venv-selector if needed.
    },
  },
}
