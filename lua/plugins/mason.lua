local function try_require_null_ls(source_name)
  local types = { "formatting", "diagnostics" }
  local ok = false
  local source = nil
  for _, t in ipairs(types) do
    ok, source = pcall(require, string.format("null-ls.builtins.%s.%s", t, source_name))
    if ok then break end
  end
  return ok, source
end

local config = function()
  local mason = require "mason"
  local null_ls = require "null-ls"
  local mason_lspconfig = require "mason-lspconfig"
  local mason_null_ls = require "mason-null-ls"

  mason.setup {}
  mason_lspconfig.setup {
    ensure_installed = { "sumneko_lua" },
    github = {
      -- https://github.com/fastgitorg/document
      download_url_template = "https://download.fastgit.org/%s/releases/download/%s/%s",
    },
  }
  mason_null_ls.setup {
    ensure_installed = { "stylua" },
  }
  mason_null_ls.setup_handlers {
    -- all sources with no handler get passed here
    function(source_name)
      local ok, source = try_require_null_ls(source_name)
      if ok then
        null_ls.register(source)
      else
        vim.notify("not found null-ls source " .. source_name)
      end
    end,
    -- stylua = function(source_name, methods) null_ls.register(null_ls.builtins.formatting.stylua) end,
  }
  require("mason-nvim-dap").setup {
    ensure_installed = {},
  }
end

return {
  config = config,
}
