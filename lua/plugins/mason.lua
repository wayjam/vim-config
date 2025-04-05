local config = function()
  local mason = require "mason"
  local mason_lspconfig = require "mason-lspconfig"

  mason.setup {
    ui = {
      border = "none",
      icons = {
        package_installed = "◍",
        package_pending = "◍",
        package_uninstalled = "◍",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }

  mason_lspconfig.setup {
    ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls" },
    automatic_installation = true,
    github = {
      -- https://github.com/fastgitorg/document
      download_url_template = "https://download.fastgit.org/%s/releases/download/%s/%s",
    },
  }

  require("mason-nvim-dap").setup {
    ensure_installed = {},
  }
end

return {
  "williamboman/mason.nvim",
  lazy = true,
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
    },
  },
  build = ":MasonUpdate",
  config = config,
}
