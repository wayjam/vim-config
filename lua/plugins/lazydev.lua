return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
  specs = {
    -- Add lazydev as a blink.cmp source
    {
      "saghen/blink.cmp",
      optional = true,
      opts = {
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100, -- show at top
            },
          },
        },
      },
    },
  },
  dependencies = {
    { "Bilal2453/luvit-meta", lazy = true },
  },
}
