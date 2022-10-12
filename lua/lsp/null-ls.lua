local null_ls = require "null-ls"
local utils = require "null-ls.utils"
local builtins = null_ls.builtins

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function async_formatting(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.lsp.buf.format {
    filter = function(client) return client.name == "null-ls" end,
    bufnr = bufnr,
  }
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

local function register_source(name)
  if name == "" or name == nil then return end

  if null_ls.is_registered(name) then
    vim.notify("registered Null-Ls " .. " source " .. name)
    return
  end

  local is_registered = false
  for method, _ in pairs(builtins) do
    local ok, source = pcall(require, string.format("null-ls.builtins.%s.%s", method, name))
    if ok and source ~= nil then
      null_ls.register(source)
      vim.notify("registered Null-LS " .. method .. " source " .. name)
      is_registered = true
      break
    end
  end

  if not is_registered then vim.notify("not found null-ls source " .. name) end
end

local function has_exec(filename)
  return function(_) return vim.fn.executable(filename) == 1 end
end

local function setup(opts)
  local sources = {
    -- code actions
    null_ls.builtins.code_actions.gitsigns,

    -- completion
    -- builtins.completion.spell,

    -- hover
    -- builtins.hover.dictionary

    -- formatting
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
  }

  local config = {
    debug = false,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    root_dir = utils.root_pattern ".git",
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
  vim.api.nvim_create_user_command("RegisterNullLSSource", function(args) register_source(args.args) end, {
    nargs = 1,
  })
end

return {
  setup = setup,
  format = async_formatting,
  toggle_autoformat = toggle_autoformat,
  register_source = register_source,
}
