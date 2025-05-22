return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
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
      lazy = true,
      config = function()
        require("ts_context_commentstring").setup {
          enable_autocmd = false,
          languages = {
            css = "// %s",
            gomod = "// %s",
          },
        }
      end,
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
      lazy = true,
      specs = {
        {
          "nvim-treesitter/nvim-treesitter",
          opts = {
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
                  ["ic"] = "@class.inner",
                },
              },
              move = {
                enable = true,
                goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                goto_previous_start = {
                  ["[f"] = "@function.outer",
                  ["[c"] = "@class.outer",
                  ["[a"] = "@parameter.inner",
                },
                goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
              },
              swap = { enable = false },
            },
          },
        },
      },
    },
  },
  opts = {
    ensure_installed = { "comment", "markdown_inline", "markdown", "regex", "lua", "bash", "vim", "query", "json" }, -- all or a list of names
    ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = function(lang, bufnr) -- Disable in large buffers
        return lang == "vim" or vim.api.nvim_buf_line_count(bufnr) > 5000
      end,
    },
    indent = { enable = true, disable = { "yaml", "python" } },
    refactor = { highlight_definitions = { enable = true }, highlight_current_scope = { enable = true } },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
}
