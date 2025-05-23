---@param v any
---@return boolean
local function is_nil(v) return v == vim.NIL end

---@type table[]
LAZY_PLUGIN_SPEC = {}

---@class Utils
local M = {}

---@param item string|table
function M.SpecFile(item)
  if type(item) == "table" then
    for _, value in pairs(item) do
      table.insert(LAZY_PLUGIN_SPEC, { import = value })
    end
  else
    table.insert(LAZY_PLUGIN_SPEC, { import = item })
  end
end

---@param item any
function M.Spec(item) table.insert(LAZY_PLUGIN_SPEC, item) end

---@type table<string, string>
M.signs = {
  Error = "",
  Warn = "",
  Hint = "󰌶",
  Info = "",
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

---@type table<string, string>
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

---@type table<string, string>
M.icons = {
  ArrowCircleDown = "",
  ArrowCircleLeft = "",
  ArrowCircleRight = "",
  ArrowCircleUp = "",
  BoldArrowDown = "",
  BoldArrowLeft = "",
  BoldArrowRight = "",
  BoldArrowUp = "",
  BoldClose = "",
  BoldDividerLeft = "",
  BoldDividerRight = "",
  BoldLineLeft = "▎",
  BoldLineMiddle = "┃",
  BoldLineDashedMiddle = "┋",
  BookMark = "",
  BoxChecked = "",
  Bug = "",
  Stacks = "",
  Scopes = "",
  Watches = "󰂥",
  DebugConsole = "",
  Calendar = "",
  Check = "",
  ChevronRight = "",
  ChevronShortDown = "",
  ChevronShortLeft = "",
  ChevronShortRight = "",
  ChevronShortUp = "",
  Circle = "",
  Close = "󰅖",
  CloudDownload = "",
  Code = "",
  Comment = "",
  Dashboard = "",
  DividerLeft = "",
  DividerRight = "",
  DoubleChevronRight = "»",
  Ellipsis = "",
  EmptyFolder = "",
  EmptyFolderOpen = "",
  FileSymlink = "",
  File = "",
  Files = "",
  FindFile = "󰈞",
  FindText = "󰊄",
  Fire = "",
  Folder = "",
  FolderClosed = "",
  FolderOpen = "",
  FolderEmpty = "",
  FolderSymlink = "",
  Forward = "",
  Gear = "",
  History = "",
  Lightbulb = "",
  LineLeft = "▏",
  LineMiddle = "│",
  List = "",
  Lock = "",
  NewFile = "",
  Note = "",
  Package = "",
  Pencil = "󰏫",
  Plus = "",
  Project = "",
  Search = "",
  SignIn = "",
  SignOut = "",
  Tab = "󰌒",
  Table = "",
  Target = "󰀘",
  Telescope = "",
  Text = "",
  Tree = "",
  Triangle = "󰐊",
  TriangleShortArrowDown = "",
  TriangleShortArrowLeft = "",
  TriangleShortArrowRight = "",
  TriangleShortArrowUp = "",
}

---@type table
M.color = {}

---@param name string
---@return string
function M.padded_signs(name)
  local pad = vim.g.global_symbol_padding or " "
  return M.signs[name] .. pad
end

---@param fname string
---@return boolean|string
function M.file_exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

---@param name string
---@return boolean
function M.has_plugin(name)
  local installed = vim.tbl_get(require "lazy.core.config", "plugins", name, "_", "installed") ~= nil
  return installed
end

---@param name string
---@return boolean
function M.is_loaded_package(name)
  if not package.loaded[name] then return false end
  return true
end

---@param name string
---@return boolean
function M.executable(name)
  if vim.fn.executable(name) > 0 then return true end
  return false
end

---@param path string
---@return boolean, any
function M.source_file(path)
  local full_path = vim.g["CONFIG_PATH"] .. "/" .. path
  if M.file_exists(full_path) then
    local module_path = string.gsub(path, ".lua", "")
    module_path = string.gsub(module_path, "^lua/", "")
    module_path = string.gsub(module_path, "/", ".")
    local status, result = pcall(require, module_path)
    if not status then
      vim.api.nvim_err_writeln(string.format("Error loading %s: %s", full_path, result))
      return false, result
    end
    return true, result
  else
    return false, "File not found"
  end
end

---@param path string
function M.source_dir(path)
  local dir = vim.g.CONFIG_PATH .. "/" .. path .. "/**/*.lua"
  local paths = vim.split(vim.fn.glob(dir), "\n")

  for _, file in pairs(paths) do
    if file ~= "" then
      local relative_path = string.gsub(file, vim.g.CONFIG_PATH .. "/", "")
      relative_path = string.gsub(relative_path, ".lua", "")
      relative_path = string.gsub(relative_path, "^lua/", "")
      relative_path = string.gsub(relative_path, "/", ".")

      local status, result = pcall(require, relative_path)
      if not status then vim.api.nvim_err_writeln(string.format("Error loading %s: %s", file, result)) end
    end
  end
end

---@return string
function M.get_config_path()
  local fn = vim.fn
  local path = vim.g.etc_vim_path
    or fn.stdpath "config"
    or (not is_nil(fn.getenv "$MYVIMRC") and fn.fnamemodify(fn.expand(fn.getenv "$MYVIMRC"), ":h") or "")
    or (not is_nil(fn.getenv "$VIMCONFIG") and fn.expand(fn.getenv "$VIMCONFIG") or "")
    or fn.fnamemodify(fn.resolve(fn.expand "<sfile>:p"), ":h")

  return path
end

---@return string
function M.get_data_path()
  local fn = vim.fn
  local xdg_data_home = fn.getenv "$XDG_DATA_HOME"

  local path = fn.stdpath "data"
    or fn.expand((not is_nil(xdg_data_home) and xdg_data_home or "~/.local/share") .. "/nvim", 1)

  return path
end

---@param expected_ver table
function M.check_version(expected_ver)
  local current_ver = vim.version()

  if current_ver.major > expected_ver.major then
    return
  elseif current_ver.major == expected_ver.major and current_ver.minor > expected_ver.minor then
    return
  elseif
    current_ver.major == expected_ver.major
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

---@type table<string, boolean>
local keymap_register = {}

---@param modes string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table|nil
function M.keymap(modes, lhs, rhs, opts)
  if opts and opts.buffer then
    vim.keymap.set(modes, lhs, rhs, opts)
    return
  end

  local modes_list = {}
  if type(modes) == "string" then
    modes_list = { modes }
  else
    modes_list = modes
  end

  for _, mode in ipairs(modes_list) do
    local key = mode .. "#" .. lhs

    if keymap_register[key] then
      vim.notify("Duplicate keymap: " .. key .. vim.inspect(opts))
    else
      keymap_register[key] = true
    end
  end

  vim.keymap.set(modes, lhs, rhs, opts)
end

---@param tab table
---@param val any
---@return boolean
function M.has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then return true end
  end

  return false
end

---@param n number
---@param chars number|nil
---@return string
function M.dec_to_hex(n, chars)
  chars = chars or 6
  local hex = string.format("%0" .. chars .. "x", n)
  while #hex < chars do
    hex = "0" .. hex
  end
  return hex
end

---@param opts table|nil
---@return table
function M.get_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ret = vim.tbl_filter(function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param env_name string
---@param default_value any
---@return any
function M.getenv_with_default(env_name, default_value)
  local env_value = os.getenv(env_name)
  return env_value or default_value
end

return M
