local function config()
  local utils = require "utils"

  require("neo-tree").setup {
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 0, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = utils.icons["FolderClosed"],
        folder_open = utils.icons["FolderOpen"],
        folder_empty = utils.icons["FolderEmpty"],
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = false,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added = utils.git_symbols["Added"],
          modified = utils.git_symbols["Modified"],
          -- Status type
          unstaged = utils.git_symbols["Unstaged"],
          staged = utils.git_symbols["Staged"],
          conflict = utils.git_symbols["Conflict"],
          renamed = utils.git_symbols["Renamed"],
          deleted = utils.git_symbols["Deleted"],
          untracked = utils.git_symbols["Untracked"],
          ignored = utils.git_symbols["Ignored"],
        },
      },
    },
    use_default_mappings = false,
    window = {
      position = "left",
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["<esc>"] = "revert_preview",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["l"] = "focus_preview",
        ["<C-x>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
        ["<C-S>"] = "split_with_window_picker",
        ["<C-s>"] = "vsplit_with_window_picker",
        ["<C-t>"] = "open_tabnew",
        -- ["<cr>"] = "open_drop",
        -- ["<C-T>"] = "open_tab_drop",
        ["w"] = "open_with_window_picker",
        --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["a"] = {
          "add",
          -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          },
        },
        ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
        ["rm"] = "delete",
        ["rn"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["cp"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
        -- ["c"] = {
        --  "copy",
        --  config = {
        --    show_path = "none" -- "none", "relative", "absolute"
        --  }
        --}
        ["mv"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ["q"] = "close_window",
        ["<C-r>"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "__pycache__",
          "node_modules",
          ".hg",
          ".svn",
          ".stversions",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
          "^\\.git$",
          "*.egg-info",
          "*.pyc",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          ".gitignore",
          ".dockerignore",
          ".env",
          ".pylintrc",
          ".eslintrc",
          ".prettierrc",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = false, -- This will find and focus the file in the active buffer every
      },
      -- time the current file is changed while the tree is open.
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = "open_current",
      -- "open_default", netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current", netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled", netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["f"] = "filter_on_submit",
          ["<c-c>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
        },
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every
      },
      -- time the current file is changed while the tree is open.
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },
  }

  if utils.has_plugin "onedark" then
    local util = require "onedark.util"
    local msg_color = "#" .. utils.dec_to_hex(vim.api.nvim_get_hl(0, { name = "NeoTreeMessage" }).fg, 6)
    vim.api.nvim_set_hl(0, "NeoTreeMessage", { fg = util.lighten(msg_color, 0.9) })
    local sep_color = "#" .. utils.dec_to_hex(vim.api.nvim_get_hl(0, { name = "NeoTreeWinSeparator" }).fg, 6)
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = util.lighten(sep_color, 0.9) })
  end
end

local function init()
  local group = vim.api.nvim_create_augroup("neotree_start", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Open Neotree automatically",
    group = group,
    callback = function()
      local buffer_path = vim.api.nvim_buf_get_name(0)
      local fs_info = vim.loop.fs_stat(buffer_path)
      local is_directory = fs_info ~= nil and fs_info.type == "directory"
      local is_empty_buffer = buffer_path == ""

      if not (is_empty_buffer or is_directory) then return end

      local dir
      if is_empty_buffer then
        dir = vim.fn.getcwd()
      elseif is_directory then
        dir = buffer_path
      end

      vim.cmd("Neotree current dir=" .. dir)
      vim.api.nvim_clear_autocmds { group = "neotree_start" }
    end,
  })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<localleader>e", "<cmd>Neotree reveal toggle<cr>", desc = "NeoTree" },
  },
  -- deactivate = function() vim.cmd [[Neotree close]] end,
  config = config,
  init = init,
}
