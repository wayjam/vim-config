local signs = require("utils").signs

local on_attach = function(client, bufnr)
    require("lsp-status").on_attach(client)
    require("lsp_signature").on_attach(client)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
        client.config.flags.debounce_text_changes = 100
    end

    -- Keyboard mappings
    local opts = {silent = true, buffer = bufnr}
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gR", vim.lsp.buf.references, opts) --- using trouble
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set(
        "n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.lsp.diagnostic.show_line_diagnostics, opts)
    vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, opts)

    if packer_plugins["telescope"] and packer_plugins["telescope"].loaded then
        vim.keymap.set(
            "n", "<leader>sy", function()
                require("telescope.builtin").lsp_document_symbols()
            end, opts)
    end

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        vim.keymap.set("n", "<localleader>f", vim.lsp.buf.formatting, opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.keymap.set("v", "<localleader>f", vim.lsp.buf.range_formatting, opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end

    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

end

-- Diagnostics signs and highlights
for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Setup CompletionItemKind symbols, see lua/lsp/kind.lua
require("lsp.kind").setup()

-- Configure diagnostics publish settings
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                                                          vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        underline = false,
        virtual_text = {spacing = 4},
        signs = true
    })

-- Open references in quickfix window and jump to first item.
local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, {loclist = true})

-- Configure hover (normal K) handle
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
    -- Setup base config for each server.
    local c = {}
    c.on_attach = on_attach
    c.capabilities = vim.lsp.protocol.make_client_capabilities()
    c.capabilities = require("cmp_nvim_lsp").update_capabilities(c.capabilities)
    c.capabilities = vim.tbl_extend("keep", c.capabilities or {}, require("lsp-status").capabilities)
    c.capabilities.textDocument.completion.completionItem.snippetSupport = true
    c.capabilities.textDocument.completion.completionItem.documentationFormat = {"markdown", "plaintext"}
    c.capabilities.textDocument.completion.completionItem.snippetSupport = true
    c.capabilities.textDocument.completion.completionItem.preselectSupport = true
    c.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    c.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    c.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    c.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    c.capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
    c.capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {"documentation", "detail", "additionalTextEdits"}
    }

    -- Merge user-defined lsp settings.
    -- These can be overridden locally by lua/lsp-local/<server_name>.lua
    local exists, module = pcall(require, "lsp-local." .. server_name)
    if not exists then exists, module = pcall(require, "lsp." .. server_name) end
    if exists then
        local user_config = module.config(c)
        for k, v in pairs(user_config) do c[k] = v end
    end

    return c
end

-- Iterate and setup all language servers and trigger FileType in windows.
local function setup_servers()
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.settings(
        {ui = {icons = {server_installed = "✓", server_pending = "➜", server_uninstalled = "✗"}}})

    lsp_installer.on_server_ready(
        function(server)
            local opts = make_config(server.name)
            -- (optional) Customize the options passed to the server
            -- if server.name == "tsserver" then
            --     opts.root_dir = function() ... end
            -- end
            --
            -- This setup() function is exactly the same as lspconfig's setup function.
            -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
            server:setup(opts)
        end)

    -- Reload if files were supplied in command-line arguments
    if vim.fn.argc() > 0 and not vim.o.modified then
        vim.cmd("windo e") -- triggers the FileType autocmd that starts the server
    end
end

local function config()
    local lsp_signature = require("lsp_signature")
    local lsp_status = require("lsp-status")

    lsp_status.register_progress()

    lsp_signature.setup(
        {
            bind = true,
            hint_prefix = " " --  
        })

    lsp_status.config(
        {
            indicator_separator = "",
            component_separator = {left = "", right = ""},
            -- indicator_errors = signs.Error,
            -- indicator_warnings = signs.Warning,
            -- indicator_info = signs.Information,
            -- indicator_hint = signs.Hint,
            indicator_ok = "✔",
            status_symbol = "LSP",
            diagnostics = false
        })

    -- Setup LSP with lspinstall
    setup_servers()

    vim.api.nvim_exec(
        [[
            augroup user_lspconfig
                autocmd!
                " See https://github.com/kosayoda/nvim-lightbulb
                autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            augroup END
        ]], false)
end

return {config = config}
