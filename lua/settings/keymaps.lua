--- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymappings prefixes, evict entirely for use of plug-ins.
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("x", "<Space>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "\\", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("x", "\\", "<Nop>", { noremap = true })

-- Quick quit action
vim.api.nvim_set_keymap("n", "<Leader>q", ":q<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>w", ":w<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<localleader>q", ":q<CR>", { silent = true })

-- Fix keybind name for Ctrl+Spacebar
vim.api.nvim_set_keymap("n", "<Nul>", "<C-Space>", {})
vim.api.nvim_set_keymap("v", "<Nul>", "<C-Space>", {})

-- Double leader key for toggling visual-line mode
vim.api.nvim_set_keymap("n", "<Leader><Leader>", "V", { silent = true })
vim.api.nvim_set_keymap("v", "<Leader><Leader>", "<Esc>", {})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})

-- jump
vim.api.nvim_set_keymap("n", "[g", "<C-O>", {})
vim.api.nvim_set_keymap("n", "]g", "<C-I>", {})

-- Insert mode shortcut
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", {})
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", {})
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("i", "<A-j>", "<Down>", {})
vim.api.nvim_set_keymap("i", "<A-k>", "<Up>", {})
vim.api.nvim_set_keymap("i", "<A-h>", "<Left>", {})
vim.api.nvim_set_keymap("i", "<A-l>", "<Right>", {})

-- Command mode shortcut
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", {})
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", {})
vim.api.nvim_set_keymap("c", "<C-h>", "<Left>", {})
vim.api.nvim_set_keymap("c", "<C-l>", "<Right>", {})
vim.api.nvim_set_keymap("c", "<C-j>", "<Up>", {})
vim.api.nvim_set_keymap("c", "<C-k>", "<Down>", {})
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", {})
vim.api.nvim_set_keymap("c", "<C-y>", "<C-r>*", {})

-- Macros
vim.api.nvim_set_keymap("n", "Q", "q", { noremap = true })
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true })

-- Toggle pastemode
vim.api.nvim_set_keymap("n", "<Leader>tp", ":setlocal paste!<CR>", { silent = true })

-- Change current word in a repeatable manner
vim.api.nvim_set_keymap("n", "<leader>cn", "*``cgn", {})
vim.api.nvim_set_keymap("n", "<leader>cN", "*``cgN", {})
vim.api.nvim_set_keymap("v", "<leader>cn", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgn]], { expr = true })
vim.api.nvim_set_keymap("v", "<leader>cN", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgN]], { expr = true })

-- Duplicate paragraph
vim.api.nvim_set_keymap("n", "<leader>cp", "yap<S-}>p", {})

-- Start new line from any cursor position in insert-mode
vim.api.nvim_set_keymap("i", "<S-Return>", "<C-o>o", {})

-- Global niceties
-- Start an external command with a single bang
vim.api.nvim_set_keymap("n", "!", ":", {})

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
vim.api.nvim_set_keymap("x", "<", "<gv", {})
vim.api.nvim_set_keymap("x", ">", ">gv|", {})

-- Switch to the directory of the opened buffer in current window
vim.api.nvim_set_keymap("n", "<Leader>cd", ":lcd %:p:h<CR>:pwd<CR>", {})

-- Fast saving from all modes
vim.api.nvim_set_keymap("n", "<Leader>w", ":write<CR>", {})
vim.api.nvim_set_keymap("v", "<Leader>w", "<Esc>:write<CR>", {})
vim.api.nvim_set_keymap("n", "<C-s>", ":<C-u>write<CR>", {})
vim.api.nvim_set_keymap("v", "<C-s>", ":<C-u>write<CR>", {})
vim.api.nvim_set_keymap("c", "<C-s>", "<C-u>write<CR>", {})

-- Highlight
vim.api.nvim_set_keymap("n", "<leader>nh", ":nohl<CR>", {})

-- Movement
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", {})
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", {})
vim.api.nvim_set_keymap("n", "n", "nzzzv", {})
vim.api.nvim_set_keymap("n", "N", "Nzzzv", {})

-- Toggle editor's visual effects
vim.api.nvim_set_keymap("n", "<Leader>ts", ":setlocal spell!<cr>", {})
vim.api.nvim_set_keymap("n", "<Leader>tn", ":setlocal nonumber!<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>tl", ":setlocal nolist!<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>th", ":nohlsearch<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>tw", ":setlocal wrap! breakindent!<CR>", {})

-- Tabs
vim.api.nvim_set_keymap("n", "g$", ":tabfirst<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "g^", ":tablast<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", ":tabprevious<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "]t", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "[t", ":tabprevious<CR>", { silent = true })

for i = 1, 9 do
  -- <Leader>[1-9] move to window [1-9]
  vim.api.nvim_set_keymap("n", "<Leader>" .. i, ":wincmd " .. i .. "w<CR>", { silent = true })
  -- <Leader><leader>[1-9] move to tab [1-9]
  vim.api.nvim_set_keymap("n", "<Leader><Leader>" .. i, ":" .. i .. "tabnext<CR>", { silent = true })
  -- <Leader>b[1-9] move to buffer [1-9]
  vim.api.nvim_set_keymap("n", "<Leader>b" .. i, ":b" .. i .. "<CR>", { silent = true })
end

if not vim.g.lasttab then vim.g.lasttab = 1 end
vim.api.nvim_set_keymap("n", "<Leader>lt", ':exe "tabn " . g:lasttab<CR>', { silent = true })

-- Windows and buffers
vim.api.nvim_set_keymap("n", "<silent> [Window]v", ":split<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> [Window]g", ":vsplit<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> [Window]t", ":tabnew<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> [Window]o", ":only<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> [Window]b", ":b#<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> [Window]c", ":close<CR>", {})
vim.keymap.set("n", "<silent> [Window]x", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_set_current_tabpage(tabnr)
  vim.api.nvim_command "enew"
end)

-- Split current buffer, go to previous window and previous buffer
vim.api.nvim_set_keymap("n", "<silent> <Leader>sp", ":split<CR>:wincmd p<CR>:e#<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> <Leader>sv", ":vsplit<CR>:wincmd p<CR>:e#<CR>", {})

-- Buffer
vim.api.nvim_set_keymap("n", "<silent> <Leader>bf", ":bfirst<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> <Leader>bl", ":blast<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> <Leader>bd", ":bd<CR>", {})
vim.api.nvim_set_keymap("n", "<silent> <Leader>bk", ":bw<CR>", {})
vim.api.nvim_set_keymap("n", "]b", ":bnext<CR>", {})
vim.api.nvim_set_keymap("n", "[b", ":bprev<CR>", {})

-- Window control
vim.api.nvim_set_keymap("n", "<A-Up>", ":resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-Down>", ":resize +2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-Left>", ":vertical resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-Right>", ":vertical resize +2<CR>", {})
vim.api.nvim_set_keymap("n", "<silent><C-w>z", ":vert resize<CR>:resize<CR>:normal! ze<CR>", {})

-- Window
vim.api.nvim_set_keymap("n", "<C-J>", "<C-W>j", {})
vim.api.nvim_set_keymap("n", "<C-K>", "<C-W>k", {})
vim.api.nvim_set_keymap("n", "<C-L>", "<C-W>l", {})
vim.api.nvim_set_keymap("n", "<C-H>", "<C-W>h", {})

-- Terminal Window
vim.api.nvim_set_keymap("t", "<C-J>", "<cmd>wincmd j<CR>", {})
vim.api.nvim_set_keymap("t", "<C-K>", "<cmd>wincmd k<CR>", {})
vim.api.nvim_set_keymap("t", "<C-H>", "<cmd>wincmd h<CR>", {})
vim.api.nvim_set_keymap("t", "<C-L>", "<cmd>wincmd l<CR>", {})

-- Remove spaces at the end of lines
vim.api.nvim_set_keymap("n", "<Leader>cw", [[:silent! keeppatterns %substitute/\s\+$//e<CR>]], { silent = true })

-- Quick substitute within selected area
vim.api.nvim_set_keymap("x", "sg", [[:s//gc<Left><Left><Left>]], {})

-- Location/quickfix list movement
vim.api.nvim_set_keymap("n", "]c", [[:lnext<CR>]], {})
vim.api.nvim_set_keymap("n", "[c", [[:lprev<CR>]], {})
vim.api.nvim_set_keymap("n", "]q", [[:cnext<CR>]], {})
vim.api.nvim_set_keymap("n", "[q", [[:cprev<CR>]], {})

-- Drag current line/s vertically and auto-indent
vim.api.nvim_set_keymap("v", "<Leader>k", [[:m '<-2<CR>gv=gv]], {})
vim.api.nvim_set_keymap("v", "<Leader>j", [[:m '>+<CR>gv=gv]], {})

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
