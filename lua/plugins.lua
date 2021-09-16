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
        requires = {'kyazdani42/nvim-web-devicons', "nvim-lua/lsp-status.nvim"},
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
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('plugins.gitsigns').config()
        end
    },

    --- formatting
    {
        "sbdchd/neoformat",
        cmd = {"Neoformat"},
        setup = function()
            vim.fn['plugins#source']('neoformat')
        end
    }, --- tools
    {
        "kyazdani42/nvim-tree.lua",
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require('plugins.nvimtree').config()
        end
    },
    {
        "tpope/vim-fugitive",
        event = "User InGitRepo",
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

    --- lsp
    {"kabouzeid/nvim-lspinstall"},
    {"kosayoda/nvim-lightbulb"},
    {"ray-x/lsp_signature.nvim"},
    {"hrsh7th/cmp-nvim-lsp"},
    {
        "neovim/nvim-lspconfig",
        requires = {"ray-x/lsp_signature.nvim", "hrsh7th/cmp-nvim-lsp"},
        config = function()
            require('plugins.lspconfig').config()
        end
    },

    --- snippets
    {"rafamadriz/friendly-snippets"},
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require('plugins.luasnip').config()
        end
    },

    --- complete
    {
        "hrsh7th/nvim-cmp",
        requires = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua"
        },
        config = function()
            require('plugins.complete').config()
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
        envnt = "FileType",
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
        config = function()
            vim.fn['plugins#config']('vim-sneak')
        end
    },
    {
        "ojroques/vim-oscyank",
        event = 'VimEnter',
        config = function()
            vim.fn['plugins#config']('oscyank')
        end
    },
    {
        "Pocco81/TrueZen.nvim",
        event = "VimEnter",
        setup = function()
            require('plugins.truezen').setup()
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
