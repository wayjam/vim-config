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

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

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

function M.toggle_inlay_hint(bufnr)
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
  vim.notify(
    "Inlay hints: " .. (vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } and "enabled" or "disabled"),
    vim.log.levels.INFO
  )
end

function M.reload_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    -- my.lsp
    vim.api.nvim_exec_autocmds("FileType", { group = "nvim.lsp.enable", buffer = bufnr })
    return
  end

  for _, c in ipairs(clients) do
    local attached_buffers = vim.tbl_keys(c.attached_buffers) ---@type integer[]
    local config = c.config
    vim.lsp.stop_client(c.id, true)
    vim.defer_fn(function()
      local id = vim.lsp.start(config)
      if id then
        for _, b in ipairs(attached_buffers) do
          vim.lsp.buf_attach_client(b, id)
        end
        vim.notify(string.format("Lsp `%s` has been restarted.", config.name))
      else
        vim.notify(string.format("Error restarting `%s`.", config.name), vim.log.levels.ERROR)
      end
    end, 600)
  end
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

          -- Inlay hints toggle (capability-gated)
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

          -- Document highlight: hl symbol under cursor when idle
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
            local hl_group = vim.api.nvim_create_augroup("my.lsp.document_highlight." .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd({ "LspDetach" }, {
              group = hl_group,
              buffer = bufnr,
              callback = function(detach)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = hl_group, buffer = detach.buf }
              end,
            })
          end

          -- Codelens is intentionally NOT auto-refreshed here (disabled by default).
          -- If you want it later, gate on textDocument_codeLens and call
          -- vim.lsp.codelens.refresh({ bufnr = bufnr }) on BufEnter/InsertLeave.
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

      vim.api.nvim_create_user_command("LspReload", function() M.reload_lsp() end, {
        desc = "Reload all the LSP clients attached to the current buffer",
      })
    end,
  },
}
