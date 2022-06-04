local function setup()
end

local function config()
    require("nvim-treesitter.configs").setup(
        {
            ensure_installed = "all", -- all or a list of names
            ignore_install = {}, -- List of parsers to ignore installing
            highlight = {
                enable = true, -- false will disable the whole extension
                disable = {} -- list of language that will be disabled
            },
            highlight = {enable = true},
            indent = {enable = true},
            autotag = {enable = true},
            autopairs = {enable = true},
            refactor = {highlight_definitions = {enable = true}, highlight_current_scope = {enable = true}}
        })
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
end

local function textobjects()
    require("nvim-treesitter.configs").setup(
        {
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner"
                    }
                },
                swap = {enable = false}
            }
        })
end

return {setup = setup, config = config, textobjects = textobjects}
