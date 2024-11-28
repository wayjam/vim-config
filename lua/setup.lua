local utils = require "utils"

local expected_ver = {
  major = 0,
  minor = 7,
  patch = 2,
}

utils.check_version(expected_ver)

vim.g.CONFIG_PATH = utils.get_config_path()
vim.g.DATA_PATH = utils.get_data_path()

utils.source_dir "lua/settings"
utils.source_dir "customize/before"
require("plugin_loader").startup()
utils.source_dir "customize/after"

vim.api.nvim_set_option_value("secure", true, {})
