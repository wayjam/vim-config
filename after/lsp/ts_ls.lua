-- typescript-language-server (formerly `tsserver`, renamed to `ts_ls` in
-- nvim-lspconfig 1.0). mason-lspconfig.automatic_enable loads this file.
return {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
