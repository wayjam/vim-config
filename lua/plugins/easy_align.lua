return {
  "junegunn/vim-easy-align",
  cmd = "EasyAlign",
  keys = {
    -- Start interactive EasyAlign in visual mode (e.g. vipga)
    -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
    { "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, desc = "Start interactive EasyAlign" },
  },
}
