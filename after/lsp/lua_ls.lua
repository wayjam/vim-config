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
        enable = true,
      },
      telemetry = {
        enable = false,
      },
      diagnostics = {
        -- Neovim-specific globals. `vim` type info comes from lazydev.nvim at
        -- runtime; listing it here just suppresses undefined-global on files
        -- that lazydev hasn't attached to yet.
        globals = { "vim" },
        -- Ignore busted test globals project-wide. If you only use busted in
        -- specific dirs, consider a per-project .luarc.json there instead.
        -- globals = { "vim", "describe", "it", "assert", "before_each", "after_each" },
        libraryFiles = "Open",
        groupSeverity = {
          strong = "Warning",
          strict = "Warning",
        },
        unusedLocalExclude = { "_*" },
      },
    },
  },
}
