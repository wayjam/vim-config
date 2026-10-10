-- Module-level cache: avoids repeated filesystem lookups / executable probes
-- on every lint trigger. key -> bool. Cleared by :Lazy reload.
local _cache = {}

local function find_upward_cached(dirname, files)
  local key = dirname .. "|" .. table.concat(files, ",")
  if _cache[key] == nil then _cache[key] = vim.fs.find(files, { upward = true, path = dirname })[1] ~= nil end
  return _cache[key]
end

local function executable_cached(cmd)
  local key = "exe:" .. cmd
  if _cache[key] == nil then _cache[key] = vim.fn.executable(cmd) == 1 end
  return _cache[key]
end

local GOLANGCI_CONFIGS = { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" }
local BIOME_CONFIGS = { "biome.json", "biome.jsonc" }

local function has_golangci(ctx)
  return executable_cached "golangci-lint" and find_upward_cached(ctx.dirname, GOLANGCI_CONFIGS)
end

local function has_biome(ctx) return executable_cached "biome" and find_upward_cached(ctx.dirname, BIOME_CONFIGS) end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile", "FileReadPre" },
  dependencies = { "mason.nvim", "rshkarin/mason-nvim-lint" },
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "FileChangedShellPost" },
    linters_by_ft = {
      fish = { "fish" },
      c = { "clangtidy" },
      clojure = { "clj-kondo" },
      cmake = { "cmake-lint" },
      css = { "stylelint" },
      cpp = { "clangtidy" },
      go = { "golangcilint", "revive" },
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
      gitcommit = { "typos" },
      svelte = { "biomejs", "eslint_d" },
      javascript = { "biomejs", "eslint_d" },
      typescript = { "biomejs", "eslint_d" },
      javascriptreact = { "biomejs", "eslint_d" },
      typescriptreact = { "biomejs", "eslint_d" },
      nix = { "nix" },
      proto = { "buf_lint" },

    },
    -- or add custom linters.
    linters = {
      -- Go: prefer golangci-lint (requires: installed + a .golangci.* config at
      -- the project root); otherwise fall back to revive
      golangcilint = {
        condition = function(ctx) return has_golangci(ctx) end,
      },
      revive = {
        condition = function(ctx) return not has_golangci(ctx) end,
      },
      -- JS/TS: prefer biome (requires: installed + a biome.json/biome.jsonc at
      -- the project root); otherwise fall back to eslint_d
      biomejs = {
        condition = function(ctx) return has_biome(ctx) end,
      },
      eslint_d = {
        condition = function(ctx) return not has_biome(ctx) end,
      },
      -- Python: skip with a one-time notice when ruff is missing, instead of
      -- erroring on every lint event
      ruff = {
        condition = function()
          local available = executable_cached "ruff"
          if not available then
            vim.notify_once("Ruff unavailable; skipped Python linting", vim.log.levels.WARN)
          end
          return available
        end,
      },
    },
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

    local previous_state = rawget(_G, "__nvim_lint_debounce_state")
    if previous_state and previous_state.close_all then previous_state.close_all() end

    local state = { closed = false, timers = {} }
    _G.__nvim_lint_debounce_state = state

    local function close_timer(timer)
      if timer and not timer:is_closing() then
        timer:stop()
        timer:close()
      end
    end

    function state.close_all()
      state.closed = true
      for _, timer in pairs(state.timers) do
        close_timer(timer)
      end
      state.timers = {}
    end

    local function get_linter_names(bufnr)
      return vim.api.nvim_buf_call(bufnr, function()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = vim.list_extend({}, lint._resolve_linter_by_ft(vim.bo.filetype))

        -- Add fallback and global linters.
        if #names == 0 then vim.list_extend(names, lint.linters_by_ft["_"] or {}) end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        return vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then vim.notify("Linter not found: " .. name, nil, { title = "nvim-lint" }) end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)
      end)
    end

    function M.clear_diagnostics(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end

      for _, name in ipairs(get_linter_names(bufnr)) do
        local linter = lint.linters[name]
        if type(linter) == "function" then linter = linter() end
        vim.diagnostic.reset(lint.get_namespace(type(linter) == "table" and (linter.name or name) or name), bufnr)
      end
    end

    function M.lint(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end

      local names = get_linter_names(bufnr)
      if #names > 0 then vim.api.nvim_buf_call(bufnr, function() lint.try_lint(names) end) end
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
        vim.notify(string.format("Lint enabled for buffer %d", bufnr), vim.log.levels.INFO)
        -- lint the buffer immediately when enabled
        M.lint()
      else
        vim.b.disable_autolint = true
        M.clear_diagnostics(bufnr)
        vim.notify(string.format("Lint disabled for buffer %d", bufnr), vim.log.levels.WARN)
      end
    end, { desc = "Toggle lint for current buffer" })

    local auGroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    local function queue_lint(bufnr)
      if state.closed or not vim.api.nvim_buf_is_valid(bufnr) then return end

      close_timer(state.timers[bufnr])
      local timer = vim.uv.new_timer()
      state.timers[bufnr] = timer
      timer:start(100, 0, function()
        timer:stop()
        vim.schedule(function()
          if state.closed or state.timers[bufnr] ~= timer then return end
          state.timers[bufnr] = nil
          close_timer(timer)
          if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end
          if not M.lint_globally_disabled and not vim.b[bufnr].disable_autolint then M.lint(bufnr) end
        end)
      end)
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = auGroup,
      callback = function(args) queue_lint(args.buf) end,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = auGroup,
      callback = function(args)
        if vim.bo[args.buf].filetype == "gitcommit" then queue_lint(args.buf) end
      end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
      group = auGroup,
      callback = function(args)
        close_timer(state.timers[args.buf])
        state.timers[args.buf] = nil
      end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = auGroup,
      callback = state.close_all,
    })

    require("utils").keymap("n", "<leader>cL", function() M.lint() end, { desc = "Trigger linting for current file" })
  end,
}
