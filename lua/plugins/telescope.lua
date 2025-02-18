local setup = function()
  local keymap = require("utils").keymap

  for _, item in ipairs {
    { "n", "<leader>?",  "<cmd>Telescope<CR>",                         "Open Telescope" },
    { "n", "<leader>r",  "<cmd>Telescope resume<CR>",                  "Resume Telescope" },
    { "n", "<leader>pk", "<cmd>Telescope pickers<CR>",                 "Show Telescope Pickers" },
    { "n", "<leader>ff", "<cmd>Telescope find_files<CR>",              "Find Files with Telescope" },
    { "n", "<leader>rg", "<cmd>Telescope live_grep<CR>",               "Live Grep with Telescope" },
    { "n", "<leader>bf", "<cmd>Telescope buffers previewer=false<CR>", "Find Buffers with Telescope" },
    {
      "n",
      "<leader>jl",
      "<cmd>Telescope jumplist<CR>",
      "Navigate Jumplist with Telescope",
    },
    {
      "n",
      "<leader>mk",
      "<cmd>Telescope marks<CR>",
      "Navigate Marks with Telescope",
    },
    {
      "n",
      "<leader>re",
      "<cmd>Telescope registers<CR>",
      "Browse Registers with Telescope",
    },
    { "n", "<localleader><localleader>", "<cmd>Telescope commands<CR>", "Show Telescope Commands" },
    {
      "n",
      "<localleader>/",
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      "Fuzzy Find in Current Buffer with Telescope",
    },
    {
      { "n", "x" },
      "<localleader>gg",
      "<cmd>Telescope grep_string<CR>",
      "Grep String under Cursor with Telescope",
    },
    {
      "n",
      "<leader>sy",
      function() require("telescope.builtin").lsp_document_symbols() end,
      "Document Symbols",
    },
    {

      "n",
      "<leader>dsy",
      function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
      "Workspace Symbols",
    },
    {
      "n",
      "gr",
      function() require("telescope.builtin").lsp_references() end,
      "Go to References",
    },
  } do
    local mode, lhs, rhs, desc = unpack(item)
    keymap(mode, lhs, rhs, {
      desc = desc,
      noremap = true,
      silent = true,
    })
  end
end

local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
  require("telescope.actions").send_to_qflist(prompt_bufnr)
  require("user").qflist.open()
end

function myactions.smart_send_to_qflist(prompt_bufnr)
  require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
  require("user").qflist.open()
end

function myactions.page_up(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, -5) end

function myactions.page_down(prompt_bufnr) require("telescope.actions.set").shift_selection(prompt_bufnr, 5) end

function myactions.change_directory(prompt_bufnr)
  local entry = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  vim.cmd("lcd " .. entry.path)
end

local function config()
  local telescope = require "telescope"
  local actions = require "telescope.actions"

  local defaults = {
    sorting_strategy = "ascending",
    selection_strategy = "closest",
    scroll_strategy = "cycle",
    cache_picker = { num_pickers = 3, limit_entries = 300 },
    prompt_prefix = " ",
    selection_caret = "▷ ",
    set_env = { COLORTERM = "truecolor" },
    entry_prefix = "  ",
    initial_mode = "insert",
    path_display = { "absolute" },
    preview = {
      treesitter = false,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
    },
    file_ignore_patterns = {
      "^./.git/",
      "^node_modules/",
    },
    layout_strategy = "flex",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    winblend = 0,
    color_devicons = true,
    use_less = true,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      i = {
        ["jj"] = { "<Esc>", type = "command" },

        ["<Tab>"] = actions.move_selection_next,
        ["<S-Tab>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-u>"] = myactions.page_up,
        ["<C-d>"] = myactions.page_down,

        ["<C-q>"] = myactions.smart_send_to_qflist,
        -- ['<C-l'] = actions.complete_tag,

        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,

        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,
      },

      n = {
        ["q"] = actions.close,
        ["<Esc>"] = actions.close,

        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-u>"] = myactions.page_up,
        ["<C-d>"] = myactions.page_down,

        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,

        ["<C-down>"] = actions.cycle_history_next,
        ["<C-up>"] = actions.cycle_history_prev,

        ["*"] = actions.toggle_all,
        ["u"] = actions.drop_all,
        ["J"] = actions.toggle_selection + actions.move_selection_next,
        ["K"] = actions.toggle_selection + actions.move_selection_previous,
        ["<Tab>"] = {
          actions.toggle_selection,
          type = "action",
          -- See https://github.com/nvim-telescope/telescope.nvim/pull/890
          keymap_opts = { nowait = true },
        },

        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["sv"] = actions.select_horizontal,
        ["sp"] = actions.select_vertical,
        ["st"] = actions.select_tab,

        ["w"] = myactions.smart_send_to_qflist,
        ["e"] = myactions.send_to_qflist,

        ["!"] = actions.edit_command_line,
      },
    },
  }

  -- Setup Telescope
  -- See telescope.nvim/lua/telescope/config.lua for defaults.
  telescope.setup {
    defaults = defaults,
    pickers = {
      buffers = {
        theme = "dropdown",
        previewer = false,
        sort_lastused = true,
        sort_mru = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        mappings = { n = { ["dd"] = actions.delete_buffer } },
      },
      find_files = {
        theme = "dropdown",
        previewer = false,
        find_command = { "rg", "--smart-case", "--hidden", "--no-ignore-vcs", "--glob", "!.git", "--files" },
      },
    },
    extensions = {
      project = {
        theme = "dropdown",
        order_by = "asc",
        sync_with_nvim_tree = true, -- default false
      },
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  }
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      event = "BufRead",
      config = function() require("plugins.telescope").config_extension "fzf" end,
    },
    {
      "nvim-telescope/telescope-project.nvim",
      config = function() require("plugins.telescope").config_extension "project" end,
    },
  },
  init = setup,
  config = config,
  config_extension = function(name)
    if name == "project" then require("telescope").load_extension "project" end
    if name == "fzf" then require("telescope").load_extension "fzf" end
    if name == "dap" then require("telescope").load_extension "dap" end
  end,
}
