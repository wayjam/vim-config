-- Global autocommands that are independent of any plugin.
-- Plugin-specific autocmds (LspAttach, neo-tree startup, etc.) stay in their
-- own plugin spec.

local group = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- Auto-reload files changed outside Neovim (e.g. by Claude Code, aider, etc.)
-- `autoread` by itself only triggers the reload on certain internal events;
-- the autocmd below nudges Neovim to actually call `:checktime` whenever the
-- editor regains focus or the user pauses long enough to trigger CursorHold.
-- NOTE: BufEnter was deliberately dropped — in large monorepos it fires often
-- enough that the per-buffer stat adds noticeable latency.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold", "CursorHoldI" }, {
  group = group,
  desc = "Reload buffers when files change on disk",
  callback = function()
    if vim.fn.mode() ~= "c" then vim.cmd "checktime" end
  end,
})

-- Poll the disk periodically so buffers refresh even when Neovim doesn't have
-- focus (e.g. Claude Code editing files in the adjacent tmux pane). CursorHold
-- only fires while Neovim is focused; FocusGained requires switching panes.
-- Only stat the buffers currently visible in some window — ignoring hidden
-- buffers keeps the per-tick cost O(panes) instead of O(total buffers).
-- use `:Lazy profile` or `nvim --startuptime` to measure performance
local checktime_timer = vim.uv.new_timer()
local checktime_interval_ms = 2000
checktime_timer:start(
  checktime_interval_ms,
  checktime_interval_ms,
  vim.schedule_wrap(function()
    local mode = vim.fn.mode()
    if mode ~= "n" and mode ~= "v" and mode ~= "V" then return end
    local seen = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not seen[buf] and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
        seen[buf] = true
        vim.api.nvim_buf_call(buf, function() vim.cmd "silent! checktime" end)
      end
    end
  end)
)

-- Decide how to resolve a disk-vs-buffer change. When the buffer has no local
-- edits we always reload silently. When both the disk and the buffer have
-- diverged (common under fast AI edits), fall back to Vim's built-in prompt
-- so we never silently lose typed characters.
vim.api.nvim_create_autocmd("FileChangedShell", {
  group = group,
  desc = "Resolve external file changes without clobbering local edits",
  callback = function(args)
    if vim.bo[args.buf].modified then
      vim.v.fcs_choice = "ask" -- Load / Diff / Keep — user chooses
    else
      vim.v.fcs_choice = "reload"
    end
  end,
})

-- Notify when a buffer is reloaded because the file changed on disk. We write
-- to :messages (via nvim_echo with add_to_history=true) in addition to the
-- regular echo area because cmdheight=0 makes transient messages easy to miss
-- when the reload happens while focus is elsewhere. Vim already splices the
-- reload into the undo tree as a single step, so `u` right after a reload
-- undoes the external change — no extra manipulation needed.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  desc = "Warn when a buffer is reloaded from disk",
  callback = function(args)
    vim.api.nvim_echo(
      { { "⟳ " .. vim.fn.fnamemodify(args.file, ":~:.") .. " reloaded from disk", "WarningMsg" } },
      true,
      {}
    )
  end,
})

-- Briefly highlight the yanked region on every yank.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight on yank",
  callback = function() vim.hl.on_yank { higroup = "IncSearch", timeout = 150 } end,
})

-- Restore the cursor position when opening a file.
-- Skip commit messages — they should start at line 1.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Restore last cursor position",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then return end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Close non-listed buffers with `q`
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Close scratch buffers with q",
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end, { buffer = args.buf, silent = true, desc = "Quit buffer" })
    end)
  end,
})

-- Create parent directories for new files.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  desc = "Create missing parent directories on save",
  callback = function(args)
    if args.match:match "^%w%w+:[\\/][\\/]" then return end -- skip scp://, http://, etc.
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Re-equalize splits when the Neovim window itself is resized (tmux pane
-- resize, terminal font change, etc.).
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  desc = "Equalize splits on VimResized",
  callback = function()
    local current = vim.api.nvim_get_current_tabpage()
    vim.cmd "tabdo wincmd ="
    vim.api.nvim_set_current_tabpage(current)
  end,
})

-- Track the previous tab so `<Leader>lt` can jump back to it.
vim.api.nvim_create_autocmd("TabLeave", {
  group = group,
  desc = "Remember last tab for <Leader>lt",
  callback = function() vim.g.lasttab = vim.fn.tabpagenr() end,
})
