local function config()
  local keymap = require("utils").keymap
  local comment = require "Comment"
  comment.setup {
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }

  keymap("n", "<Leader>//", "<Plug>(comment_toggle_linewise_current)")
  keymap("x", "<Leader>//", "<Plug>(comment_toggle_linewise_visual)<CR>")
end

return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  config = config,
}
