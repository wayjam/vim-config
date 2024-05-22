local function config()
  local luasnip = require "luasnip"
  require("luasnip.config").setup {
    history = true,
    -- updateevents = "TextChanged,TextChangedI",
    -- delete_check_events = "TextChanged,TextChangedI"
  }

  require("luasnip.loaders.from_vscode").lazy_load {}
  local opt = { silent = true }
  local keymap = require("utils").keymap
  keymap({ "i", "s" }, "<C-j>", function()
    if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
  end, opt)
  keymap({ "i", "s" }, "<C-k>", function()
    if luasnip.jumpable(-1) then luasnip.jump(-1) end
  end, opt)
end

return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = config,
}
