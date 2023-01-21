local null_ls = require "null-ls"
local utils = require "null-ls.utils"
local builtins = null_ls.builtins

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function async_formatting(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- don't apply results if buffer is unloaded
  if not vim.api.nvim_buf_is_loaded(bufnr) then return end

  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local null_ls_client = require("null-ls.client").get_client()
  local null_ls_attached = null_ls_client and null_ls_client.id > 0 and vim.lsp.buf_is_attached(bufnr, null_ls_client)
  local null_ls_format_available = #(require("null-ls.sources").get_available(ft, null_ls.methods.FORMATTING)) > 0

  -- null-ls not attach, use all
  -- null-ls attached and format available, use null-ls only
  -- null-ls attached and not available, use all or filter null-ls
  vim.lsp.buf.format {
    bufnr = bufnr,
    timeout_ms = 2000,
    filter = function(client)
      if not null_ls_attached then return true end
      if null_ls_format_available then return client.name == "null-ls" end
      return true
    end,
  }
  vim.notify "formatted."
end

local function create_autocmd(bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function() async_formatting(bufnr) end,
  })
end

local function toggle_autoformat(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cmds = vim.api.nvim_get_autocmds {
    group = augroup,
    event = "BufWritePre",
  }

  local id = 0
  for _, c in pairs(cmds) do
    if c["buflocal"] == true then id = c["id"] end
  end

  if id ~= 0 then
    vim.notify "DisableAutoFormat"
    vim.api.nvim_del_autocmd(id)
  else
    vim.notify "EnableAutoFormat"
    create_autocmd(bufnr)
  end
end

local function has_exec(filename)
  return function(_) return require("utils").executable(filename) end
end

local function setup(opts)
  local sources = {
    -- code actions
    builtins.code_actions.gitsigns,
    builtins.code_actions.eslint,

    -- completion
    -- builtins.completion.spell,

    -- hover
    -- builtins.hover.dictionary

    -- formatting
    builtins.formatting.stylua.with {
      runtime_condition = has_exec "stylua",
    },
    builtins.formatting.shfmt.with {
      runtime_condition = has_exec "shfmt",
      extra_filetypes = { "bash" },
    },
    builtins.formatting.prettier.with {
      runtime_condition = has_exec "prettier",
      disabled_filetypes = { "yaml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    builtins.formatting.black.with {
      runtime_condition = has_exec "black",
      extra_args = { "--fast" },
    },
    builtins.formatting.gofmt.with {
      runtime_condition = has_exec "gofmt",
    },
    builtins.formatting.goimports.with {
      runtime_condition = has_exec "goimports",
    },
    builtins.formatting.rustfmt.with {
      runtime_condition = has_exec "rustfmt",
    },

    -- diagnostics
    builtins.diagnostics.eslint.with {
      runtime_condition = has_exec "eslint",
    },
    builtins.diagnostics.yamllint.with {
      runtime_condition = has_exec "yamllint",
    },
  }

  local config = {
    debug = false,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    root_dir = utils.root_pattern(".null-ls-root", "Makefile", ".git"),
    should_attach = function(bufnr) return not vim.api.nvim_buf_get_name(bufnr):match "^git://" end,
    on_attach = function(client, bufnr)
      if opts.on_attach ~= nil then opts.on_attach(client, bufnr) end
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        create_autocmd(bufnr)
      end
    end,
  }

  null_ls.setup(config)

  -- keymaps
  vim.keymap.set("n", "<leader>fm", async_formatting, { silent = true, noremap = true })
  vim.keymap.set("v", "<localleader>=", vim.lsp.buf.range_formatting, { silent = true, noremap = true })
  vim.api.nvim_create_user_command("Format", function(_) async_formatting() end, {})
  vim.api.nvim_create_user_command("AutoFormatToggle", function(_) toggle_autoformat() end, {})
end

return {
  config = function() setup { on_attach = require("plugins.lspconfig").on_attach } end,
  format = async_formatting,
  toggle_autoformat = toggle_autoformat,
}
