-- Runtime Initialize
-- Disable vim distribution plugins
vim.g.loaded_gzip = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

-- When using VIMINIT trick for exotic MYVIMRC locations, add path now.
if not vim.o.runtimepath:find(vim.g.CONFIG_PATH, 1, true) then
  vim.o.runtimepath = vim.g.CONFIG_PATH .. "," .. vim.o.runtimepath
  vim.o.runtimepath = vim.g.CONFIG_PATH .. "/after," .. vim.o.runtimepath
end

-- Ensure data directories
local data_dirs = {
  vim.g.DATA_PATH,
  vim.g.DATA_PATH .. "/undo",
  vim.g.DATA_PATH .. "/backup",
  vim.g.DATA_PATH .. "/session",
  vim.g.CONFIG_PATH .. "/spell",
}

for _, path in ipairs(data_dirs) do
  if vim.fn.isdirectory(path) == 0 then vim.fn.mkdir(path, "p", 0700) end
end

-- Try setting up the custom virtualenv created by ./venv.sh
local virtualenv = vim.g.DATA_PATH .. "/venv/bin/python"
if vim.fn.empty(virtualenv) == 1 or vim.fn.filereadable(virtualenv) == 0 then
  -- Fallback to old virtualenv location
  virtualenv = vim.g.DATA_PATH .. "/venv/neovim3/bin/python"
end

-- Python interpreter settings
if vim.fn.filereadable(virtualenv) == 1 then vim.g.python3_host_prog = virtualenv end
