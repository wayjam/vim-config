local keymap = require("utils").keymap
--- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymappings prefixes, evict entirely for use of plug-ins.
keymap({ "n", "x" }, "<Space>", "<Nop>", { noremap = true })
keymap({ "n", "x" }, "\\", "<Nop>", { noremap = true })

-- Quick quit action
local quit_buf_options = {
  ["neo-tree"] = {
    ft = "neo-tree",
    close = function()
      require("neo-tree.command").execute {
        action = "close",
      }
    end,
  },
}
local file_manager = "neo-tree"
local function quit_buf()
  local opts = quit_buf_options[file_manager]

  if require("utils").has_plugin(file_manager) then
    local current_tabpage = vim.api.nvim_get_current_tabpage()
    local windows = vim.api.nvim_tabpage_list_wins(current_tabpage)

    --- left 2 window(current and file manager), auto close file manager
    local should_close = false
    if #windows == 2 then
      for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("filetype", {
          buf = buf,
        }) == opts.ft then
          should_close = true
          break
        end
      end
    end

    if should_close then opts.close() end
  end

  vim.cmd "q"
end

keymap("n", "<Leader>q", quit_buf, { silent = true, desc = "Quit" })
keymap("n", "<localleader>q", quit_buf, { silent = true, desc = "Quit" })

-- Fix keybind name for Ctrl+Spacebar
keymap({ "n", "v" }, "<Nul>", "<C-Space>", {})

-- Double leader key for toggling visual-line mode
keymap("n", "<Leader><Leader>", "V", { silent = true, desc = "Visual mode" })
keymap("v", "<Leader><Leader>", "<Esc>", { desc = "Back to normal mode" })
keymap("t", "<Esc>", "<C-\\><C-n>", {})

-- jump
keymap("n", "[g", "<C-O>", {})
keymap("n", "]g", "<C-I>", {})

-- Insert mode shortcut
keymap("i", "<A-j>", "<Down>", {})
keymap("i", "<A-k>", "<Up>", {})
keymap("i", "<A-h>", "<Left>", {})
keymap("i", "<A-l>", "<Right>", {})

-- Command mode shortcut
keymap("c", "<C-a>", "<Home>", {})
keymap("c", "<C-e>", "<End>", {})
keymap("c", "<C-d>", "<Del>", {})
keymap("c", "<C-y>", "<C-r>*", {})
keymap("c", "<A-h>", "<Left>", {})
keymap("c", "<A-l>", "<Right>", {})
keymap("c", "<A-j>", "<Up>", {})
keymap("c", "<A-k>", "<Down>", {})

-- Macros
keymap("n", "Q", "q", { noremap = true })
keymap("n", "q", "<Nop>", { noremap = true })

-- Toggle pastemode
keymap("n", "<Leader>tp", ":setlocal paste!<CR>", { silent = true, desc = "Toggle paste mode" })

-- Change current word in a repeatable manner
keymap("n", "<leader>cn", "*``cgn", {})
keymap("n", "<leader>cN", "*``cgN", {})
keymap("v", "<leader>cn", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgn]], { expr = true })
keymap("v", "<leader>cN", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgN]], { expr = true })

-- Duplicate paragraph
keymap("n", "<leader>cp", "yap<S-}>p", { desc = "Duplicate paragraph" })

-- Start new line from any cursor position in insert-mode
keymap("i", "<S-Return>", "<C-o>o", {})

-- Global niceties
-- Start an external command with a single bang
keymap("n", "!", ":", {})

-- Allow misspellings
vim.cmd [[
	cnoreabbrev Wq wq
	cnoreabbrev WQ wq
	cnoreabbrev Qa qa
	cnoreabbrev Bd bd
	cnoreabbrev bD bd
]]

vim.cmd [[
  nnoremap zl z5l
  nnoremap zh z5h
]]

-- Select blocks after indenting in visual/select mode
keymap("x", "<", "<gv", {})
keymap("x", ">", ">gv|", {})

-- Switch to the directory of the opened buffer in current window
keymap("n", "<Leader>cd", ":lcd %:p:h<CR>:pwd<CR>", { desc = "Switch dir to current buffer" })

-- Fast saving from all modes
keymap("n", "<Leader>w", ":write<CR>", { desc = "Save" })
keymap("v", "<Leader>w", "<Esc>:write<CR>", { desc = "Save" })
keymap("n", "<C-s>", ":<C-u>write<CR>", {})
keymap("v", "<C-s>", ":<C-u>write<CR>", {})
keymap("c", "<C-s>", "<C-u>write<CR>", {})

-- Highlight
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Disable search highlight" })

-- Movement
keymap("n", "<C-d>", "<C-d>zz", {})
keymap("n", "<C-u>", "<C-u>zz", {})
keymap("n", "n", "nzzzv", {})
keymap("n", "N", "Nzzzv", {})

-- Toggle editor's visual effects
keymap("n", "<Leader>ts", ":setlocal spell!<cr>", { desc = "Enable spell checking" })
keymap("n", "<Leader>tn", ":setlocal nonumber!<CR>", { desc = "No number" })
keymap("n", "<Leader>tl", ":setlocal nolist!<CR>", { desc = "No list" })
keymap("n", "<Leader>tw", ":setlocal wrap! breakindent!<CR>", { desc = "Wrap breakindent" })

-- Tabs
keymap("n", "g0", ":tabfirst<CR>", { silent = true })
keymap("n", "g$", ":tablast<CR>", { silent = true })
keymap("n", "<A-j>", ":tabnext<CR>", { silent = true })
keymap("n", "<A-k>", ":tabprevious<CR>", { silent = true })
keymap("n", "]t", ":tabnext<CR>", { silent = true })
keymap("n", "[t", ":tabprevious<CR>", { silent = true })

for i = 1, 9 do
  -- <Leader>[1-9] move to window [1-9]
  keymap("n", "<Leader>" .. i, ":wincmd " .. i .. "w<CR>", { silent = true })
  -- <Leader><leader>[1-9] move to tab [1-9]
  keymap("n", "<Leader><Leader>" .. i, ":" .. i .. "tabnext<CR>", { silent = true })
  -- <Leader>b[1-9] move to buffer [1-9]
  keymap("n", "<Leader>b" .. i, ":b" .. i .. "<CR>", { silent = true })
end

if not vim.g.lasttab then vim.g.lasttab = 1 end
keymap("n", "<Leader>lt", ':exe "tabn " . g:lasttab<CR>', { silent = true, desc = "Last tab" })

-- Windows and buffers
keymap("n", "<silent> [Window]v", ":split<CR>", {})
keymap("n", "<silent> [Window]g", ":vsplit<CR>", {})
keymap("n", "<silent> [Window]t", ":tabnew<CR>", {})
keymap("n", "<silent> [Window]o", ":only<CR>", {})
keymap("n", "<silent> [Window]b", ":b#<CR>", {})
keymap("n", "<silent> [Window]c", ":close<CR>", {})
keymap("n", "<silent> [Window]x", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_set_current_tabpage(tabnr)
  vim.api.nvim_command "new"
end)

-- Buffer
keymap("n", "<silent> <Leader>b0", ":bfirst<CR>", { desc = "First buffer" })
keymap("n", "<silent> <Leader>b$", ":blast<CR>", { desc = "Last buffer" })
keymap("n", "]b", ":bnext<CR>", {})
keymap("n", "[b", ":bprev<CR>", {})

-- Window control
keymap("n", "<A-Up>", ":resize -2<CR>", {})
keymap("n", "<A-Down>", ":resize +2<CR>", {})
keymap("n", "<A-Left>", ":vertical resize -2<CR>", {})
keymap("n", "<A-Right>", ":vertical resize +2<CR>", {})
keymap("n", "<silent><C-w>z", ":vert resize<CR>:resize<CR>:normal! ze<CR>", {})

-- Window
keymap("n", "<C-J>", "<C-W>j", {})
keymap("n", "<C-K>", "<C-W>k", {})
keymap("n", "<C-L>", "<C-W>l", {})
keymap("n", "<C-H>", "<C-W>h", {})

-- Terminal Window
keymap("t", "<C-J>", "<cmd>wincmd j<CR>", {})
keymap("t", "<C-K>", "<cmd>wincmd k<CR>", {})
keymap("t", "<C-H>", "<cmd>wincmd h<CR>", {})
keymap("t", "<C-L>", "<cmd>wincmd l<CR>", {})

-- Remove spaces at the end of lines
keymap(
  "n",
  "<Leader>cw",
  [[:silent! keeppatterns %substitute/\s\+$//e<CR>]],
  { silent = true, desc = "Remove spaces at the end of lines" }
)

-- Quick substitute within selected area
keymap("x", "sg", [[:s//gc<Left><Left><Left>]], {})

-- Location/quickfix list movement
keymap("n", "]c", [[:lnext<CR>]], {})
keymap("n", "[c", [[:lprev<CR>]], {})
keymap("n", "]q", [[:cnext<CR>]], {})
keymap("n", "[q", [[:cprev<CR>]], {})

-- Drag current line/s vertically and auto-indent
keymap("v", "<Leader>k", [[:m '<-2<CR>gv=gv]], { desc = "Drag current selection up" })
keymap("v", "<Leader>j", [[:m '>+<CR>gv=gv]], { desc = "Drag current selection down" })

-- Useful command
local last_color_column = vim.opt.colorcolumn
local activatedh = false
vim.api.nvim_create_user_command("ColorColumn", function(opts)
  vim.opt.colorcolumn = opts.fargs[1]
  last_color_column = vim.opt.colorcolumn
end, { nargs = 1 })
vim.api.nvim_create_user_command("ToggleColorColumn", function()
  if not activatedh then
    activatedh = true
    vim.opt.colorcolumn = last_color_column
  else
    activatedh = false
    last_color_column = vim.opt.colorcolumn
    vim.opt.colorcolumn = "0"
  end
end, { nargs = 0 })
