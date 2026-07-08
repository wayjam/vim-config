return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {},
  config = function(_, opts)
    require("codediff").setup(opts)

    -- <leader>q inside a codediff tab: close the whole diff tab in one shot.
    -- Why: codediff's default `q` can be intercepted by the explorer tree
    -- panel (nui.nvim) when the cursor is on a tree node, forcing a two-step
    -- "close explorer, then close diff" flow. <leader>q binds directly to
    -- tabclose on every buffer in the tab via CodeDiffOpen, so one press
    -- always returns to the original file view.
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeDiffOpen",
      callback = function()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local function close_tab()
          if vim.api.nvim_tabpage_is_valid(tabpage) then
            vim.cmd("tabclose")
          end
        end
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
          local buf = vim.api.nvim_win_get_buf(win)
          pcall(vim.keymap.set, "n", "<leader>q", close_tab, {
            buffer = buf,
            noremap = true,
            silent = true,
            nowait = true,
            desc = "Close codediff tab",
          })
        end
      end,
    })
  end,
}
