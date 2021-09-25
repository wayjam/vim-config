local utils = require("utils")

local window_width_limit = 80

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand "%:p:h"
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}

local function config()
    local lualine = require("lualine")
    local lsp_status = require("lsp-status")
    local lualine_fileformat = require("lualine.components.fileformat")
    local colors = require("onedark.colors")

    vim.g.qf_disable_statusline = true

    local lspstatus = {
        function()
            if #vim.lsp.buf_get_clients() > 0 then return require("lsp-status").status() end
            return ""
        end,
        padding = {left = 1},
        cond = conditions.hide_in_width
    }
    local diagnostics = {
        "diagnostics",
        sources = {"nvim_lsp"},
        sections = {"error", "warn", "info", "hint"},
        -- all colors are in format #rrggbb
        -- default auto extract from 'Diagnostic', 'LspDiagnosticsDefault', 'Diff'
        -- diagnostics_color = {
        --     error = nil,
        --     warn = nil,
        --     info = nil,
        --     hint = nil
        -- },
        symbols = {
            error = utils.padded_signs("Error"),
            warn = utils.padded_signs("Warning"),
            info = utils.padded_signs("Information"),
            hint = utils.padded_signs("Hint")
        },
        update_in_insert = false -- Update diagnostics in insert mode
    }
    local diff = {
        "diff",
        symbols = {added = "+", modified = "~", removed = "-"},
        diff_color = {added = {fg = colors.green}, modified = {fg = colors.yellow}, removed = {fg = colors.red}},
        cond = conditions.hide_in_width,
        padding = 1
    }
    local branch = {"branch", icon = "", cond = conditions.check_git_workspace}
    local encoding = {"o:encoding", fmt = string.upper, color = {}, cond = conditions.hide_in_width}
    local filetype = {"filetype", cond = conditions.hide_in_width, icon_only = true, padding = {left = 1, right = 1}}
    local filename = {"filename", padding = 0}
    local location = {"location", padding = {left = 1, right = 1}}
    local fileformat = {
        "bo.fileformat",
        fmt = function()
            local format = vim.bo.fileformat
            local icon = lualine_fileformat.icon[format]
            if icon ~= nil then
                return string.upper(icon .. " " .. format)
            else
                return string.upper(format)
            end
        end
    }

    lsp_status.config(
        {
            indicator_separator = "",
            component_separator = "",
            -- indicator_errors = signs.Error,
            -- indicator_warnings = signs.Warning,
            -- indicator_info = signs.Information,
            -- indicator_hint = signs.Hint,
            indicator_ok = "✔",
            status_symbol = "LSP",
            diagnostics = false
        })

    lualine.setup {
        options = {
            theme = "onedark",
            component_separators = "",
            section_separators = {left = "", right = ""},
            disabled_filetypes = {"NvimTree"},
            color = {cterm = "none", gui = "none"}
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {filetype, filename, location},
            lualine_c = {lspstatus, diagnostics},
            lualine_x = {encoding, fileformat},
            lualine_y = {branch, diff},
            lualine_z = {"progress"}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {"filename"},
            lualine_x = {"location"},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {"toggleterm", "nvim-tree", "fugitive"}

    }
end

return {config = config}
