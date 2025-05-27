return {
  "nanozuki/tabby.nvim",
  event = "UIEnter",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local theme = {
      fill = "TabLineFill",
      head = "TabLine",
      current_tab = "TabLineSel",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
    }

    local tab_name = function(tab)
      local api = require "tabby.module.api"
      local cur_win = api.get_tab_current_win(tab.id)
      if api.is_float_win(cur_win) then return "[Floating]" end
      local current_bufnr = vim.fn.getwininfo(cur_win)[1].bufnr
      local current_bufinfo = vim.fn.getbufinfo(current_bufnr)[1]
      local current_buf_name = vim.fn.fnamemodify(current_bufinfo.name, ":t")

      if string.find(current_buf_name, "NvimTree") then return "[File Explorer]" end
      if string.find(current_buf_name, "neo-tree") ~= nil then return "[File Explorer]" end
      if current_buf_name == "NeogitStatus" then return "[Neogit]" end
      if current_buf_name == "" then return "[Empty]" end

      return current_buf_name
    end

    local tab_count = function()
      local num_tabs = #vim.api.nvim_list_tabpages()

      if num_tabs > 1 then
        local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
        return tabpage_number .. "/" .. tostring(num_tabs)
      end
    end

    require("tabby").setup {
      line = function(line)
        return {
          {
            { " 󰓩  ", hl = theme.head },
            { tab_count(), hl = theme.head },
            line.sep(" ", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab_name(tab),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          hl = theme.fill,
        }
      end,
      option = { theme = theme }, -- setup modules' option,
    }
  end,
}
