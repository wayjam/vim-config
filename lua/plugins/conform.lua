local format_opts = {
  timeout_ms = 500,
  lsp_format = "fallback", -- Corrected key name (was lsp_fallback in original format_opts, should be lsp_format)
}

local function format() require("conform").format(format_opts) end

return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim", "zapling/mason-conform.nvim" },
  event = "VeryLazy",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cF",
      format,
      mode = { "n", "v" },
      desc = "Format file or range",
    },
  },
  init = function()
    vim.api.nvim_create_user_command("Format", format, { desc = "Trigger Format" })
    vim.api.nvim_create_user_command("ToggleAutoFormat", function(_)
      if vim.b.disable_autoformat then
        vim.b.disable_autoformat = false
        vim.notify "Enable AutoFormat"
      else
        vim.b.disable_autoformat = true
        vim.notify "Disable AutoFormat"
      end
    end, {
      desc = "Toggle autoformat-on-save",
    })
  end,
  opts = function()
    local opts = {
      -- Default options for formatters
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- Recommended default
        quiet = false, -- Recommended default
        lsp_format = "fallback", -- Recommended default
      },

      -- *** This is the main section that needed updating ***
      formatters_by_ft = {
        c = { "clang_format" },
        clojure = { "zprint" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
        dart = { "dart_format" },
        elixir = { "mix" },
        fish = { "fish_indent" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        java = { "google-java-format" },
        json = { "prettierd" },
        kotlin = { "ktlint" },
        lua = { "stylua" },
        perl = { "perlimports", "perltidy" },
        php = { "php_cs_fixer" },
        python = { "isort", "black" },
        ruby = { "standardrb" },
        rust = { "rustfmt" },
        scala = { "scalafmt" },
        sh = { "shfmt", "beautysh" },
        toml = { "taplo" },
        xml = { "xmlformat" },
        yaml = { "yamlfmt" },
        zig = { "zigfmt" },
        proto = { "buf" },
        svelte = { "prettierd", "prettier" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },

        -- Use the "*" filetype to run formatters on all filetypes.
        -- ["*"] = {},
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },

      -- Custom formatters or overrides
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- Example overrides (currently commented out)
        -- dprint = { ... }
        -- shfmt = { ... }
      },

      -- Ensure 'stop_after_first' is true (this is the default, so explicitly setting it is optional
      -- but good for clarity if you want this behavior). This replaces the old nested {} logic.
      -- conform will try formatters in the list sequentially and stop after the first success.
      stop_after_first = true, -- Added for clarity, usually defaults to true

      log_level = vim.log.levels.ERROR,
      notify_on_error = true,

      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        -- Use the options defined at the top for consistency
        -- Note: I corrected lsp_fallback to lsp_format in the format_opts table at the top
        return format_opts
      end,
    }
    return opts
  end,
  config = function(_, opts) require("conform").setup(opts) end,
}
