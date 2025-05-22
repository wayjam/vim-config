return {
  "tpope/vim-fugitive",
  enabled = vim.fn.executable "git" == 1,
  cmd = {
    "Gvdiffsplit",
    "Gdiffsplit",
    "Gedit",
    "Gsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GRename",
    "GDelete",
    "GRemove",
    "GBrowse",
    "Git",
    "G",
  },
  keys = {
    {
      "<leader>Gd",
      "<cmd>Gdiff<CR>",
      desc = "Git diff",
    },
    {
      "<leader>Gs",
      "<cmd>Git status<CR>",
      desc = "Git status",
    },
    {
      "<leader>GC",
      "<cmd>Git commit<CR>",
      desc = "Git commit",
    },
    {
      "<leader>Gb",
      "<cmd>Git blame<CR>",
      desc = "Git blame",
    },
    {
      "<leader>Gp",
      "<cmd>Git push<CR>",
      desc = "Git push",
    },
    {
      "<leader>Gl",
      "<cmd>Git log<CR>",
      desc = "Git log",
    },
    -- {
    --   "<leader>Gr",
    --   "<cmd>Gread<CR>",
    --   desc = "Git read",
    -- },
    -- {
    --   "<leader>Gw",
    --   "<cmd>Git write<CR>",
    --   desc = "Git write",
    -- },
    -- {
    --   "<leader>Ge",
    --   "<cmd>Git edit<CR>",
    --   desc = "Git edit",
    -- },
    {
      "<leader>GF",
      "<cmd>diffget //2<CR>",
      desc = "Git Use left content",
    },
    {
      "<leader>GJ",
      "<cmd>diffget //3<CR>",
      desc = "Git use right content",
    },
    {
      "<leader>Gi",
      "<cmd>Git add -p %<CR>",
      desc = "Git add current file",
    },
  },
}
