local function config()
  require("nvim-treesitter.configs").setup {
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
      swap = { enable = false },
    },
  }
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
end

local function commentstring()
  require("ts_context_commentstring").setup {
    enable_autocmd = false,
    languages = {
      css = "// %s",
      gomod = "// %s",
    },
  }
end

local function autotag()
  require("nvim-treesitter.configs").setup {
    autotag = { enable = true },
    filetypes = {
      "html",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
    },
  }
end

return {
  "nvim-treesitter/nvim-treesitter",
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
      lazy = true,
      config = function() require("plugins.treesitter").commentstring() end,
    },
    {
      "windwp/nvim-ts-autotag",
      config = function() require("plugins.treesitter").autotag() end,
    },
  },
  init = function() end,
  config = config,
  commentstring = commentstring,
  autotag = autotag,
}
