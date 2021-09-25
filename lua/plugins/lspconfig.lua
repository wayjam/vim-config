local signs = require('utils').signs

local on_attach = function(client, bufnr)
    local function map_buf(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    require('lsp-status').on_attach(client)

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
        client.config.flags.debounce_text_changes = 100
    end

    -- Keyboard mappings
    local opts = {
        noremap = true,
        silent = true
    }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts) --- using trouble
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(
        bufnr, 'n', '<localleader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(
        bufnr, 'n', '<localleader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(
        bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    if packer_plugins["telescope"] and packer_plugins["telescope"].loaded then
        vim.api.nvim_buf_set_keymap(
            bufnr, 'n', '<leader>sy', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    end

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        map_buf('n', '<localleader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        map_buf('v', '<localleader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
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
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(
        hl, {
            text = icon,
            texthl = hl,
            numhl = hl
        })
end

-- Setup CompletionItemKind symbols, see lua/lsp/kind.lua
require('lsp.kind').setup()

-- Configure diagnostics publish settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
                                                          vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        underline = false,
        virtual_text = {
            spacing = 4
        },
        signs = function(bufnr, _)
            return vim.bo[bufnr].buftype == ''
        end
    })

-- Open references in quickfix window and jump to first item.
local on_references = vim.lsp.handlers['textDocument/references']
vim.lsp.handlers['textDocument/references'] = vim.lsp.with(
                                                  on_references, {
        loclist = true
    })

-- Configure hover (normal K) handle
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
                                             vim.lsp.handlers.hover, {
        border = 'rounded'
    })

-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
    -- Setup base config for each server.
    local c = {}
    c.on_attach = on_attach
    c.capabilities = vim.lsp.protocol.make_client_capabilities()
    c.capabilities = require('cmp_nvim_lsp').update_capabilities(c.capabilities)
    c.capabilities = vim.tbl_extend('keep', c.capabilities or {}, require('lsp-status').capabilities)
    c.capabilities.textDocument.completion.completionItem.snippetSupport = true
    c.capabilities.textDocument.completion.completionItem.documentationFormat = {'markdown', 'plaintext'}
    c.capabilities.textDocument.completion.completionItem.snippetSupport = true
    c.capabilities.textDocument.completion.completionItem.preselectSupport = true
    c.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    c.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    c.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    c.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    c.capabilities.textDocument.completion.completionItem.tagSupport = {
        valueSet = {1}
    }
    c.capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }

    -- Merge user-defined lsp settings.
    -- These can be overridden locally by lua/lsp-local/<server_name>.lua
    local exists, module = pcall(require, 'lsp-local.' .. server_name)
    if not exists then exists, module = pcall(require, 'lsp.' .. server_name) end
    if exists then
        local user_config = module.config(c)
        for k, v in pairs(user_config) do c[k] = v end
    end

    return c
end

-- Iterate and setup all language servers and trigger FileType in windows.
local function setup_servers()
    local lsp_install = require('lspinstall')
    lsp_install.setup()
    local servers = lsp_install.installed_servers()
    for _, server in pairs(servers) do
        local config = make_config(server)
        require'lspconfig'[server].setup(config)
    end

    -- Reload if files were supplied in command-line arguments
    if vim.fn.argc() > 0 and not vim.o.modified then
        vim.cmd('windo e') -- triggers the FileType autocmd that starts the server
    end
end

local function config()
    local lsp_install = require('lspinstall')
    local lsp_signature = require('lsp_signature')
    local lsp_status = require('lsp-status')

    lsp_status.register_progress()
    lsp_status.config(
        {
            indicator_separator = ' ',
            component_separator = ' | ',
            indicator_errors = signs.Error,
            indicator_warnings = signs.Warning,
            indicator_info = signs.Information,
            indicator_hint = signs.Hint,
            indicator_ok = '✔',
            status_symbol = 'LSP'
        })

    lsp_signature.setup(
        {
            bind = true,
            hint_prefix = ' ' --  
        })

    -- Setup LSP with lspinstall
    setup_servers()

    -- Automatically reload after `:LspInstall <server>`
    lsp_install.post_install_hook = function()
        setup_servers() -- reload installed servers
        if not vim.bo.modified and vim.bo.buftype == '' then
            vim.cmd('bufdo e') -- starts server by triggering the FileType autocmd
        end
    end

    vim.api.nvim_exec(
        [[
            augroup user_lspconfig
                autocmd!
                " See https://github.com/kosayoda/nvim-lightbulb
                autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            augroup END
        ]], false)
end

return {
    config = config
}

