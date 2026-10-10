local ft = {
  "css",
  "javascript",
  "lua",
  "vim",
  "toml",
  "svelte",
  "typescript",
  "tmux",
  "stylus",
  "sass",
  "scss",
  "html",
  "javascriptreact",
  "typescriptreact",
}

return {
  "catgoose/nvim-colorizer.lua",
  ft = ft,
  opts = {
    filetypes = ft,
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue oe blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      -- Available modes: foreground, background, virtualtext
      mode = "background", -- Set the display mode.)
    },
  },
}
