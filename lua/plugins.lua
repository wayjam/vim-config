return {
  --- basic
  { "wbthomason/packer.nvim", opt = true },
  {
    "lewis6991/impatient.nvim",
    config = function() require "impatient" end,
  },
  { "nathom/filetype.nvim" },
  { "christoomey/vim-tmux-navigator" },
  {
    "tpope/vim-sleuth",
    event = "VimEnter",
    config = function() vim.fn["plugins#config"] "sleuth" end,
  },
  { "gpanders/editorconfig.nvim" },

  --- ui
  {
    "navarasu/onedark.nvim",
    config = function() require("plugins.onedark").config() end,
  },
  { "kyazdani42/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/lsp-status.nvim" },
    after = { "lsp-status.nvim" },
    config = function() require("plugins.lualine").config() end,
  },
  {
    "seblj/nvim-tabline",
    event = "UIEnter",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function() require("plugins.tabline").config() end,
  },
  { "folke/lsp-colors.nvim" },
  {
    "lewis6991/gitsigns.nvim",
    event = "VimEnter",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.gitsigns").config() end,
  },
  {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    config = function() require("plugins.diffview").config() end,
    cond = function() return require("plugins.diffview").check_git_version() end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function() require("plugins.indentline").config() end,
  },

  --- tools
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    after = { "nvim-lspconfig" },
    setup = function() require("plugins.trouble").setup() end,
    config = function() require("plugins.trouble").config() end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function() require("plugins.nvimtree").config() end,
  },
  {
    "ahmedkhalf/project.nvim",
    after = { "telescope.nvim" },
    config = function() require("plugins.project").config() end,
  },
  {
    "tpope/vim-fugitive",
    event = "VimEnter",
    config = function() vim.fn["plugins#config"] "vim-fugitive" end,
  },
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
    setup = function() require("plugins.telescope").setup() end,
    config = function() require("plugins.telescope").config() end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    config = function() require("plugins.symbols_outline").config() end,
  },

  --- terminal
  {
    "akinsho/toggleterm.nvim",
    tag = "*",
    cmd = "ToggleTerm",
    config = function() require("plugins.toggleterm").config() end,
  },

  --- snippets
  { "rafamadriz/friendly-snippets" },
  {
    "L3MON4D3/LuaSnip",
    requires = { "rafamadriz/friendly-snippets" },
    config = function() require("plugins.luasnip").config() end,
  },

  --- complete
  {
    "hrsh7th/nvim-cmp",
    config = function() require("plugins.cmp").config() end,
  },
  { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
  { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
  { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
  { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
  { "hrsh7th/cmp-path", after = "nvim-cmp" },

  --- installer
  { "jayp0521/mason-null-ls.nvim" },
  { "jayp0521/mason-nvim-dap.nvim" },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "williamboman/mason.nvim",
    after = { "mason-lspconfig.nvim", "mason-null-ls.nvim" },
    config = function() require("plugins.mason").config() end,
  },

  --- lsp
  { "ray-x/lsp_signature.nvim" },
  { "kosayoda/nvim-lightbulb" },
  { "nvim-lua/lsp-status.nvim" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    after = "mason.nvim",
    config = function() require("plugins.null-ls").config() end,
  },
  {
    "neovim/nvim-lspconfig",
    after = {
      "cmp-nvim-lsp",
      "mason-lspconfig.nvim",
      "lsp_signature.nvim",
      "nvim-lightbulb",
      "lsp-status.nvim",
    },
    config = function() require("plugins.lspconfig").config() end,
  },

  --- debugger
  {
    "mfussenegger/nvim-dap",
    event = "VimEnter",
    setup = function() require("plugins.dap").setup() end,
    config = function() require("plugins.dap").config() end,
  },
  {
    "rcarriga/nvim-dap-ui",
    requires = "nvim-dap",
    after = "nvim-dap",
    config = function() require("plugins.dap").uiconfig() end,
  },

  --- editing
  { "tpope/vim-surround", event = "InsertCharPre" },
  {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    event = "VimEnter",
    config = function() require("plugins.autopairs").config() end,
  },
  {
    "RRethy/vim-illuminate",
    config = function() require("plugins.illuminate").config() end,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function() require("plugins.comment").config() end,
  },
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    event = "VimEnter",
    config = function() vim.fn["plugins#config"] "vim-easy-align" end,
  },
  {
    "ggandor/leap.nvim",
    event = "VimEnter",
    config = function() require("plugins.leap").config() end,
  },
  {
    "ojroques/nvim-osc52",
    config = function() require("plugins.oscyank").config() end,
  },
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZFocus", "TZMinimailist" },
    setup = function() require("plugins.truezen").setup() end,
  },

  --- colorizer
  {
    "norcalli/nvim-colorizer.lua",
    event = "VimEnter",
    config = function() require("plugins.colorizer").config() end,
  },

  --- syntax
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function() require("plugins.treesitter").config() end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function() require("plugins.treesitter").commentstring() end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function() require("plugins.treesitter").autotag() end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function() require("plugins.treesitter").textobjects() end,
  },

  --- languages specifies
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmc" },
    cmd = "MarkdownPreview",
    run = "cd app && yarn install",
  },
  {
    "petobens/poet-v",
    ft = { "python" },
  },
}
