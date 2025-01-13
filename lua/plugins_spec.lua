LAZY_PLUGIN_SPEC = {
  -- basic
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" },
  { "gpanders/editorconfig.nvim",     event = "BufReadPre" },
  { "tpope/vim-surround",             event = "InsertCharPre" },
}

function Spec(item)
  if type(item) == "table" then
    for _, value in pairs(item) do
      table.insert(LAZY_PLUGIN_SPEC, { import = value })
    end
  else
    table.insert(LAZY_PLUGIN_SPEC, { import = item })
  end
end

Spec "plugins.bigfile"

-- UI
Spec "plugins.colorscheme"
Spec "plugins.devicons"
Spec "plugins.lualine"
Spec "plugins.tabby"
Spec "plugins.gitsigns"
Spec "plugins.diffview"
Spec "plugins.indentline"

-- tool
Spec "plugins.trouble"
Spec "plugins.neotree"
Spec "plugins.fugitive"
Spec "plugins.telescope"
Spec "plugins.bqf"
Spec "plugins.outline"
Spec "plugins.toggleterm"
Spec "plugins.illuminate"

-- snippets
Spec "plugins.snippets"

-- complete
-- Spec "plugins.cmp"
Spec "plugins.blink"

-- test
Spec "plugins.neotest"

-- mason
Spec "plugins.mason"

-- lsp
Spec "plugins.lspconfig"
Spec "plugins.null-ls"

-- tool
Spec "plugins.which_key"
Spec "plugins.autopairs"
Spec "plugins.comment"
Spec "plugins.easy_align"
Spec "plugins.flash"
Spec "plugins.truezen"

-- debugger
Spec "plugins.dap"

-- syntax
Spec "plugins.treesitter"

-- language specify
Spec "plugins.languages"

return LAZY_PLUGIN_SPEC
