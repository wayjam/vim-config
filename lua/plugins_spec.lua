return {
  --- basic
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" },
  { "gpanders/editorconfig.nvim", event = "BufReadPre" },
  {
    "lunarvim/bigfile.nvim",
    config = function() require("bigfile").config {} end,
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },

  --- ui
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function() require("plugins.onedark").config() end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function() require("plugins.devicons").config() end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.lualine").config() end,
  },
  {
    "seblj/nvim-tabline",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.tabline").config() end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.gitsigns").config() end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    config = function() require("plugins.diffview").config() end,
    cond = function() return require("plugins.diffview").check_git_version() end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("plugins.indentline").config() end,
  },

  --- tools
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    dependencies = { "neovim/nvim-lspconfig" },
    init = function() require("plugins.trouble").setup() end,
    config = function() require("plugins.trouble").config() end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<localleader>e", "<cmd>Neotree reveal toggle<cr>", desc = "NeoTree" },
    },
    -- deactivate = function() vim.cmd [[Neotree close]] end,
    config = function() require("plugins.neotree").config() end,
  },
  {
    "tpope/vim-fugitive",
    event = "VimEnter",
    config = function() require("plugins.fugitive").config() end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        event = "BufRead",
        config = function() require("plugins.telescope").config_extension "fzf" end,
      },
      {
        "nvim-telescope/telescope-project.nvim",
        config = function() require("plugins.telescope").config_extension "project" end,
      },
    },
    init = function() require("plugins.telescope").setup() end,
    config = function() require("plugins.telescope").config() end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function() require("plugins.bqf").config() end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    config = function() require("plugins.symbols_outline").config() end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  --- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<localleader><tab>", desc = "ToggleTerm" },
    },
    config = function() require("plugins.toggleterm").config() end,
  },

  --- snippets
  { "rafamadriz/friendly-snippets" },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function() require("plugins.luasnip").config() end,
  },

  --- complete
  {
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
    },
    config = function() require("plugins.cmp").config() end,
  },

  --- installer
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    dependencies = {
      { "jayp0521/mason-nvim-dap.nvim", lazy = true },
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
      },
      {
        "jayp0521/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
      },
    },
    build = ":MasonUpdate",
    config = function() require("plugins.mason").config() end,
  },

  --- lsp
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.null-ls").config() end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "ray-x/lsp_signature.nvim", lazy = true },
      { "kosayoda/nvim-lightbulb", lazy = true },
    },
    config = function() require("plugins.lspconfig").config() end,
  },

  --- debugger
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    init = function() require("plugins.dap").setup() end,
    config = function() require("plugins.dap").config() end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function() require("plugins.dap").uiconfig() end,
  },

  --- editing
  { "tpope/vim-surround", event = "InsertCharPre" },
  {
    "windwp/nvim-autopairs",
    dependencies = "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function() require("plugins.autopairs").config() end,
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
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
    event = "BufReadPre",
    config = function() require("plugins.easy_align").config() end,
  },
  {
    "ggandor/leap.nvim",
    event = "BufReadPre",
    config = function() require("plugins.leap").config() end,
  },
  {
    "ojroques/nvim-osc52",
    event = "BufReadPre",
    config = function() require("plugins.oscyank").config() end,
  },
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZFocus", "TZMinimailist" },
    init = function() require("plugins.truezen").setup() end,
  },

  --- colorizer
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function() require("plugins.colorizer").config() end,
  },

  --- syntax
  {
    "nvim-treesitter/nvim-treesitter",
    -- event = { "BufReadPost", "BufNewFile" },
    event = "User FileOpened",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "VeryLazy",
        config = function() require("plugins.treesitter").commentstring() end,
      },
      {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        config = function() require("plugins.treesitter").autotag() end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        config = function() require("plugins.treesitter").textobjects() end,
      },
    },
    config = function() require("plugins.treesitter").config() end,
  },

  --- languages specifies
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "petobens/poet-v",
    ft = { "python" },
  },
}
