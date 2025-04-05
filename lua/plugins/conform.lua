local format_opts = {
   timeout_ms = 500, lsp_format = "fallback",
}

local function format() require("conform").format(format_opts) end

return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim", "zapling/mason-conform.nvim" },
  event = { "BufWritePre" },
  cmd = "ConformInfo",
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
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        c = { "clang_format" },
        clojure = { "zprint" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        cs = { "charpier" },
        dart = { "dart_format" },
        elixir = { "mix" },
        fish = { "fish_indent" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        java = { "google-java-format" },
        json = { "jq" },
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
        svelte = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        -- Use the "*" filetype to run formatters on all filetypes.
        -- ["*"] = {},
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      formatters = {
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
      -- Set the log level. Use `:ConformInfo` to see the location of the log file.
      log_level = vim.log.levels.ERROR,
      -- Conform will notify you when a formatter errors
      notify_on_error = true,
      -- If this is set, Conform will run the formatter on save.
      -- It will pass the table to conform.format().
      -- This can also be a function that returns the table.
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return format_opts
      end,
    }
    return opts
  end,
  config = function(_, opts) require("conform").setup(opts) end,
}
