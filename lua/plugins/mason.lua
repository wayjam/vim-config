local config = function()
  require("mason").setup {
    ui = {
      border = "none",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }
end

return {
  "mason-org/mason.nvim",
  lazy = true,
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  build = ":MasonUpdate",
  config = config,
}
