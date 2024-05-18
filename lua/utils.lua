local map_key = vim.api.nvim_set_keymap

local function is_nil(v) return v == vim.NIL end

local M = {}

--   Error:   ✘  
--   Warning:  ⚠  
--   Hint:   
--   Information:   ⁱ  
M.signs = {
  Error = "",
  Warning = "",
  Hint = "󰌶",
  Information = "",
  BoldError = "",
  BoldWarning = "",
  BoldInformation = "",
  BoldQuestion = "",
  Question = "",
  BoldHint = "",
  Debug = "",
  Trace = "✎",
  Other = "﫠",
  OK = "",
}

M.git_symbols = {
  Added = "",
  Modified = "",
  Unstaged = "",
  Staged = "✔",
  Conflict = "",
  Renamed = "≈",
  Deleted = "×",
  Untracked = "+",
  Ignored = "⊙",
}

M.icons = {
  FolderClosed = "",
  FolderOpen = "",
  FolderEmpty = "",
  File = "",
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

function M.has_plugin(name)
  if not package.loaded[name] then return false end
  return true
end

function M.executable(name)
  if vim.fn.executable(name) > 0 then return true end
  return false
end

function M.source_file(path)
  local full_path = vim.g["CONFIG_PATH"] .. "/" .. path
  if M.file_exists(full_path) then
    local ok, _ = pcall(vim.cmd, "source " .. full_path)
    if not ok then vim.api.nvim_echo({ { full_path .. " not sourced", "ErrorMsg" } }, false, {}) end
    return ok
  end

  return false
end

function M.source_dir(path)
  local dir = vim.g.CONFIG_PATH .. "/" .. path .. "/**/*.lua"
  local paths = vim.split(vim.fn.glob(dir), "\n")

  for _, file in pairs(paths) do
    if file ~= "" then
      local ok, _ = pcall(vim.cmd, "source " .. file)
      if not ok then vim.api.nvim_echo({ { file .. " not sourced", "ErrorMsg" } }, false, {}) end
    end
  end
end

function M.get_config_path()
  local fn = vim.fn
  local path = vim.g.etc_vim_path
      or fn.stdpath "config"
      or (not is_nil(fn.getenv "$MYVIMRC") and fn.fnamemodify(fn.expand(fn.getenv "$MYVIMRC"), ":h") or "")
      or (not is_nil(fn.getenv "$VIMCONFIG") and fn.expand(fn.getenv "$VIMCONFIG") or "")
      or fn.fnamemodify(fn.resolve(fn.expand "<sfile>:p"), ":h")

  return path
end

function M.get_data_path()
  local fn = vim.fn
  local xdg_data_home = fn.getenv "$XDG_DATA_HOME"

  local path = fn.stdpath "data"
      or fn.expand((not is_nil(xdg_data_home) and xdg_data_home or "~/.local/share") .. "/nvim", 1)

  return path
end

-- check if we have the latest stable version of nvim
function M.check_version(expected_ver)
  local current_ver = vim.version()

  if current_ver.major > expected_ver.major then
    return
  elseif current_ver.major == expected_ver.major and current_ver.minor > expected_ver.minor then
    return
  elseif current_ver.major == expected_ver.major
      and current_ver.minor == expected_ver.minor
      and current_ver.patch > expected_ver.patch
  then
    return
  else
    local msg = string.format(
      "neovim version %d.%d.%d, but expected %d.%d.%d",
      current_ver.major,
      current_ver.minor,
      current_ver.patch,
      expected_ver.major,
      expected_ver.minor,
      expected_ver.patch
    )
    vim.api.nvim_echo({ { msg, "ErrorMsg" } }, false, {})
  end
end

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == "string" then modes = { modes } end
  for _, mode in ipairs(modes) do
    map_key(mode, lhs, rhs, opts)
  end
end

function M.has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then return true end
  end

  return false
end

return M
