local luasnip = require "luasnip"

local function jump(dir)
  if luasnip.jumpable(dir) then
    luasnip.jump(dir)
  end
end

local function expand_or_jump()
  if luasnip.expand_or_jumpable() then
    return luasnip.expand_or_jump()
  end
end

local function config()
  require("luasnip.config").setup {
    history = true,
    -- updateevents = "TextChanged,TextChangedI",
    -- delete_check_events = "TextChanged,TextChangedI"
  }

  require("luasnip.loaders.from_vscode").lazy_load {}

  local opt = { silent = true }
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    expand_or_jump()
  end, opt)
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    jump(-1)
  end, opt)
end

return { config = config, jump = jump, expand_or_jump = expand_or_jump }
