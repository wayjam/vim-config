local settings = {
  Lua = {
    runtime = {
      version = "LuaJIT",
      path = vim.fn.split(package.path, ";"),
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
}

local function config(server_config)
  server_config.settings = settings
  return server_config
end

return {
  config = config,
}
