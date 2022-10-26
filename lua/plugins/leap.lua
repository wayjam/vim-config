return {
  config = function()
    local leap = require "leap"
    leap.setup {
      case_sensitive = false,
      special_keys = {
        repeat_search = "<enter>",
        next_phase_one_target = "<enter>",
        next_target = { "<C-n>", ";" },
        prev_target = { "<C-p>", "," },
        next_group = "<C-b>",
        prev_group = "<C-f>",
        multi_accept = "<enter>",
        multi_revert = "<backspace>",
      },
    }
    leap.add_default_mappings()
  end,
}
