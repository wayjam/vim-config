local function setup() end

local function config()
    require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained', -- all, maintained, or list of languages
        highlight = {enable = true},
        -- incremental_selection = {
        -- 	enable = true,
        -- 	keymaps = {
        -- 		init_selection = 'gnn',
        -- 		node_incremental = 'grn',
        -- 		scope_incremental = 'grc',
        -- 		node_decremental = 'grm',
        -- 	},
        -- },
        indent = {enable = true},
        autotag = {enable = false},
        textobjects = {
            swap = {
                enable = false
                -- swap_next = textobj_swap_keymaps,
            },
            -- move = textobj_move_keymaps,
            select = {
                enable = false
                -- keymaps = textobj_sel_keymaps,
            }
        },
        refactor = {
            highlight_definitions = {enable = true},
            highlight_current_scope = {enable = true}
        }
    })
    vim.api.nvim_set_option('foldmethod', "expr")
    vim.api.nvim_set_option('foldexpr', "nvim_treesitter#foldexpr()")
end

return {setup = setup, config = config}
