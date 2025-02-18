return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
    end,
  },
  config = function()
    require("luasnip.config").setup {
      history = true,
      delete_check_events = "TextChanged",
      -- updateevents = "TextChanged,TextChangedI",
      -- delete_check_events = "TextChanged,TextChangedI"
    }

    local opt = { silent = true }
    local keymap = require("utils").keymap
    keymap({ "i", "s" }, "<C-j>", function()
      if require("luasnip").expand_or_locally_jumpable() then luasnip.expand_or_jump() end
    end, opt)
    keymap({ "i", "s" }, "<C-k>", function()
      if require("luasnip").jumpable(-1) then luasnip.jump(-1) end
    end, opt)
  end,
}
