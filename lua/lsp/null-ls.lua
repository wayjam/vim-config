local function format()
  -- 0.7
  vim.lsp.buf.formatting_sync(nil, 2000) -- 2 seconds
  -- 0.8
  -- vim.lsp.buf.format({timeout_ms = 2000}) -- 2 seconds
end

local function has_exec(filename)
  return function(_)
    return vim.fn.executable(filename) == 1
  end
end

local function setup(opts)
  local null_ls = require "null-ls"
  local utils = require "null-ls.utils"
  local builtins = null_ls.builtins

  local sources = {
    -- formatting
    builtins.formatting.shfmt.with {
      runtime_condition = has_exec "shfmt",
      extra_filetypes = { "bash" },
    },
    builtins.formatting.prettier.with {
      runtime_condition = has_exec "prettier",
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    builtins.formatting.black.with {
      runtime_condition = has_exec "black",
      extra_args = { "--fast" },
    },
    builtins.formatting.stylua.with {
      runtime_condition = has_exec "stylua",
    },
    builtins.formatting.gofmt.with {
      runtime_condition = has_exec "gofmt",
    },
    builtins.formatting.goimports.with {
      runtime_condition = has_exec "goimports",
    },

    -- diagnostics
    builtins.diagnostics.eslint.with {
      runtime_condition = has_exec "eslint",
    },
    builtins.diagnostics.yamllint.with {
      runtime_condition = has_exec "yamllint",
    },

    -- code actions
    null_ls.builtins.code_actions.gitsigns,

    -- completion
    -- builtins.completion.spell,

    -- hover
    -- builtins.hover.dictionary
  }

  local config = {
    debug = false,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    root_dir = utils.root_pattern ".git",
    on_attach = function(client, bufnr)
      if opts.on_attach ~= nil then
        opts.on_attach(client, bufnr)
      end
      vim.api.nvim_exec([[ autocmd BufWritePre <buffer> :silent! lua require('lsp.null-ls').format() ]], false)
    end,
  }

  null_ls.setup(config)

  vim.keymap.set("n", "<leader>fm", format, { silent = true, noremap = true })
  vim.keymap.set("v", "<localleader>=", vim.lsp.buf.range_formatting, { silent = true, noremap = true })
  vim.cmd [[ command! Format execute 'lua require("lsp.null-ls").format()' ]]
end

return { setup = setup, format = format }
