local function check_backspace()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local function config()
  local luasnip = require "luasnip"
  local icons = require("lsp.kind").icons
  local cmp = require "cmp"

  cmp.setup {
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = icons[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
          emoji = "[Emoji]",
        })[entry.source.name]
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For luasnip
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = { hl_group = "Comment" },
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "nvim-lua" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "nvim_lsp_signature_help" },
      { name = "buffer" },
      { name = "path" },
    },
    mapping = {
      ["<C-y>"] = cmp.config.disable,
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<A-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
  }

  local file_type_specify = {
    help = false,
    lazy = false,
    ["neo-tree"] = false,
    ["neo-tree-popup"] = { "buffer", "path" },
    Trouble = false,
    ToggleTerm = { "path", "buffer" },
    dashboard = false,
    log = false,
    fugitive = { "git", "buffer" },
    git = { "git", "buffer" },
    gitcommit = { "git", "buffer" },
    TelescopePrompt = false,
  }

  for k, v in pairs(file_type_specify) do
    if v == false then
      cmp.setup.filetype(k, {
        enabled = false,
      })
    else
      local sources = {}
      for _, s in ipairs(v) do
        table.insert(sources, { name = s })
      end
      cmp.setup.filetype(k, {
        sources = cmp.config.sources(sources),
      })
    end
  end

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

return {
  "hrsh7th/nvim-cmp",
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  dependencies = {
    "L3MON4D3/LuaSnip",
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    {
      "hrsh7th/cmp-cmdline",
    },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
  },
  config = config,
}
