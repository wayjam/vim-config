return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  cmd = {
    "TSInstall",
    "TSUninstall",
    "TSUpdate",
    "TSInstallFromGrammar",
    "TSLog",
  },
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      lazy = true,
      config = function()
        require("nvim-ts-autotag").setup {
          opts = {
            -- Defaults
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = false, -- Auto close on trailing </
          },
          -- Also override individual filetype configs, these take priority.
          -- Empty by default, useful if one of the "opts" global settings
          -- doesn't work well in a specific filetype
          per_filetype = {
            -- ["html"] = {
            --   enable_close = false,
            -- },
            -- ["javascript"],
            -- ["javascriptreact"],
            -- ["typescriptreact"],
            -- ["svelte"],
            -- ["vue"],
          },
        }
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      lazy = true,
      config = function()
        require("nvim-treesitter-textobjects").setup {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
          },
          move = {
            enable = true,
          },
        }

        -- Text objects: select
        vim.keymap.set({ "x", "o" }, "af", function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end, { desc = "Select around function" })
        vim.keymap.set({ "x", "o" }, "if", function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end, { desc = "Select inside function" })
        vim.keymap.set({ "x", "o" }, "ac", function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end, { desc = "Select around class" })
        vim.keymap.set({ "x", "o" }, "ic", function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end, { desc = "Select inside class" })

        -- Text objects: move
        vim.keymap.set("n", "]f", function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end, { desc = "Next function start" })
        vim.keymap.set("n", "[f", function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end, { desc = "Previous function start" })
        vim.keymap.set("n", "]c", function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end, { desc = "Next class start" })
        vim.keymap.set("n", "[c", function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end, { desc = "Previous class start" })
        vim.keymap.set("n", "]a", function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
        end, { desc = "Next parameter" })
        vim.keymap.set("n", "[a", function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
        end, { desc = "Previous parameter" })
      end,
    },
  },
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath("data") .. "/site",
    }

    -- Install parsers (no-op if already installed). Waits for completion so
    -- highlighting/textobjects are available immediately on first run.
    require("nvim-treesitter").install {
      "comment",
      "markdown_inline",
      "markdown",
      "regex",
      "lua",
      "bash",
      "vim",
      "query",
      "json",
      "latex",
    }:wait(300000)

    -- Highlighting is now provided by Neovim (see :h treesitter-highlight).
    -- Enable it on every filetype that has a parser.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Folding via treesitter.
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"

    -- Indentation via treesitter (experimental). Disable for yaml/python like before.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local exclude = { yaml = true, python = true }
        if not exclude[args.match] then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
