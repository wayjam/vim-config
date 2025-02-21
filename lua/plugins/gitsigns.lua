return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local icons = require("utils").icons

    require("gitsigns").setup {
      signs = {
        add = {
          text = icons["BoldLineMiddle"],
        },
        change = {
          text = icons["BoldLineDashedMiddle"],
        },
        delete = {
          text = icons["ChevronRight"],
        },
        topdelete = {
          text = icons["ChevronRight"],
        },
        changedelete = {
          text = icons["BoldLineMiddle"],
        },
        untracked = {
          text = icons["LineMiddle"],
        },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }

    local keymap = require("utils").keymap

    for _, item in ipairs {
      { "n", "<leader>Gb", "<cmd>Gitsigns blame<CR>",    "Git blame" },
      { "n", "<leader>Gd", "<cmd>Gitsigns diffthis<CR>", "Git Diffthis" },
    } do
      local mode, lhs, rhs, desc = unpack(item)
      keymap(mode, lhs, rhs, {
        desc = desc,
        noremap = true,
        silent = true,
      })
    end
  end,
  on_attach = function(bufnr) end,
}
