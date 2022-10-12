local config = function()
  local mason = require "mason"
  local masonconfig = require "mason-lspconfig"
  mason.setup {}
  masonconfig.setup {
    ensure_installed = { "sumneko_lua" },
    github = {
      -- https://github.com/fastgitorg/document
      download_url_template = "https://download.fastgit.org/%s/releases/download/%s/%s",
    },
  }
end

return {
  config = config,
}
