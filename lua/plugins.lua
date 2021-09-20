return {
    --- basic
    {"wbthomason/packer.nvim", opt = true},
    {'christoomey/vim-tmux-navigator'},
    {
        "tpope/vim-sleuth",
        event = "VimEnter",
        config = function()
            vim.fn['plugins#config']('sleuth')
        end
    },
    {"editorconfig/editorconfig-vim"},

    --- ui
    {
        "navarasu/onedark.nvim",
        config = function()
            require('onedark').setup()
            vim.g.onedark_diagnostics_undercurl = false
            vim.g.onedark_darker_diagnostics = false
            vim.g.onedark_transparent_background = true
            vim.g.onedark_disable_toggle_style = true
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require('plugins.treesitter').config()
        end
    },
    {"kyazdani42/nvim-web-devicons"},
    {
        'hoob3rt/lualine.nvim',
        event = 'VimEnter',
        requires = {'kyazdani42/nvim-web-devicons', "nvim-lua/lsp-status.nvim"},
        after = {'lsp-status.nvim'},
        config = function()
            require("plugins.lualine").config()
        end
    },
    {
        'seblj/nvim-tabline',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require("plugins.tabline").config()
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('plugins.gitsigns').config()
        end
    },
    {
        "folke/trouble.nvim",
        cmd = {"Trouble", "TroubleToggle"},
        after = {"nvim-lspconfig"},
        setup = function()
            require('plugins.trouble').setup()
        end,
        config = function()
            require('plugins.trouble').config()
        end
    },

    --- formatting
    {
        "sbdchd/neoformat",
        cmd = {"Neoformat"},
        setup = function()
            vim.fn['plugins#source']('neoformat')
        end
    },

    --- tools
    {
        "kyazdani42/nvim-tree.lua",
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require('plugins.nvimtree').config()
        end
    },
    {
        "tpope/vim-fugitive",
        event = "VimEnter",
        config = function()
            vim.fn['plugins#config']('vim-fugitive')
        end
    },
    {"nvim-lua/plenary.nvim"},
    {
        "nvim-telescope/telescope.nvim",
        requires = {'nvim-lua/plenary.nvim'},
        setup = function()
            require("plugins.telescope").setup()
        end,
        config = function()
            require("plugins.telescope").config()
        end
    },

    --- terminal
    {
        "akinsho/toggleterm.nvim",
        event = 'VimEnter',
        config = function()
            require('plugins.toggleterm').config()
        end
    },

    --- snippets
    {"rafamadriz/friendly-snippets"},
    {
        "L3MON4D3/LuaSnip",
        requires = {"rafamadriz/friendly-snippets"},
        config = function()
            require('plugins.luasnip').config()
        end
    },

    --- complete
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require('plugins.complete').config()
        end
    },
    {"saadparwaiz1/cmp_luasnip", after = {"nvim-cmp", "LuaSnip"}},
    {"hrsh7th/cmp-nvim-lsp", after = 'nvim-cmp'},
    {"hrsh7th/cmp-nvim-lua", after = 'nvim-cmp'},
    {"hrsh7th/cmp-buffer", after = 'nvim-cmp'},
    {"hrsh7th/cmp-path", after = 'nvim-cmp'},

    --- lsp
    {"ray-x/lsp_signature.nvim"},
    {"kabouzeid/nvim-lspinstall"},
    {"kosayoda/nvim-lightbulb"},
    {"nvim-lua/lsp-status.nvim"},
    {
        "neovim/nvim-lspconfig",
        event = 'VimEnter',
        after = {"cmp-nvim-lsp", 'nvim-lspinstall', 'lsp_signature.nvim', 'nvim-lightbulb', 'lsp-status.nvim'},
        config = function()
            require('plugins.lspconfig').config()
        end
    },

    --- editing
    {"tpope/vim-surround", event = "InsertCharPre"},
    {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        event = "InsertCharPre",
        config = function()
            require('nvim-autopairs').setup {}
        end
    },
    {
        "itchyny/vim-cursorword",
        envnt = "InsertCharPre",
        config = function()
            vim.fn['plugins#config']('vim-cursorword')
        end
    },
    {
        "tpope/vim-commentary",
        cmd = "Commentary",
        event = "VimEnter",
        config = function()
            vim.fn['plugins#config']('vim-commentary')
        end
    },
    {
        "junegunn/vim-easy-align",
        cmd = "EasyAlign",
        event = "VimEnter",
        config = function()
            vim.fn['plugins#config']('vim-easy-align')
        end
    },
    {
        "justinmk/vim-sneak",
        event = "VimEnter",
        setup = function()
            vim.fn['plugins#config']('vim-sneak-setup')
        end,
        config = function()
            vim.fn['plugins#config']('vim-sneak')
        end
    },
    {
        "ojroques/vim-oscyank",
        cmd = {"OSCYank", "OSCYankReg"},
        setup = function()
            vim.fn['plugins#config']('vim-oscyank')
        end
    },
    {
        "Pocco81/TrueZen.nvim",
        cmd = {"TZAtaraxis", "TZFocus", "TZMinimailist"},
        setup = function()
            require('plugins.truezen').setup()
        end
    },

    --- colorizer
    {
        "norcalli/nvim-colorizer.lua",
        event = "VimEnter",
        after = "nvim-treesitter",
        config = function()
            require('plugins.colorizer').config()
        end
    },

    --- languages specifies
    {
        "fatih/vim-go",
        ft = {"go", "go.mod"},
        run = ":GoInstallBinaries",
        config = function()
            vim.fn['plugins#config']('vim-go')
        end
    },
    {
        "plasticboy/vim-markdown",
        ft = {"markdown", "pandoc.markdown", "rmc"},
        config = function()
            vim.fn['plugins#config']('vim-markdown')
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = {"markdown", "pandoc.markdown", "rmc"},
        cmd = 'MarkdownPreview',
        run = "cd app && yarn install"
    },
    {
        "mattn/emmet-vim",
        ft = {'html', "css", 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte'},
        Event = "InsertEnter",
        config = function()
            vim.fn['plugins#config']('emmet-vim')
        end
    },
    {
        "pangloss/vim-javascript",
        ft = {"typescript", "typescriptreact", "javascript", "javascriptreact"},
        config = function()
            vim.fn['plugins#config']('vim-javascript')
        end
    },
    {
        "jeetsukumaran/vim-pythonsense",
        ft = {"python"},
        config = function()
        end
    },
    {
        "petobens/poet-v",
        ft = {"python"},
        config = function()
        end
    },
    {"rust-lang/rust.vim", ft = {"rust"}}
}
