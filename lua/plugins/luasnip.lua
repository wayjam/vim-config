local luasnip = require "luasnip"

local function config()
  require("luasnip.config").setup {
    history = true,
    -- updateevents = "TextChanged,TextChangedI",
    -- delete_check_events = "TextChanged,TextChangedI"
  }

  require("luasnip.loaders.from_vscode").lazy_load {}
  local opt = { silent = true }
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
  end, opt)
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if luasnip.jumpable(-1) then luasnip.jump(-1) end
  end, opt)
end

return { config = config }
