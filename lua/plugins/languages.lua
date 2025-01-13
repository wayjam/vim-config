return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "petobens/poet-v",
    ft = { "python" },
  },
  {
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
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      vim.api.nvim_create_user_command(
        "RenderMarkdownToggle",
        function(_) require("render-markdown").toggle() end,
        { nargs = 0 }
      )
    end,
  },
}
