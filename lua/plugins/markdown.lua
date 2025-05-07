return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
    completions = { lsp = { enabled = true } },
  },
  ft = { "markdown", "norg", "rmd", "org", "Avante", "codecompanion" },
  config = function(_, opts)
    if require("utils").has_plugin "blink.cmp" then opts.completions = { blink = { enabled = true } } end

    require("render-markdown").setup(opts)

    vim.api.nvim_create_user_command(
      "RenderMarkdownToggle",
      function(_) require("render-markdown").toggle() end,
      { nargs = 0 }
    )
  end,
}
