return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  opts = { delay = 200 },
  config = function()
    local keymap = require("utils").keymap
    keymap("n", "<M-n>", function() require("illuminate").goto_next_reference() end, { desc = "Next reference" })
    keymap("n", "<M-p>", function() require("illuminate").goto_prev_reference() end, { desc = "Prev reference" })

    require("illuminate").configure {
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 200,
      filetypes_denylist = {
        "mason",
        "harpoon",
        "DressingInput",
        "NeogitCommitMessage",
        "qf",
        "dirvish",
        "oil",
        "minifiles",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "NeogitStatus",
        "Trouble",
        "netrw",
        "lir",
        "DiffviewFiles",
        "Outline",
        "Jaq",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },
      filetypes_allowlist = {},
      modes_denylist = {},
      modes_allowlist = {},
      providers_regex_syntax_denylist = {},
      providers_regex_syntax_allowlist = {},
      large_file_cutoff = 5000,
    }

    local group = "illuminate_augroup"
    vim.api.nvim_create_augroup(group, { clear = true })
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      group = group,
      callback = function()
        vim.cmd "hi link illuminatedWord LspReferenceText"
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
      end,
    })
  end,
}
