local settings = {
    show_icons = {git = 1, folders = 1, files = 1, folder_arrows = 0},
    git_hl = 0,
    root_folder_modifier = ":t",
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
end

local function on_close()
end

local function change_tree_dir(dir)
    local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
    if lib_status_ok then lib.change_dir(dir) end
end

local function config()
    local tree_cb = require"nvim-tree.config".nvim_tree_callback

    for opt, val in pairs(settings) do vim.g["nvim_tree_" .. opt] = val end
    local mappings = {
        {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
        {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
        {key = "<C-v>", cb = tree_cb("vsplit")},
        {key = "<C-x>", cb = tree_cb("split")},
        {key = "<C-t>", cb = tree_cb("tabnew")},
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
        {key = "X", cb = tree_cb("cut")},
        {key = "C", cb = tree_cb("copy")},
        {key = "P", cb = tree_cb("paste")},
        {key = "y", cb = tree_cb("copy_name")},
        {key = "Y", cb = tree_cb("copy_path")},
        {key = "gy", cb = tree_cb("copy_absolute_path")},
        {key = "[c", cb = tree_cb("prev_git_item")},
        {key = "]c", cb = tree_cb("next_git_item")},
        {key = "-", cb = tree_cb("dir_up")},
        {key = "q", cb = tree_cb("close")},
        {key = "g?", cb = tree_cb("toggle_help")}
    }
    require("nvim-tree").setup(
        {
            open_on_setup = false,
            open_on_tab = false,
            auto_close = false,
            diagnostics = {enable = false},
            ignore_ft_on_setup = {"startify", "dashboard"},
            update_focused_file = {disable_netrw = true, hijack_netrw = true, enable = false},
            filters = {
                dotfiles = false,
                custom = {
                    "node_modules",
                    ".cache",
                    ".mypy_cache",
                    ".pytest_cache",
                    ".git",
                    ".hg",
                    ".svn",
                    ".stversions",
                    "__pycache__",
                    ".sass-cache",
                    "*.egg-info",
                    ".DS_Store",
                    "*.pyc"
                }
            },
            view = {width = 30, side = "left", auto_resize = false, mappings = {custom_only = true, list = mappings}}
        })

    -- vim.cmd "au WinClosed * lua require('plugins.nvimtree').on_close()"
    vim.api.nvim_set_keymap("n", "<localleader>e", ":NvimTreeToggle<CR>", {noremap = true, silent = true})
end

return {config = config, on_close = on_close, on_open = on_open}

