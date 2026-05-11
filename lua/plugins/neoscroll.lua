return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {
    mappings = {},
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    -- "linear" easing handles direction changes better than quadratic
    -- (no acceleration curve to "fight against" when reversing)
    easing = "linear",
    performance_mode = true,
  },
  config = function(_, opts)
    local neoscroll = require "neoscroll"
    neoscroll.setup(opts)

    local keymap = {
      -- Very short duration: reduces the window where a direction reversal feels janky
      ["<C-u>"] = function() neoscroll.ctrl_u { duration = 50 } end,
      ["<C-d>"] = function() neoscroll.ctrl_d { duration = 50 } end,
      ["<C-b>"] = function() neoscroll.ctrl_b { duration = 80 } end,
      ["<C-f>"] = function() neoscroll.ctrl_f { duration = 80 } end,
      ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 30 }) end,
      ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 30 }) end,
      ["zt"] = function() neoscroll.zt { half_win_duration = 30 } end,
      ["zz"] = function() neoscroll.zz { half_win_duration = 30 } end,
      ["zb"] = function() neoscroll.zb { half_win_duration = 30 } end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func, { silent = true })
    end
  end,
}
