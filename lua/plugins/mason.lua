local mason = require "mason"
local masonconfig = require "mason-lspconfig"

local config = function()
  mason.setup {}
  masonconfig.setup {
    ensure_installed = { "sumneko_lua" },
  }
end
return {
  config = config,
}
