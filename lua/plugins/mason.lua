local function try_require_null_ls(source_name)
  local types = { "formatting", "diagnostics" }
  local ok = false
  local source = nil
  for _, t in ipairs(types) do
    ok, source = pcall(require, string.format("null-ls.builtins.%s.%s", t, source_name))
    if ok then break end
  end
  return ok, source
end

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

  require("mason-null-ls").setup {
    ensure_installed = { "stylua" },
    automatic_setup = true,
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
    { "jayp0521/mason-nvim-dap.nvim", lazy = true },
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
    },
    {
      "jayp0521/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
    },
  },
  build = ":MasonUpdate",
  config = config,
}
