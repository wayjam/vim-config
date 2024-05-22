return {
  "junegunn/vim-easy-align",
  cmd = "EasyAlign",
  event = "BufReadPre",
  config = function()
    local keymap = require("utils").keymap
    -- Start interactive EasyAlign in visual mode (e.g. vipga)
    keymap("x", "ga", "<Plug>(EasyAlign)", {})
    --  Start interactive EasyAlign for a motion/text object (e.g. gaip)
    keymap("n", "ga", "<Plug>(EasyAlign)", {})
  end,
}
