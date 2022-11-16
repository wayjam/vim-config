local setup = function()
  local keymap = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  -- General pickers
  keymap("n", "<leader>?", "<cmd>Telescope<CR>", opts)
  keymap("n", "<leader>r", "<cmd>Telescope resume<CR>", opts)
  keymap("n", "<leader>pp", "<cmd>Telescope pickers<CR>", opts)
  keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
  keymap("n", "<leader>rg", "<cmd>Telescope live_grep<CR>", opts)
  keymap("n", "<leader>bf", "<cmd>Telescope buffers<CR>", opts)
  keymap("n", "<leader>jl", "<cmd>Telescope jumplist<CR>", opts)
  keymap("n", "<leader>mk", "<cmd>Telescope marks<CR>", opts)
  keymap("n", "<leader>re", "<cmd>Telescope registers<CR>", opts)
  keymap("n", "<localleader><localleader>", "<cmd>Telescope commands<CR>", opts)

  -- git_commits    git_bcommits   git_branches
  -- git_status     git_stash      git_files
  -- file_browser   tags           fd             autocommands   quickfix
  -- filetypes      commands       man_pages      help_tags      loclist
  -- lsp_workspace_diagnostics     lsp_document_diagnostics

  -- Location-specific find files/directories
  keymap("n", "<localleader>n", '<cmd>lua require"plugins.telescope".pickers.plugin_directories()<CR>', opts)
  keymap("n", "<localleader>w", '<cmd>lua require"plugins.telescope".pickers.notebook()<CR>', opts)

  -- Navigation
  keymap("n", "<localleader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
  keymap("n", "<localleader>gt", '<cmd>lua require"plugins.telescope".pickers.lsp_workspace_symbols_cursor()<CR>', opts)
  keymap("n", "<localleader>gf", '<cmd>lua require"plugins.telescope".pickers.find_files_cursor()<CR>', opts)
  keymap("n", "<localleader>gg", '<cmd>lua require"plugins.telescope".pickers.grep_string_cursor()<CR>', opts)
  keymap("x", "<localleader>gg", '<cmd>lua require"plugins.telescope".pickers.grep_string_visual()<CR>', opts)

  -- LSP related
  keymap("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap("n", "<leader>ca", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("x", "<leader>ca", ":Telescope lsp_range_code_actions<CR>", opts)
  keymap("n", "<leader>sy", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
  keymap("n", "<leader>dsy", "<cmd>Telescope lsp_document_symbols<CR>", opts)
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

  -- Setup Telescope
  -- See telescope.nvim/lua/telescope/config.lua for defaults.
  telescope.setup {
    defaults = {
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
    },
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
    },
  }
end

-- Public functions
return {
  setup = setup,
  config = config,
  config_extension = function(name)
    if name == "project" then require("telescope").load_extension "project" end
  end,
}
