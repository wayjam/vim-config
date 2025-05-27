local utils = require "utils"

local expected_ver = {
  major = 0,
  minor = 11,
  patch = 2,
}

utils.check_version(expected_ver)

vim.g.CONFIG_PATH = utils.get_config_path()
vim.g.DATA_PATH = utils.get_data_path()
vim.cmd("set runtimepath+=" .. vim.g.CONFIG_PATH) -- add to runtimepath
package.path = vim.g.CONFIG_PATH .. "/?.lua;" .. package.path -- ensure package.path
package.path = vim.g.CONFIG_PATH .. "/?/init.lua;" .. package.path -- ensure require

utils.source_dir "lua/settings"
utils.source_dir "customize/before"

require("plugin_loader").startup()

utils.source_dir "customize/after"

vim.api.nvim_set_option_value("secure", true, {})
