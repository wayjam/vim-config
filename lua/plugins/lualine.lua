local utils = require "utils"

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand "%:t") ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}
local diff = {
  "diff",
  symbols = { added = "+", modified = "~", removed = "-" },
  cond = conditions.hide_in_width,
  padding = 1,
}
local branch = { "branch", icon = "", cond = conditions.check_git_workspace }
local encoding = { "o:encoding", fmt = string.upper, color = {}, cond = conditions.hide_in_width }
local filetype = { "filetype", cond = conditions.hide_in_width, icon_only = false, padding = { left = 1, right = 0 } }
local filename = { "filename", padding = 1, file_status = true, path = 1, shorting_target = 64 }
local location = { "location", padding = { left = 0, right = 1 } }
local fileformat = {
  "fileformat",
  fmt = function(str) return str .. " " .. string.upper(vim.bo.fileformat) end,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic", "nvim_lsp" },
  sections = { "error", "warn", "info", "hint" },
  -- all colors are in format #rrggbb
  -- default auto extract from 'Diagnostic', 'LspDiagnosticsDefault', 'Diff'
  -- diagnostics_color = {
  --     error = nil,
  --     warn = nil,
  --     info = nil,
  --     hint = nil
  -- },
  symbols = {
    error = utils.padded_signs "Error",
    warn = utils.padded_signs "Warn",
    info = utils.padded_signs "Info",
    hint = utils.padded_signs "Hint",
  },
  colored = true,
  update_in_insert = false, -- Update diagnostics in insert mode
  always_visible = false,
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "NvimTree", "neo-tree" },
      color = { cterm = "none", gui = "none" },
    },
    extensions = { "toggleterm", "fugitive" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { filetype, filename, location },
      lualine_c = { diagnostics },
      lualine_x = { encoding, fileformat },
      lualine_y = { branch, diff },
      lualine_z = { "progress" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = { location },
      lualine_y = {},
      lualine_z = {},
    },
  },
  config = function(_, opts)
    vim.g.qf_disable_statusline = true

    require("lualine").setup(opts)
  end,
}
