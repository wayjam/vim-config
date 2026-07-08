-- Kept as a single return for simplicity.
-- Add alternatives as new files if you want to swap (lazy will only load
-- what is imported).

local onedark = {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local theme = require "onedark"
    theme.setup {
      style = "cool",
      transparent = true,
      term_colors = true,
      diagnostics = {
        darker = true,
        undercurl = false,
        background = true,
      },
    }
    theme.load()
  end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "onedark",
        },
      },
    },
  },
}

local onedarkpro = {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedarkpro").setup {
      options = {
        transparency = true,
        terminal_colors = true,
        cursorline = true,
        lualine_transparency = true,
      },
      styles = {
        comments = "italic",
        virtual_text = "NONE",
      },
      plugins = {
        all = true,
      },
    }
    vim.cmd.colorscheme "onedark"
  end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "onedark",
        },
      },
    },
  },
}

local edge = {
  "sainnhe/edge",
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.edge_enable_italic = true
    vim.g.edge_style = "default"
    vim.g.edge_transparent_background = 1
    vim.g.edge_current_word = "high contrast background"
    vim.cmd.colorscheme "edge"

    -- edge's Directory group (#A0B5D0) reads greenish on some terminals.
    -- Force neo-tree folder name + icon to a stable blue. Re-apply on
    -- ColorScheme events because switching themes clears custom highlights.
    local function apply_neotree_dir_hl()
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#61afef" })
    end
    apply_neotree_dir_hl()
    local grp = vim.api.nvim_create_augroup("edge.neotree_hl", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = grp,
      callback = apply_neotree_dir_hl,
    })
  end,
  specs = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        options = {
          theme = "edge",
        },
      },
    },
  },
}

return onedark
