local function config()
  local icons = require("utils").icons

  require("gitsigns").setup {
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = icons["BoldLineMiddle"],
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = icons["BoldLineDashedMiddle"],
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = icons["ChevronRight"],
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsTopdelete",
        text = icons["ChevronRight"],
        numhl = "GitSignsTopdeleteNr",
        linehl = "GitSignsTopdeleteLn",
      },
      changedelete = {
        hl = "GitSignsChangedelete",
        text = icons["BoldLineMiddle"],
        numhl = "GitSignsChangedeleteNr",
        linehl = "GitSignsChangedeleteLn",
      },
      untracked = {
        hl = "GitSignsUntracked",
        text = icons["LineMiddle"],
        numhl = "GitSignsUntrackedNr",
        linehl = "GitSignsUntrackedLn",
      },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
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
end

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = config,
}
