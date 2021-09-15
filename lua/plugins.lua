local utils = require("utils")
local fn = vim.fn

local packer_install_dir = vim.g['DATA_PATH'] ..
                               "/site/pack/packer/opt/packer.nvim"
local packer_compiled_path = vim.g['DATA_PATH'] .. "/packer_compiled.lua"
local packer_package_root = vim.g['DATA_PATH'] .. "/site/pack"

local plug_url_format = ""
if vim.g.is_linux then
    plug_url_format = "https://hub.fastgit.org/%s"
else
    plug_url_format = "https://github.com/%s"
end

local packer_repo = string.format(plug_url_format, "wbthomason/packer.nvim")
local install_cmd = string.format("10split |term git clone --depth=1 %s %s",
                                  packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if fn.glob(packer_install_dir) == "" then
    vim.api.nvim_echo({{"Installing packer.nvim", "Type"}}, true, {})
    vim.cmd(install_cmd)
end
vim.cmd("packadd packer.nvim")
local packer = require('packer')

local settings = {
    package_root = packer_package_root,
    compile_path = packer_compiled_path,
    git = {default_url_format = plug_url_format},
    display = {
        open_fn = function()
            return require("packer.util").float {border = "single"}
        end
    }
}

local function startup()
    vim.cmd([[
      augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
      augroup end
    ]])
    packer.startup({
        function(use)
            vim.cmd("source" .. vim.g['VIM_PATH'] ..
                        "/config/plugins/plugins.vim")

            --- basic
            use({"wbthomason/packer.nvim", opt = true})
            use({'christoomey/vim-tmux-navigator'})
            use({
                "tpope/vim-sleuth",
                event = "VimEnter",
                config = function()
                    vim.fn['plugins#config']('sleuth')
                end
            })

            use({"editorconfig/editorconfig-vim"})

            --- ui
            use({
                "navarasu/onedark.nvim",
                config = function() require('onedark').setup() end
            })
            use({
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require('plugins.treesitter').config()
                end
            })
            use({"kyazdani42/nvim-web-devicons"})
            use({
                'hoob3rt/lualine.nvim',
                event = "VimEnter",
                requires = {
                    'kyazdani42/nvim-web-devicons', "nvim-lua/lsp-status.nvim"
                },
                config = function()
                    require("plugins.lualine").config()
                end
            })
            use {
                'seblj/nvim-tabline',
                disable = false,
                requires = {'kyazdani42/nvim-web-devicons'},
                config = function()
                    require("plugins.tabline").config()
                end
            }
            use {
                'lewis6991/gitsigns.nvim',
                requires = {'nvim-lua/plenary.nvim'},
                config = function()
                    require('plugins.gitsigns').config()
                end
            }

            --- formatting
            use({
                "sbdchd/neoformat",
                cmd = {"Neoformat"},
                setup = function()
                    vim.fn['plugins#source']('neoformat')
                end
            })

            -- --- tools
            use({
                "kyazdani42/nvim-tree.lua",
                requires = {'kyazdani42/nvim-web-devicons'},
                config = function()
                    require('plugins.nvimtree').config()
                end
            })
            use({
                "tpope/vim-fugitive",
                event = "User InGitRepo",
                config = function()
                    vim.fn['plugins#config']('vim-fugitive')
                end
            })
            use({"nvim-lua/plenary.nvim"})
            use({
                "nvim-telescope/telescope.nvim",
                requires = {'nvim-lua/plenary.nvim'},
                setup = function()
                    require("plugins.telescope").setup()
                end,
                config = function()
                    require("plugins.telescope").config()
                end
            })

            --- lsp 
            use({"kabouzeid/nvim-lspinstall"})
            use({"kosayoda/nvim-lightbulb"})
            use({"ray-x/lsp_signature.nvim"})
            use({"hrsh7th/cmp-nvim-lsp"})
            use({
                "neovim/nvim-lspconfig",
                requires = {"ray-x/lsp_signature.nvim", "hrsh7th/cmp-nvim-lsp"},
                config = function()
                    require('plugins.lspconfig').config()
                end
            })

            -- --- snippets
            use({"rafamadriz/friendly-snippets"})
            use({
                "L3MON4D3/LuaSnip",
                config = function()
                    require('plugins.luasnip').config()
                end
            })
            -- use({
            --     "hrsh7th/vim-vsnip",
            --     setup = function() vim.fn['plugins#config']('vim-vsnip') end
            -- })

            --- complete
            use({
                "hrsh7th/nvim-cmp",
                requires = {
                    -- "hrsh7th/vim-vsnip", "hrsh7th/vim-vsnip-integ",
                    "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip",
                    "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lua"
                },
                config = function()
                    require('plugins.complete').config()
                end
            })

            --- editing
            use({"tpope/vim-surround", event = "InsertCharPre"})
            use({
                "windwp/nvim-autopairs",
                after = "nvim-cmp",
                event = "InsertCharPre",
                config = function()
                    require('nvim-autopairs').setup {}
                end
            })
            use({
                "itchyny/vim-cursorword",
                envnt = "FileType",
                config = function()
                    vim.fn['plugins#config']('vim-cursorword')
                end
            })
            use({
                "tpope/vim-commentary",
                cmd = "Commentary",
                event = "VimEnter",
                config = function()
                    vim.fn['plugins#config']('vim-commentary')
                end
            })
            use({
                "junegunn/vim-easy-align",
                cmd = "EasyAlign",
                event = "VimEnter",
                config = function()
                    vim.fn['plugins#config']('vim-easy-align')
                end
            })
            use({
                "justinmk/vim-sneak",
                event = "VimEnter",
                config = function()
                    vim.fn['plugins#config']('vim-sneak')
                end
            })
            use({
                "ojroques/vim-oscyank",
                event = 'VimEnter',
                config = function()
                    vim.fn['plugins#config']('oscyank')
                end
            })
            use({
                "Pocco81/TrueZen.nvim",
                event = "VimEnter",
                setup = function()
                    require('plugins.truezen').setup()
                end
            })

            --- languages specifies
            use({
                "fatih/vim-go",
                ft = {"go", "go.mod"},
                run = ":GoInstallBinaries",
                config = function()
                    vim.fn['plugins#config']('vim-go')
                end
            })
            use({
                "plasticboy/vim-markdown",
                ft = {"markdown", "pandoc.markdown", "rmc"},
                config = function()
                    vim.fn['plugins#config']('vim-markdown')
                end
            })
            use({
                "iamcco/markdown-preview.nvim",
                ft = {"markdown", "pandoc.markdown", "rmc"},
                cmd = 'MarkdownPreview',
                run = "cd app && yarn install"
            })
            use({
                "mattn/emmet-vim",
                ft = {
                    'html', "css", 'javascript', 'javascriptreact',
                    'typescript', 'typescriptreact', 'vue', 'svelte'
                },
                Event = "InsertEnter",
                config = function()
                    vim.fn['plugins#config']('emmet-vim')
                end
            })
            use({
                "pangloss/vim-javascript",
                ft = {
                    "typescript", "typescriptreact", "javascript",
                    "javascriptreact"
                },
                config = function()
                    vim.fn['plugins#config']('vim-javascript')
                end
            })
            use({
                "jeetsukumaran/vim-pythonsense",
                ft = {"python"},
                config = function() end
            })
            use({"petobens/poet-v", ft = {"python"}, config = function() end})
            use({"rust-lang/rust.vim", ft = {"rust"}})

        end,
        config = settings
    })
    packer.compile()
end

return {startup = startup}
