local function config()
  local comment = require "Comment"
  comment.setup {
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }

  vim.keymap.set("n", "<Leader>//", "<Plug>(comment_toggle_linewise_current)")
  vim.keymap.set("x", "<Leader>//", "<Plug>(comment_toggle_linewise_visual)<CR>")
end

return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  config = config,
}
