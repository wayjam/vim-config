local M = {}

function M.file_exists(fname)
    local stat = vim.loop.fs_stat(fname)
    return (stat and stat.type) or false
end

function M.reload_config()
    vim.cmd("source " .. vim.g['CONFIG_PATH'] .. "/init.vim")
    vim.cmd(":PackerCompile")
    print('Reloaded Configuration.')
end

return M
