return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
  },
  keys = {
    -- Review-friendly shortcuts for AI-generated changes.
    -- `gdd` is the high-volume one (unstaged diff in a full-window view),
    -- `gdh` compares against HEAD for "what did AI do this commit",
    -- `gdH` is per-file history, and `gdq` closes the diffview tab.
    { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
    { "<leader>gdh", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diff vs HEAD" },
    { "<leader>gdH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>gdq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
  },
  cond = function()
    local git_cmd = "git"
    local target = {
      major = 2,
      minor = 31,
      patch = 0,
    }

    local version_string = vim.fn.system(git_cmd .. " --version")
    version_string = version_string:match "git version (%S+)"

    if not version_string then return false end

    local parts = vim.split(version_string, "%.")
    local v = {}
    v.major = tonumber(parts[1])
    v.minor = tonumber(parts[2])
    v.patch = tonumber(parts[3]) or 0

    if
      ("%08d%08d%08d"):format(v.major, v.minor, v.patch)
      < ("%08d%08d%08d"):format(target.major, target.minor, target.patch)
    then
      return false
    end
    return true
  end,
  config = function()
    require("diffview").setup {
      -- see configuration in
      -- https://github.com/sindrets/diffview.nvim#configuration
    }
  end,
}
