local utils = require "utils"
local keymap = utils.keymap

local on_attach = function(client, bufnr)
  if utils.has_plugin "lsp_signature.nvim" then require("lsp_signature").on_attach(client) end
  if utils.has_plugin "illuminate" then require("illuminate").on_attach(client) end

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 100
  end

  -- Keyboard mappings
  local keymaps = {
    { "n", "gD", vim.lsp.buf.declaration, "Go to Declaration" },
    { "n", "gd", vim.lsp.buf.definition, "Go to Definition" },
    { "n", "gr", vim.lsp.buf.references, "Go to References" },
    { "n", "gi", vim.lsp.buf.implementation, "Go to Implementation" },
    { "n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition" },
    { "n", "K", vim.lsp.buf.hover, "Show Hover Documentation" },
    { "n", "<C-k>", vim.lsp.buf.signature_help, "Show Signature Help" },
    { "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
    { "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
    {
      "n",
      "<leader>wl",
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      "List Workspace Folders",
    },
    { "n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol" },
    { "n", "<leader>ca", vim.lsp.buf.code_action, "Code Action" },
    { "n", "<leader>e", vim.diagnostic.open_float, "Open Diagnostic Float" },
    { "n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic" },
    { "n", "]d", vim.diagnostic.goto_next, "Next Diagnostic" },
    { "n", "<leader>el", vim.diagnostic.setloclist, "Set LocList" },
  }

  if utils.has_plugin "telescope" then
    table.insert(
      keymaps,
      { "n", "<leader>sy", function() require("telescope.builtin").lsp_document_symbols() end, "Document Symbols" }
    )
    table.insert(keymaps, {
      "n",
      "<leader>dsy",
      function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
      "Workspace Symbols",
    })
  end

  for _, item in ipairs(keymaps) do
    local mode, lhs, rhs, desc = unpack(item)
    keymap(mode, lhs, rhs, {
      desc = desc,
      noremap = true,
      silent = true,
      buffer = bufnr,
    })
  end
end

-- make_config combine base config for each server and merge user-defined settings.
local function make_config(server_name)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if utils.has_plugin "cmp-nvim-lsp" then
    capabilities = vim.tbl_extend("keep", capabilities, require("cmp_nvim_lsp").default_capabilities())
  end

  vim.tbl_extend("keep", capabilities, {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
        },
      },
      foldingRange = {
        dynamicRegistration = true,
        lineFoldingOnly = true,
      },
    },
    offsetEncoding = { "utf-16" }, -- for null-ls
  })

  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local success, customConfig = pcall(require, "lsp-local." .. server_name)
  if not success then
    success, customConfig = pcall(require, "lsp." .. server_name)
  end

  if success and type(customConfig.config) == "function" then
    config = vim.tbl_deep_extend("force", config, customConfig.config(config) or {})
  end

  return config
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

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "ray-x/lsp_signature.nvim", lazy = true },
    { "kosayoda/nvim-lightbulb", lazy = true },
  },
  on_attach = on_attach,
  config = function()
    -- Diagnostics signs and highlights
    vim.diagnostic.config {
      signs = true,
      virtual_text = {
        source = "if_many",
        spacing = 4,
      },
      update_in_insert = false,
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
    for type, icon in pairs(utils.signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { texthl = hl, text = icon, numhl = hl })
    end

    -- Configure hover (normal K) handle
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    if utils.has_plugin "lsp_signature.nvim" then require("lsp_signature").setup { bind = true } end
    if utils.has_plugin "nvim-lightbulb" then
      require("nvim-lightbulb").setup {
        autocmd = { enabled = true },
        ignore = { "null-ls" },
      }
    end

    -- Setup CompletionItemKind symbols, see lua/lsp/kind.lua
    require("lsp.kind").setup()

    -- Setup LSP servers
    setup_servers()
  end,
}
