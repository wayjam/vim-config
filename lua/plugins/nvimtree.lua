local settings = {
    active = true,
    disable_default_keybindings = 1,
    on_config_done = nil,
    side = "left",
    width = 30,
    show_icons = {git = 1, folders = 1, files = 1},
    ignore = {
        "node_modules",
        ".cache",
        '.mypy_cache',
        '.pytest_cache',
        '.git',
        '.hg',
        '.svn',
        '.stversions',
        '__pycache__',
        '.sass-cache',
        '*.egg-info',
        '.DS_Store',
        '*.pyc'
    },
    auto_open = 0,
    auto_close = 1,
    quit_on_open = 0,
    follow = 1,
    hide_dotfiles = 0,
    root_folder_modifier = ":t",
    tab_open = 0,
    allow_resize = 1,
    lsp_diagnostics = 00,
    auto_ignore_ft = {"startify", "dashboard"},
    icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "",
            staged = "✚",
            unmerged = "",
            renamed = "➜",
            deleted = "✖",
            untracked = "✭",
            ignored = "◌"
        },
        folder = {default = "", open = "", empty = "", empty_open = "", symlink = ""}
    }
}

local function on_open()
    if package.loaded["bufferline.state"] and settings.side == "left" then
        require("bufferline.state").set_offset(settings.width + 1, "")
    end
end

local function on_close()
    local buf = tonumber(vim.fn.expand "<abuf>")
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "NvimTree" and package.loaded["bufferline.state"] then require("bufferline.state").set_offset(0) end
end

local function config()
    local status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
    if not status_ok then
        print("Failed to load nvim-tree.config")
        return
    end

    for opt, val in pairs(settings) do vim.g["nvim_tree_" .. opt] = val end

    local tree_cb = nvim_tree_config.nvim_tree_callback

    vim.g.nvim_tree_bindings = {
        {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
        {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
        {key = "sv", cb = tree_cb("vsplit")},
        {key = "sp", cb = tree_cb("split")},
        {key = "t", cb = tree_cb("tabnew")},
        {key = "<", cb = tree_cb("prev_sibling")},
        {key = ">", cb = tree_cb("next_sibling")},
        {key = "P", cb = tree_cb("parent_node")},
        {key = "<BS>", cb = tree_cb("close_node")},
        {key = "<S-CR>", cb = tree_cb("close_node")},
        {key = "<Tab>", cb = tree_cb("preview")},
        {key = "K", cb = tree_cb("first_sibling")},
        {key = "J", cb = tree_cb("last_sibling")},
        {key = "I", cb = tree_cb("toggle_ignored")},
        {key = "<C-.>", cb = tree_cb("toggle_dotfiles")},
        {key = "<C-r>", cb = tree_cb("refresh")},
        {key = "N", cb = tree_cb("create")},
        {key = "rm", cb = tree_cb("remove")},
        {key = "rn", cb = tree_cb("rename")},
        {key = "RN", cb = tree_cb("full_rename")},
        {key = "x", cb = tree_cb("cut")},
        {key = "c", cb = tree_cb("copy")},
        {key = "p", cb = tree_cb("paste")},
        {key = "y", cb = tree_cb("copy_name")},
        {key = "Y", cb = tree_cb("copy_path")},
        {key = "gy", cb = tree_cb("copy_absolute_path")},
        {key = "[c", cb = tree_cb("prev_git_item")},
        {key = "]c", cb = tree_cb("next_git_item")},
        {key = "-", cb = tree_cb("dir_up")},
        {key = "s", cb = tree_cb("system_open")},
        {key = "q", cb = tree_cb("close")},
        {key = "g?", cb = tree_cb("toggle_help")}
    }

    local tree_view = require "nvim-tree.view"

    -- Add nvim_tree open callback
    local open = tree_view.open
    tree_view.open = function()
        on_open()
        open()
    end

    vim.cmd "au WinClosed * lua require('plugins.nvimtree').on_close()"
    vim.api.nvim_set_keymap('n', '<localleader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

    if settings.on_config_done then settings.on_config_done(nvim_tree_config) end
end

local function change_tree_dir(dir)
    local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
    if lib_status_ok then lib.change_dir(dir) end
end

return {config = config, on_close = on_close, on_open = on_open}

