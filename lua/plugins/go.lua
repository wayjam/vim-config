local function config()
  local path = require "nvim-lsp-installer.core.path"
  local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }
  require("go").setup {
    gopls_cmd = { install_root_dir .. "/go/gopls" },
    filstruct = "gopls",
    goimport = "gopls", -- if set to 'gopls' will use golsp format
    gofmt = "gopls", -- if set to gopls will use golsp format
    max_line_len = 120,
    test_dir = "",
    test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
    comment_placeholder = "   ",
    lsp_document_formatting = false,
    lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
    -- lsp_on_attach = true, -- use on_attach from go.nvim
    -- lsp_cfg = nil,
    dap_debug = true,
    dap_debug_vt = "true",
    dap_debug_gui = true,
  }

  -- Run gofmt + goimport on save
  vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
end

return { config = config }
