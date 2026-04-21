-- Neovim 0.10+ has built-in `gc` / `gcc` / `gb` / `gbc` comment operators.
-- `ts-comments.nvim` tweaks `commentstring` via treesitter for languages
-- where the builtin heuristic falls short (TSX/JSX/Vue/Svelte, embedded HTML…).
return {
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
  init = function()
    local keymap = require("utils").keymap
    -- Keep legacy <Leader>// toggle mapped to the builtin gc operator.
    keymap("n", "<Leader>//", "gcc", { remap = true, desc = "Toggle comment line" })
    keymap("x", "<Leader>//", "gc", { remap = true, desc = "Toggle comment" })
  end,
}
