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
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local keymap = require("utils").keymap

        -- Navigation
        keymap("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { desc = "Next Hunk", buffer = bufnr, expr = true })

        keymap("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { desc = "Prev Hunk", buffer = bufnr, expr = true })

        -- Stage / reset
        keymap("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk", buffer = bufnr })
        keymap("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk", buffer = bufnr })
        keymap("v", "<leader>ghs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, { desc = "Stage Hunk", buffer = bufnr })
        keymap("v", "<leader>ghr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, { desc = "Reset Hunk", buffer = bufnr })
        keymap("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer", buffer = bufnr })
        keymap("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer", buffer = bufnr })
        keymap("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk", buffer = bufnr })

        -- Preview / diff
        keymap("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk", buffer = bufnr })
        keymap("n", "<leader>ghd", gs.diffthis, { desc = "Diff This", buffer = bufnr })

        -- Inline diff toggle: flips line-highlight + word-diff together so the
        -- current buffer paints AI-inserted lines in-place (no split window).
        -- Handy for a quick "what did the agent change here" glance without
        -- reaching for diffview.
        keymap("n", "<leader>gdi", function()
          gs.toggle_linehl()
          gs.toggle_word_diff()
        end, { desc = "Toggle inline diff", buffer = bufnr })

        -- Text object
        keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk", buffer = bufnr })
      end,
      update_debounce = 100, -- 100ms feels snappier when reviewing AI-generated hunks
      max_file_length = 40000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }

    -- local keymap = require("utils").keymap
    -- for _, item in ipairs {
    --   { "n", "<leader>Gb", "<cmd>Gitsigns blame<CR>", "Git blame" },
    --   { "n", "<leader>Gd", "<cmd>Gitsigns diffthis<CR>", "Git Diffthis" },
    -- } do
    --   local mode, lhs, rhs, desc = unpack(item)
    --   keymap(mode, lhs, rhs, {
    --     desc = desc,
    --     noremap = true,
    --     silent = true,
    --   })
    -- end
  end,
}
