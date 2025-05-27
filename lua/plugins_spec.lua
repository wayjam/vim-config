local SpecFile = require("utils").SpecFile
local Spec = require("utils").Spec

-- basic
Spec { "christoomey/vim-tmux-navigator", event = "VeryLazy" }
Spec { "gpanders/editorconfig.nvim", event = "BufReadPre" }
Spec { "tpope/vim-surround", event = "InsertCharPre" }

SpecFile "plugins.bigfile"

-- UI
SpecFile "plugins.colorscheme"
SpecFile "plugins.devicons"
SpecFile "plugins.lualine"
SpecFile "plugins.tabby"
SpecFile "plugins.noice"
SpecFile "plugins.indentline"

-- git
SpecFile "plugins.fugitive"
SpecFile "plugins.gitsigns"
SpecFile "plugins.diffview"

-- tool
SpecFile "plugins.trouble"
SpecFile "plugins.neotree"
SpecFile "plugins.outline"
SpecFile "plugins.toggleterm"
SpecFile "plugins.illuminate"

-- picker
SpecFile "plugins.fzf"

-- snippets
SpecFile "plugins.snippets"

-- complete
SpecFile "plugins.blink"

-- test
SpecFile "plugins.neotest"

-- mason
SpecFile "plugins.mason"

-- AI
SpecFile "plugins.codecompanion"

-- lsp
SpecFile "plugins.lspconfig"

-- format & lint
SpecFile "plugins.nvim-lint"
SpecFile "plugins.conform"

-- tool
SpecFile "plugins.which_key"
SpecFile "plugins.autopairs"
SpecFile "plugins.comment"
SpecFile "plugins.easy_align"
SpecFile "plugins.flash"
SpecFile "plugins.zenmode"

-- debugger
SpecFile "plugins.dap"

-- syntax
SpecFile "plugins.treesitter"

-- language specify
SpecFile "plugins.languages"
SpecFile "plugins.markdown"
SpecFile "plugins.colorizer"

return LAZY_PLUGIN_SPEC
