return {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 1000, -- Limit preloaded files for performance
        preloadFileSize = 150, -- Skip large files
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
