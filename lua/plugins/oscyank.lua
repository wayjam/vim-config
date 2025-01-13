-- drop this plugin, sicne `10.0` https://github.com/neovim/neovim/pull/25872
return {
  "ojroques/nvim-osc52",
  event = "BufReadPre",
  config = function()
    local keymap = require("utils").keymap
    local osc52 = require "osc52"
    osc52.setup {
      max_length = 0, -- Maximum length of selection (0 for no limit)
      silent = false, -- Disable message on successful copy
      trim = false,   -- Trim text before copy
    }

    local function copy(lines, _) osc52.copy(table.concat(lines, "\n")) end

    local function paste() return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" } end

    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste, ["*"] = paste },
    }
    -- Now the '+' register will copy to system clipboard using OSC52
    keymap("n", "<leader>c", '"+y')
    keymap("n", "<leader>cc", '"+yy')

    -- Auto copy from unnamed register to osc52
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then osc52.copy_register "" end
      end,
    })
  end,
}
