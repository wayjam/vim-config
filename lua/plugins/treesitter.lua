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
    -- Sticky context header at the top of the window. Large files are skipped
    -- via on_attach (same gate as highlighting/indent below).
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        max_lines = 3,
        min_window_height = 20,
        trim_scope = "outer",
        on_attach = function(bufnr) return not require("utils").is_treesitter_large_file(bufnr) end,
      },
      keys = {
        {
          "[C",
          function() require("treesitter-context").go_to_context(vim.v.count1) end,
          desc = "Jump to context (upward)",
        },
      },
    },
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
    local utils = require "utils"

    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath("data") .. "/site",
    }

    -- Install parsers in the background so startup never waits for downloads or builds.
    local parser_install = require("nvim-treesitter").install {
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
    }
    parser_install:await(function(err)
      if err then return end
      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.api.nvim_buf_is_loaded(bufnr)
            and vim.bo[bufnr].buftype == ""
            and not utils.is_treesitter_large_file(bufnr)
          then
            pcall(vim.treesitter.start, bufnr)
          end
        end
      end)
    end)

    -- Highlighting is now provided by Neovim (see :h treesitter-highlight).
    -- Enable it on every filetype that has a parser.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if utils.is_treesitter_large_file(args.buf) then
          vim.notify_once(
            "File larger than 512 KiB; skipped Tree-sitter highlighting/indent/context",
            vim.log.levels.INFO
          )
          return
        end
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Folding via treesitter.
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"

    -- Indentation via treesitter (experimental). Disable for yaml/python like before.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local exclude = { yaml = true, python = true }
        if not exclude[args.match] and not utils.is_treesitter_large_file(args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
