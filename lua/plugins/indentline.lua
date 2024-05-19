local function config()
  require("ibl").setup {
    indent = {
      char = "▏",
      smart_indent_cap = true,
    },
    whitespace = {
      remove_blankline_trail = true,
    },
    exclude = {
      buftypes = { "terminal", "nofile" },
      filetypes = {
        "help",
        "lazy",
        "neo-tree",
        "Trouble",
        "ToggleTerm",
        "dashboard",
        "log",
        "fugitive",
        "gitcommit",
        "markdown",
        "json",
        "txt",
        "git",
        "TelescopePrompt",
      },
    },
  }
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  config = config,
}
