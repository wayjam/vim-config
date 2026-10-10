-- Markdown diagnostics are hidden by default to avoid markdownlint virtual-text
-- noise. Use `<leader>tD` (registered globally in lspconfig) to toggle them.
vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() })
