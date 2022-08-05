local M = {}

M.icons = {
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "練",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "襁",
  Reference = "",
  Snippet = " ",
  Struct = "פּ",
  Text = "",
  TypeParameter = "",
  Unit = "塞",
  Value = "",
  Variable = "",
}

function M.setup()
  local kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(kinds) do
    kinds[i] = M.icons[kind] or kind
  end
end

return M
