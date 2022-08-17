local map_key = vim.api.nvim_set_keymap

local M = {}

--   Error:   ✘
--   Warning:  ⚠ 
--   Hint:  
--   Information:   ⁱ
M.signs = {
  Error = "",
  Warning = "",
  Hint = "",
  Information = "",
  Other = "﫠",
  Added = "",
  Modified = "柳",
  Removed = "",
  OK = "",
}

M.color = {}

function M.padded_signs(name)
  local pad = vim.g.global_symbol_padding or " "
  return M.signs[name] .. pad
end

function M.file_exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

function M.reload_config()
  vim.cmd("source " .. vim.g["CONFIG_PATH"] .. "/init.vim")
  vim.cmd ":PackerCompile"
  print "Reloaded Configuration."
end

function M.has_plugin(name)
  local ok = packer_plugins[name] and packer_plugins[name].loaded
  return ok
end

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == "string" then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    map_key(mode, lhs, rhs, opts)
  end
end

return M
