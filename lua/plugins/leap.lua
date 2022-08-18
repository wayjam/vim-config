return {
  config = function()
    require("leap").setup {
      case_sensitive = false,
      special_keys = {
        repeat_search = "<enter>",
        next_match = "<enter>",
        prev_match = "<tab>",
        next_group = "<C-n>",
        prev_group = "<C-p>",
      },
    }
    require("leap").set_default_keymaps()
  end,
}
