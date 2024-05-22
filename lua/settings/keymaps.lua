local keymap = require("utils").keymap
--- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymappings prefixes, evict entirely for use of plug-ins.
keymap("n", "<Space>", "<Nop>", { noremap = true })
keymap("x", "<Space>", "<Nop>", { noremap = true })
keymap("n", "\\", "<Nop>", { noremap = true })
keymap("x", "\\", "<Nop>", { noremap = true })

-- Quick quit action
keymap("n", "<Leader>q", ":q<CR>", { silent = true })
keymap("n", "<Leader>w", ":w<CR>", { silent = true })
keymap("n", "<localleader>q", ":q<CR>", { silent = true })

-- Fix keybind name for Ctrl+Spacebar
keymap("n", "<Nul>", "<C-Space>", {})
keymap("v", "<Nul>", "<C-Space>", {})

-- Double leader key for toggling visual-line mode
keymap("n", "<Leader><Leader>", "V", { silent = true })
keymap("v", "<Leader><Leader>", "<Esc>", {})
keymap("t", "<Esc>", "<C-\\><C-n>", {})

-- jump
keymap("n", "[g", "<C-O>", {})
keymap("n", "]g", "<C-I>", {})

-- Insert mode shortcut
keymap("i", "<C-j>", "<Down>", {})
keymap("i", "<C-k>", "<Up>", {})
keymap("i", "<C-l>", "<Right>", {})
keymap("i", "<C-h>", "<Left>", {})
keymap("i", "<A-j>", "<Down>", {})
keymap("i", "<A-k>", "<Up>", {})
keymap("i", "<A-h>", "<Left>", {})
keymap("i", "<A-l>", "<Right>", {})

-- Command mode shortcut
keymap("c", "<C-a>", "<Home>", {})
keymap("c", "<C-e>", "<End>", {})
keymap("c", "<C-h>", "<Left>", {})
keymap("c", "<C-l>", "<Right>", {})
keymap("c", "<C-j>", "<Up>", {})
keymap("c", "<C-k>", "<Down>", {})
keymap("c", "<C-d>", "<Del>", {})
keymap("c", "<C-y>", "<C-r>*", {})

-- Macros
keymap("n", "Q", "q", { noremap = true })
keymap("n", "q", "<Nop>", { noremap = true })

-- Toggle pastemode
keymap("n", "<Leader>tp", ":setlocal paste!<CR>", { silent = true })

-- Change current word in a repeatable manner
keymap("n", "<leader>cn", "*``cgn", {})
keymap("n", "<leader>cN", "*``cgN", {})
keymap("v", "<leader>cn", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgn]], { expr = true })
keymap("v", "<leader>cN", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgN]], { expr = true })

-- Duplicate paragraph
keymap("n", "<leader>cp", "yap<S-}>p", {})

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
keymap("n", "<Leader>cd", ":lcd %:p:h<CR>:pwd<CR>", {})

-- Fast saving from all modes
keymap("n", "<Leader>w", ":write<CR>", {})
keymap("v", "<Leader>w", "<Esc>:write<CR>", {})
keymap("n", "<C-s>", ":<C-u>write<CR>", {})
keymap("v", "<C-s>", ":<C-u>write<CR>", {})
keymap("c", "<C-s>", "<C-u>write<CR>", {})

-- Highlight
keymap("n", "<leader>nh", ":nohl<CR>", {})

-- Movement
keymap("n", "<C-d>", "<C-d>zz", {})
keymap("n", "<C-u>", "<C-u>zz", {})
keymap("n", "n", "nzzzv", {})
keymap("n", "N", "Nzzzv", {})

-- Toggle editor's visual effects
keymap("n", "<Leader>ts", ":setlocal spell!<cr>", {})
keymap("n", "<Leader>tn", ":setlocal nonumber!<CR>", {})
keymap("n", "<Leader>tl", ":setlocal nolist!<CR>", {})
keymap("n", "<Leader>th", ":nohlsearch<CR>", {})
keymap("n", "<Leader>tw", ":setlocal wrap! breakindent!<CR>", {})

-- Tabs
keymap("n", "g$", ":tabfirst<CR>", { silent = true })
keymap("n", "g^", ":tablast<CR>", { silent = true })
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
keymap("n", "<Leader>lt", ':exe "tabn " . g:lasttab<CR>', { silent = true })

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
  vim.api.nvim_command "enew"
end)

-- Split current buffer, go to previous window and previous buffer
keymap("n", "<silent> <Leader>sp", ":split<CR>:wincmd p<CR>:e#<CR>", {})
keymap("n", "<silent> <Leader>sv", ":vsplit<CR>:wincmd p<CR>:e#<CR>", {})

-- Buffer
keymap("n", "<silent> <Leader>bf", ":bfirst<CR>", {})
keymap("n", "<silent> <Leader>bl", ":blast<CR>", {})
keymap("n", "<silent> <Leader>bd", ":bd<CR>", {})
keymap("n", "<silent> <Leader>bk", ":bw<CR>", {})
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
keymap("n", "<Leader>cw", [[:silent! keeppatterns %substitute/\s\+$//e<CR>]], { silent = true })

-- Quick substitute within selected area
keymap("x", "sg", [[:s//gc<Left><Left><Left>]], {})

-- Location/quickfix list movement
keymap("n", "]c", [[:lnext<CR>]], {})
keymap("n", "[c", [[:lprev<CR>]], {})
keymap("n", "]q", [[:cnext<CR>]], {})
keymap("n", "[q", [[:cprev<CR>]], {})

-- Drag current line/s vertically and auto-indent
keymap("v", "<Leader>k", [[:m '<-2<CR>gv=gv]], {})
keymap("v", "<Leader>j", [[:m '>+<CR>gv=gv]], {})

-- Useful command
local last_color_column = vim.opt.colorcolumn
local activatedh = false
vim.api.nvim_create_user_command("ColorColumn", function(opts)
  vim.opt.colorcolumn = opts.fargs[1]
  last_color_column = vim.opt.colorcolumn
end, { nargs = 1 })
vim.api.nvim_create_user_command("ColorColumnToggle", function()
  if not activatedh then
    activatedh = true
    vim.opt.colorcolumn = last_color_column
  else
    activatedh = false
    last_color_column = vim.opt.colorcolumn
    vim.opt.colorcolumn = "0"
  end
end, { nargs = 0 })
