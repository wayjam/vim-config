-- markdown files: diagnostics hidden by default to avoid markdownlint
-- virtual-text noise. Use `<leader>tD` (registered globally in lspconfig)
-- to toggle them back on for this buffer.
vim.b.diagnostics_hidden = true
vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() })
