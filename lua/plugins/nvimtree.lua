local function on_open() end

local function on_close() end

local function change_tree_dir(dir)
  local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
  if lib_status_ok then lib.change_dir(dir) end
end

local function config()
  local mappings = {
    { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
    { key = { "<2-RightMouse>", "<C-]>" }, action = "cd" },
    { key = "<C-v>", action = "vsplit" },
    { key = "<C-x>", action = "split" },
    { key = "<C-t>", action = "tabnew" },
    { key = "<", action = "prev_sibling" },
    { key = ">", action = "next_sibling" },
    { key = "P", action = "parent_node" },
    { key = "<BS>", action = "close_node" },
    { key = "<S-CR>", action = "close_node" },
    { key = "<Tab>", action = "preview" },
    { key = "K", action = "first_sibling" },
    { key = "J", action = "last_sibling" },
    { key = "H", action = "toggle_dotfiles" },
    { key = "I", action = "toggle_git_ignored" },
    { key = "<C-r>", action = "refresh" },
    { key = "N", action = "create" },
    { key = "rm", action = "remove" },
    { key = "rn", action = "rename" },
    { key = "RN", action = "full_rename" },
    { key = "X", action = "cut" },
    { key = "C", action = "copy" },
    { key = "P", action = "paste" },
    { key = "y", action = "copy_name" },
    { key = "Y", action = "copy_path" },
    { key = "gy", action = "copy_absolute_path" },
    { key = "[c", action = "prev_git_item" },
    { key = "]c", action = "next_git_item" },
    { key = "-", action = "dir_up" },
    { key = "q", action = "close" },
    { key = "g?", action = "toggle_help" },
  }
  require("nvim-tree").setup {
    open_on_setup = false,
    open_on_tab = false,
    diagnostics = { enable = false },
    ignore_ft_on_setup = { "startify", "dashboard" },
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    filters = {
      dotfiles = true,
      custom = {
        "^\\.git$",
        "node_modules",
        ".mypy_cache",
        ".pytest_cache",
        ".hg",
        ".svn",
        ".stversions",
        "__pycache__",
        ".sass-cache",
        "*.egg-info",
        ".DS_Store",
        "*.pyc",
      },
      exclude = { ".gitignore", ".env", ".pylintrc", ".eslintrc", ".prettierrc" },
    },
    view = { width = 30, side = "left", signcolumn = "no", mappings = { custom_only = true, list = mappings } },
    renderer = {
      highlight_git = false,
      root_folder_modifier = ":~",
      icons = {
        show = { git = true, folder = true, file = true, folder_arrow = true },
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "✦",
            staged = "✔",
            unmerged = "",
            renamed = "≈",
            deleted = "×",
            untracked = "+",
            ignored = "⊙",
          },
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    },
  }

  -- vim.cmd "au WinClosed * lua require('plugins.nvimtree').on_close()"
  vim.api.nvim_set_keymap("n", "<localleader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
end

return { config = config, on_close = on_close, on_open = on_open }
