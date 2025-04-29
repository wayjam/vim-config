return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  config = function()
    local comment = require "Comment"
    comment.setup {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }

    local keymap = require("utils").keymap
    keymap("n", "<Leader>//", "<Plug>(comment_toggle_linewise_current)")
    keymap("x", "<Leader>//", "<Plug>(comment_toggle_linewise_visual)<CR>")
  end,
}
