local img_previewer ---@type string[]?
for _, v in ipairs {
  { cmd = "ueberzug", args = {} },
  { cmd = "chafa", args = { "{file}", "--format=symbols" } },
  { cmd = "viu", args = { "-b" } },
} do
  if vim.fn.executable(v.cmd) == 1 then
    img_previewer = vim.list_extend({ v.cmd }, v.args)
    break
  end
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  config = function(_, opts)
    local fzf = require "fzf-lua"
    local config = fzf.config
    local actions = fzf.actions

    opts = opts
      or {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s) return "TroubleIcon" .. s end,
            symbol_fmt = function(s) return s:lower() .. "\t" end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable "delta" == 1 and "codeaction_native" or nil,
          },
        },
      }

    -- Quickfix
    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

    -- Trouble
    -- if require("utils").has_plugin "trouble.nvim" then
    --   config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
    -- end
    -- config.defaults.actions.files["ctrl-t"] = {
    --   desc = "Open",
    --   fn = function(selected, opts)
    --     actions.file_tabedit(selected, opts)
    --     if require("utils").has_plugin "trouble.nvim" then
    --       require("trouble.sources.fzf").actions.open.fn(selected, opts)
    --     end
    --   end,
    -- }

    fzf.setup(opts)
  end,
  keys = {
    {
      "<c-j>",
      "<c-j>",
      ft = "fzf",
      mode = "t",
      nowait = true,
    },
    {
      "<c-k>",
      "<c-k>",
      ft = "fzf",
      mode = "t",
      nowait = true,
    },
    { "<leader>?", "<cmd>FzfLua<cr>", desc = "Fzf" },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<localleader>?", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    {
      "<leader>fF",
      function() require("fzf-lua").files { root = false } end,
      desc = "Find Files (cwd)",
    },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    -- git
    { "<leader>Gc", "<cmd>FzfLua git_commits<CR>", desc = "Git Commits" },
    { "<leader>Gs", "<cmd>FzfLua git_status<CR>", desc = "Git Status" },
    { "<leader>GB", "<cmd>FzfLua git_branches<CR>", desc = "Git Branches" },
    -- search
    { "<leader>rs", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    {
      "<leader>sG",
      function() require("fzf-lua").live_grep { root = false } end,
      desc = "Grep (cwd)",
    },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
    { "<leader>sW", function() require("fzf-lua").grep_cword { root = false } end, desc = "Word (cwd)" },
    {
      "<leader>sw",
      function() require("fzf-lua").grep_visual() end,
      mode = "v",
      desc = "Selection (Root Dir)",
    },
    {
      "<leader>sW",
      function() require("fzf-lua").grep_visual { root = false } end,
      mode = "v",
      desc = "Selection (cwd)",
    },
    {
      "<leader>ss",
      function() require("fzf-lua").lsp_document_symbols() end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function() require("fzf-lua").lsp_live_workspace_symbols() end,
      desc = "Goto Symbol (Workspace)",
    },
    {
      "<leader>gi",
      function() require("fzf-lua").lsp_implementations() end,
      desc = "Goto Implementations",
    },
    {
      "gr",
      function() require("fzf-lua").lsp_references() end,
      desc = "Goto References",
    },
  },
}
