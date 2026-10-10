local keymap = require("utils").keymap
--- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymappings prefixes, evict entirely for use of plug-ins.
keymap({ "n", "x" }, "<Space>", "<Nop>", { noremap = true })
keymap({ "n", "x" }, "\\", "<Nop>", { noremap = true })

-- Quick quit action
local quit_buf_options = {
  ["neo-tree.nvim"] = {
    ft = "neo-tree",
    close = function()
      require("neo-tree.command").execute {
        action = "close",
      }
    end,
  },
}
local file_manager = "neo-tree.nvim"
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

-- Change current word in a repeatable manner
keymap("n", "<leader>cn", "*``cgn", { desc = "Change next match" })
keymap("n", "<leader>cN", "*``cgN", { desc = "Change previous match" })
keymap("v", "<leader>cn", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgn]], { expr = true, desc = "Change next selection match" })
keymap("v", "<leader>cN", [["y/\V<C-r>=escape(@", "/")<CR><CR>"``cgN]], { expr = true, desc = "Change previous selection match" })

-- Duplicate paragraph
keymap("n", "<leader>cp", "yap<S-}>p", { desc = "Duplicate paragraph" })

-- Start new line from any cursor position in insert-mode
keymap("i", "<S-Return>", "<C-o>o", {})

-- Global niceties

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
keymap("v", "<C-s>", "<Esc>:<C-u>write<CR>", {})

-- Highlight: <Esc> clears search highlight (line above); legacy <leader>nh
-- removed as redundant.
keymap("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- Movement (page scrolling centers the cursor; neoscroll is disabled but if
-- re-enabled it should set respect_scrolloff=true to keep this behavior)
keymap("n", "<C-d>", "<C-d>zz", {})
keymap("n", "<C-u>", "<C-u>zz", {})
keymap("n", "n", "nzzzv", {})
keymap("n", "N", "Nzzzv", {})

-- Toggle editor's visual effects
keymap("n", "<Leader>tz", ":setlocal spell!<cr>", { desc = "Toggle spell checking" })
keymap("n", "<Leader>tn", ":setlocal nonumber!<CR>", { desc = "No number" })
keymap("n", "<Leader>tl", ":setlocal nolist!<CR>", { desc = "No list" })
keymap("n", "<Leader>tw", ":setlocal wrap! breakindent!<CR>", { desc = "Wrap breakindent" })

-- Tabs
keymap("n", "g0", ":tabfirst<CR>", { silent = true, desc = "First tab" })
keymap("n", "g$", ":tablast<CR>", { silent = true, desc = "Last tab" })
keymap("n", "<A-j>", ":tabnext<CR>", { silent = true, desc = "Next tab" })
keymap("n", "<A-k>", ":tabprevious<CR>", { silent = true, desc = "Previous tab" })

for i = 1, 9 do
  -- <Leader>[1-9] move to window [1-9]
  keymap("n", "<Leader>" .. i, ":wincmd " .. i .. "w<CR>", { silent = true, desc = "Jump to window " .. i })
  -- <Leader><leader>[1-9] move to tab [1-9]
  keymap("n", "<Leader><Leader>" .. i, ":" .. i .. "tabnext<CR>", { silent = true, desc = "Jump to tab " .. i })
  -- <Leader>b[1-9] move to buffer [1-9]
  keymap("n", "<Leader>b" .. i, ":b" .. i .. "<CR>", { silent = true, desc = "Jump to buffer " .. i })
end

if not vim.g.lasttab then vim.g.lasttab = 1 end
keymap("n", "<Leader>lt", ':exe "tabn " . g:lasttab<CR>', { silent = true, desc = "Last tab" })

-- Buffer: replace current buffer with a fresh empty one (keeps window/tab layout)
keymap("n", "<Leader>bx", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    vim.notify("Buffer has unsaved changes; write or discard them first.", vim.log.levels.WARN)
    return
  end
  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_set_current_tabpage(tabnr)
  vim.api.nvim_command "new"
end, { silent = true, desc = "Delete buffer & open empty" })

-- Buffer navigation
keymap("n", "<Leader>b0", ":bfirst<CR>", { silent = true, desc = "First buffer" })
keymap("n", "<Leader>b$", ":blast<CR>", { silent = true, desc = "Last buffer" })
keymap("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "[b", ":bprev<CR>", { desc = "Previous buffer" })

-- Window control
keymap("n", "<A-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<A-Down>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
keymap("n", "<C-w>z", ":vert resize<CR>:resize<CR>:normal! ze<CR>", { silent = true, desc = "Maximize window" })
keymap("n", "<C-w>=", "<cmd>wincmd =<CR>", { silent = true, desc = "Equalize windows" })

-- Window navigation: handled by vim-tmux-navigator (<C-h/j/k/l> seamlessly
-- crosses tmux pane <-> nvim split boundaries). Do NOT add noremap overrides
-- here or the plugin becomes a no-op.

-- Terminal Window
keymap("t", "<C-J>", "<cmd>wincmd j<CR>", { desc = "Window below" })
keymap("t", "<C-K>", "<cmd>wincmd k<CR>", { desc = "Window above" })
keymap("t", "<C-H>", "<cmd>wincmd h<CR>", { desc = "Window left" })
keymap("t", "<C-L>", "<cmd>wincmd l<CR>", { desc = "Window right" })

-- Remove spaces at the end of lines
keymap(
  "n",
  "<Leader>cw",
  [[:silent! keeppatterns %substitute/\s\+$//e<CR>]],
  { silent = true, desc = "Remove spaces at the end of lines" }
)

-- Quick substitute within selected area
keymap("x", "sg", [[:s///gc<Left><Left><Left>]], {})

-- Keep the unnamed register intact when pasting over a visual selection,
-- so the same content can be pasted repeatedly (use explicit "_d to delete
-- into the black hole when needed).
keymap("x", "p", [["_dp]])

-- Quickfix list movement; use Neovim's built-in [l and ]l for location lists.
keymap("n", "]q", [[:cnext<CR>]], { desc = "Next quickfix entry" })
keymap("n", "[q", [[:cprev<CR>]], { desc = "Previous quickfix entry" })

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

-- Manual session save/load (per working directory). Run `:SessionSave` before
-- quitting and `:SessionLoad` after reopening; nothing happens automatically.
local session_dir = vim.fn.stdpath "data" .. "/sessions"
local function session_path()
  local cwd = vim.fn.getcwd()
  local hash = vim.fn.sha256(cwd):sub(1, 16)
  return session_dir .. "/" .. hash .. ".vim", cwd
end

vim.api.nvim_create_user_command("SessionSave", function()
  vim.fn.mkdir(session_dir, "p")
  local path, cwd = session_path()
  vim.cmd("mksession! " .. vim.fn.fnameescape(path))
  vim.notify("Session saved for " .. cwd, vim.log.levels.INFO)
end, { desc = "Save session for current directory" })

vim.api.nvim_create_user_command("SessionLoad", function()
  local path, cwd = session_path()
  if vim.fn.filereadable(path) == 0 then
    vim.notify("No saved session for " .. cwd, vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(path))
  vim.notify("Session loaded for " .. cwd, vim.log.levels.INFO)
end, { desc = "Load session for current directory" })

keymap("n", "<leader>wS", "<cmd>SessionSave<CR>", { desc = "Save Session" })
keymap("n", "<leader>wL", "<cmd>SessionLoad<CR>", { desc = "Load Session" })
