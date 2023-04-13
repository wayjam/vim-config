local utils = require "utils"

local expected_ver = {
  major = 0,
  minor = 7,
  patch = 2,
}

utils.check_version(expected_ver)

vim.g.CONFIG_PATH = utils.get_config_path()
vim.g.DATA_PATH = utils.get_data_path()

-- local conf_files = {
--   "config/globals.vim",
--   "config/options.vim",
--   "config/keymaps.vim",
-- }
--
-- -- source all the core config files
-- for _, name in ipairs(conf_files) do
--   utils.source_file(name)
-- end
require "settings.globals"
require "settings.options"
require "settings.keymaps"

utils.source_dir "customize/before"
require("plugin_loader").startup()
utils.source_dir "customize/after"

vim.api.nvim_set_option("secure", true)
