local lazypath = vim.g["DATA_PATH"] .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local function startup()
  -- load lazy
  require("lazy").setup {
    spec = {
      { import = "plugins_spec" },
    },
    -- install = { colorscheme = { require("plugins.colorscheme").name } },
    defaults = { lazy = true },
    ui = { wrap = "true" },
    checker = { enabled = true },
    change_detection = { enabled = true },
    debug = false,
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip", -- Plugin for editing compressed files.
          -- "matchit", -- What is it?
          --  "matchparen", -- Plugin for showing matching parens
          "netrwPlugin", -- Handles file transfers and remote directory listing across a network
          "tarPlugin", -- Plugin for browsing tar files
          "tohtml", -- Converting a syntax highlighted file to HTML
          "tutor", -- Teaching?
          "zipPlugin", -- Handles browsing zipfiles
        },
      },
    },
  }
end

return { startup = startup }
