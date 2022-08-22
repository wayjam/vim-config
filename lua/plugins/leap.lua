return {
  config = function()
    require("leap").setup {
      case_sensitive = false,
      special_keys = {
        repeat_search = "<enter>",
        next_match = "<C-n>",
        prev_match = "<C-p>",
        next_group = "<C-b>",
        prev_group = "<C-f>",
      },
    }
    require("leap").set_default_keymaps()
  end,
}
