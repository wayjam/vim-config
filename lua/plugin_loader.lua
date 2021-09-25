local utils = require("utils")

local packer_install_dir = vim.g["DATA_PATH"] .. "/site/pack/packer/opt/packer.nvim"
local packer_compiled_path = vim.g["DATA_PATH"] .. "/packer_compiled.lua"
local packer_package_root = vim.g["DATA_PATH"] .. "/site/pack"
local packer_repo = "https://github.com/wbthomason/packer.nvim"
local install_cmd = string.format("10split |term git clone --depth=1 %s %s", packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if vim.fn.glob(packer_install_dir) == "" then
    vim.api.nvim_echo({{"Installing packer.nvim", "Type"}}, true, {})
    vim.cmd(install_cmd)
    print("You shoud run `:PackerSync` at first time.")
end

vim.cmd("packadd packer.nvim")
local packer = require("packer")

local settings = {
    profile = {enable = false, threshold = 1},
    package_root = packer_package_root,
    compile_path = packer_compiled_path,
    git = {default_url_format = plug_url_format},
    auto_reload_compiled = true,
    compile_on_sync = true
}

local function startup()
    vim.cmd(
        [[
      augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
      augroup end
    ]])
    packer.startup(
        {
            function(use)
                vim.cmd("source" .. vim.g["CONFIG_PATH"] .. "/config/plugins/plugins.vim")
                for _, plugin in ipairs(require("plugins")) do use(plugin) end
            end,
            config = settings
        })
    if utils.file_exists(packer_compiled_path) then
        vim.cmd("source " .. packer_compiled_path)
    else
        packer.compile()
    end
end

return {startup = startup}
