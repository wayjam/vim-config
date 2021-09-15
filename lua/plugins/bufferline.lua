local function config()
    require("bufferline").setup({
        options = {
            numbers = function(opts)
                return string.format('%s.', opts.ordinal)
            end,
            -- close_command = "bdelete! %d",
            -- left_mouse_command = "buffer %d",
            right_mouse_command = nil,
            middle_mouse_command = nil,
            indicator_icon = "▎",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 18,
            max_prefix_length = 15,
            tab_size = 10,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
                }
            },
            diagnostics = false,
            custom_filter = function(bufnr)
                -- if the result is false, this buffer will be shown, otherwise, this
                -- buffer will be hidden.

                -- filter out filetypes you don't want to see
                local exclude_ft = {"qf", "fugitive", "git", "NvimTree"}
                local cur_ft = vim.bo[bufnr].filetype
                local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

                if should_filter then return false end

                return true
            end,
            show_buffer_icons = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = false,
            persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            separator_style = "thick",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
        }
    })
end

return {config = config}
