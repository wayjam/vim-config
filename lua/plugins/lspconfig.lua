local utils = require "utils"
local keymap = utils.keymap

local M = {}

M.icons = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "󰟢",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
  Copilot = "",
}

function M.get_capabilities()
  local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {})

  if require("utils").has_plugin "blink.cmp" then
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  end

  return capabilities
end

function M.setup_kind()
  local kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(kinds) do
    kinds[i] = M.icons[kind] or kind
  end
end

function M.toggle_inlay_hint()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
  vim.notify(
    "Inlay hints: " .. (vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } and "enabled" or "disabled"),
    vim.log.levels.INFO
  )
end

function M.setup_keymaps(bufnr)
  local keymaps = {
    { "n", "gD", vim.lsp.buf.declaration, "Goto Declaration" },
    { "n", "gd", vim.lsp.buf.definition, "Goto Definition" },
    { "n", "gi", vim.lsp.buf.implementation, "Goto Implementation" },
    { "n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition" },
    {
      "n",
      "K",
      function()
        vim.lsp.buf.hover {
          border = "rounded",
        }
      end,
      "Show Hover Documentation",
    },
    {
      { "i", "n" },
      "<C-k>",
      function()
        vim.lsp.buf.signature_help {
          border = "single",
          close_events = { "CursorMoved", "BufHidden" },
        }
      end,
      "Show Signature Help",
    },
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
    { "n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, "Prev Diagnostic" },
    { "n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, "Next Diagnostic" },
    { "n", "<leader>el", vim.diagnostic.setloclist, "Set LocList" },
  }

  if not (utils.has_plugin "telescope" or utils.has_plugin "fzf-lua") then
    table.insert(keymaps, {
      "n",
      "gr",
      vim.lsp.buf.references,
      "Goto References",
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

function M.on_attach(client, bufnr) M.setup_keymaps(bufnr) end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      -- Diagnostics signs and highlights
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = utils.signs["BoldError"],
            [vim.diagnostic.severity.WARN] = utils.signs["BoldWarning"],
            [vim.diagnostic.severity.INFO] = utils.signs["BoldInformation"],
            [vim.diagnostic.severity.HINT] = utils.signs["BoldQuestion"],
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 4,
          prefix = utils.icons["Triangle"],
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        document_highlight = {
          enabled = true,
        },
        codelens = {
          enabled = false,
        },
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(" %s ", utils.signs[level])
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
          end,
        },
      }

      -- Setup CompletionItemKind symbols
      M.setup_kind()

      vim.lsp.config(
        "*",
        ---@type vim.lsp.Config
        {
          capabilities = M.get_capabilities(),
          on_attach = M.on_attach,
        }
      )

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if not client then return end

          -- lang specify: https://github.com/MysticalDevil/inlay-hints.nvim
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
            -- Toggle inlay hints
            vim.api.nvim_create_user_command(
              "ToggleInlayHints",
              function() M.toggle_inlay_hint(bufnr) end,
              { nargs = 0 }
            )

            keymap("n", "<leader>ih", function() M.toggle_inlay_hint(bufnr) end, {
              desc = "Toggle Inlay Hint",
              noremap = true,
              silent = true,
              buffer = bufnr,
            })
          end
        end,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    lazy = true,
    event = { "BufReadPre", "BufNewFile", "FileReadPre" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls" },
        automatic_enable = true,
      }
    end,
  },
}
