return {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        -- `library` is intentionally omitted: lazydev.nvim manages Lua library
        -- paths on demand (see lua/plugins/lazydev.lua). Adding a static
        -- `nvim_get_runtime_file("", true)` here defeats the whole point of
        -- lazy loading and doubles the LSP startup cost.
      },
      hint = {
        enable = true, -- necessary
      },
      telemetry = {
        enable = false, -- Disable telemetry
      },
      diagnostics = {
        enable = true,
        globals = {
          "vim",
          "use",
          "describe",
          "it",
          "assert",
          "before_each",
          "after_each",
        },
      },
    },
  },
}
