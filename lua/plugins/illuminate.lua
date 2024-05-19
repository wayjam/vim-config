return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  opts = { delay = 200 },
  config = function()
    local illuminate = require "illuminate"
    vim.g.Illuminate_ftblacklist = { "NvimTree" }
    vim.api.nvim_set_keymap(
      "n",
      "<a-n>",
      '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
      { noremap = true }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<a-p>",
      '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
      { noremap = true }
    )

    illuminate.configure {
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 200,
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "neogitstatus",
        "Trouble",
        "lir",
        "Outline",
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
