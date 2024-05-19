local utils = require "utils"

local on_attach = function(client, bufnr)
  if utils.has_plugin "lsp_signature.nvim" then require("lsp_signature").on_attach(client) end
  if utils.has_plugin "illuminate" then require("illuminate").on_attach(client) end

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 100
  end

  -- Keyboard mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gR", vim.lsp.buf.references, opts) --- using trouble
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  if utils.has_plugin "telescope" then
    vim.keymap.set("n", "<leader>sy", function() require("telescope.builtin").lsp_document_symbols() end, opts)
  end
end

-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
  -- Setup base config for each server.
  local c = {}
  c.on_attach = on_attach
  c.capabilities = vim.lsp.protocol.make_client_capabilities()

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
  c.capabilities.offsetEncoding = { "utf-16" }

  if utils.has_plugin "cmp-nvim-lsp" then
    c.capabilities = vim.tbl_extend("keep", c.capabilities or {}, require("cmp_nvim_lsp").default_capabilities())
  end
  c.capabilities.textDocument.completion.completionItem.snippetSupport = true
  c.capabilities.textDocument.completion.completionItem.preselectSupport = true
  c.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  c.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  c.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  c.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  c.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  c.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  c.capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  -- Merge user-defined lsp settings.
  -- These can be overridden locally by lua/lsp-local/<server_name>.lua
  local exists, module = pcall(require, "lsp-local." .. server_name)
  if not exists then
    exists, module = pcall(require, "lsp." .. server_name)
  end
  if exists then
    local user_config = module.config(c)
    for k, v in pairs(user_config) do
      c[k] = v
    end
  end

  return c
end

-- Iterate and setup all language servers and trigger FileType in windows.
local function setup_servers()
  if not utils.has_plugin "mason-lspconfig" then return end
  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)
      local opts = make_config(server_name)
      require("lspconfig")[server_name].setup(opts)
    end,
  }
end

local function config()
  -- Mappings
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leadaer>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<localleader>q", vim.diagnostic.setloclist, opts)

  -- Diagnostics signs and highlights
  for type, icon in pairs(utils.signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { texthl = hl, text = icon, numhl = "" })
  end

  vim.diagnostic.config {
    virtual_text = false, -- disable virtual text
    signs = {
      active = utils.signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-source-in-diagnostics-neovim-06-only
      source = "if_many",
      spacing = 4,
    },
  })

  -- Open references in quickfix window and jump to first item.
  local on_references = vim.lsp.handlers["textDocument/references"]
  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, { loclist = true })

  -- Configure hover (normal K) handle
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  if utils.has_plugin "lsp_signature.nvim" then require("lsp_signature").setup { bind = true } end
  if utils.has_plugin "nvim-lightbulb" then require("nvim-lightbulb").setup { ignore = { "null-ls" } } end

  -- Setup CompletionItemKind symbols, see lua/lsp/kind.lua
  require("lsp.kind").setup()

  -- Setup LSP servers
  setup_servers()
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "ray-x/lsp_signature.nvim", lazy = true },
    { "kosayoda/nvim-lightbulb", lazy = true },
  },
  config = config,
  on_attach = on_attach,
}
