local function config()
  require("indent_blankline").setup {
    char = "▏",
    space_char_blankline = " ",
    show_end_of_line = true,
    show_current_context = true,
    show_current_context_start = true,
    use_treesitter = true,
    use_treesitter_scope = true,
    show_first_indent_level = true,
    show_current_context_start_on_current_line = false,
    show_trailing_blankline_indent = false,
    buftype_exclude = { "terminal", "nofile", "prompt" },
    filetype_exclude = {
      "help",
      "packer",
      "NvimTree",
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
    context_patterns = {
      "class",
      "function",
      "method",
      "block",
      "list_literal",
      "selector",
      "^if",
      "^table",
      "if_statement",
      "while",
      "for",
    },
  }
end

return {
  config = config,
}
