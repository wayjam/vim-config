local SpecFile = require("utils").SpecFile
local Spec = require("utils").Spec

-- basic
-- vim-tmux-navigator provides <C-h/j/k/l> that crosses nvim <-> tmux pane
-- boundaries. Keep its mappings (don't override in keymaps.lua).
Spec { "christoomey/vim-tmux-navigator", event = "VeryLazy" }

SpecFile "plugins.surround"
SpecFile "plugins.hardtime"

-- UI
SpecFile "plugins.colorscheme"
SpecFile "plugins.devicons"
SpecFile "plugins.lualine"
SpecFile "plugins.tabby"
SpecFile "plugins.noice"
SpecFile "plugins.indentline"
SpecFile "plugins.ufo"

-- git
SpecFile "plugins.fugitive"
SpecFile "plugins.gitsigns"
SpecFile "plugins.diffview"

-- tool
SpecFile "plugins.trouble"
SpecFile "plugins.neotree"
SpecFile "plugins.outline"
SpecFile "plugins.toggleterm"
SpecFile "plugins.snacks"

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
SpecFile "plugins.lazydev"

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
SpecFile "plugins.mini-ai"
SpecFile "plugins.todo-comments"

-- debugger
SpecFile "plugins.dap"

-- syntax
SpecFile "plugins.treesitter"
SpecFile "plugins.treesitter-context"

-- language specify
SpecFile "plugins.languages"
SpecFile "plugins.markdown"
SpecFile "plugins.colorizer"

return LAZY_PLUGIN_SPEC
