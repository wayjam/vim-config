return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile", "FileReadPre" },
  dependencies = { "mason.nvim", "rshkarin/mason-nvim-lint" },
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
      c = { "clangtidy" },
      clojure = { "clj-knodo" },
      cmake = { "cmake-lint" },
      css = { "stylelint" },
      cpp = { "clangtidy" },
      go = { "revive" },
      java = { "checkstyle" },
      json = { "jsonlint" },
      kotlin = { "ktlint" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      python = { "ruff" },
      ruby = { "standardrb" },
      sh = { "shellcheck" },
      vim = { "vint" },
      yaml = { "yamllint" },
      svelte = { "edlint_d" },
      javascript = { "edlint_d" },
      typescript = { "edlint_d" },
      javascriptreact = { "edlint_d" },
      typescriptreact = { "edlint_d" },
      nix = { "nix" },
      proto = { "buf_lint" },

      -- Use the "*" filetype to run linters on all filetypes.
      ["*"] = { "typos" },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
    },
    -- or add custom linters.
    linters = {},
  },
  config = function(_, opts)
    local M = {
      lint_globally_disabled = false,
    }

    local lint = require "lint"
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        if type(linter.prepend_args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.prepend_args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.clear_diagnostics(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      vim.diagnostic.reset(bufnr, nil)
    end

    function M.lint()
      -- Use nvim-lint's logic first:
      -- * checks if linters exist for the full filetype first
      -- * otherwise will split filetype by "." and add all those linters
      -- * this differs from conform.nvim which only uses the first filetype that has a formatter
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then vim.list_extend(names, lint.linters_by_ft["_"] or {}) end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then vim.notify("Linter not found: " .. name, nil, { title = "nvim-lint" }) end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      -- Run linters.
      if #names > 0 then lint.try_lint(names) end
    end

    vim.api.nvim_create_user_command("ToggleLintGlobal", function()
      M.lint_globally_disabled = not M.lint_globally_disabled

      if M.lint_globally_disabled then
        vim.notify("Lint globally disabled", vim.log.levels.WARN)
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then M.clear_diagnostics(bufnr) end
        end
      else
        vim.notify("Lint globally enabled", vim.log.levels.INFO)
        M.lint()
      end
    end, {
      desc = "Toggle lint globally",
    })

    vim.api.nvim_create_user_command("ToggleLintBuffer", function()
      local bufnr = vim.api.nvim_get_current_buf()

      if vim.b.disable_autolint then
        vim.b.disable_autolint = false
        vim.notify(string.format("Lint enabled for buffer %d", bufnr), vim.log.levels.WARN)
      else
        vim.b.disable_autolint = true
        vim.notify(string.format("Lint disabled for buffer %d", bufnr), vim.log.levels.WARN)
        -- lint the buffer immediately when enabled
        M.lint()
      end
    end, { desc = "Toggle lint for current buffer" })

    local auGroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    -- lint on save
    vim.api.nvim_create_autocmd(opts.events, {
      group = auGroup,
      callback = M.debounce(100, function()
        if not M.lint_globally_disabled and not vim.b.disable_autolint then M.lint() end
      end),
    })

    require("utils").keymap("n", "<leader>cL", function() M.lint() end, { desc = "Trigger linting for current file" })
  end,
}
