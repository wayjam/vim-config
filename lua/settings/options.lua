-- General
vim.opt.swapfile = false -- disable swapfile
vim.opt.backup = false -- disable backup file
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.mouse = "nv" -- allow the mouse to be used in neovim
vim.opt.modeline = true
vim.opt.fileformats = { "unix" }
vim.opt.path = { ".", "**" }
vim.opt.virtualedit = "block"
vim.opt.synmaxcol = 200
vim.opt.formatoptions:remove { "c", "r", "o" } -- This is a sequence of letters which describes how automatic formatting is to be done
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files

-- Enables 24-bit RGB color in the TUI
if vim.fn.has "termguicolors" == 1 then vim.opt.termguicolors = true end

-- Enable italics. Make sure this is applied after the colorscheme loads.
-- https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("user_italic_comment", { clear = true }),
  callback = function() vim.api.nvim_set_hl(0, "Comment", { italic = true }) end,
})
vim.api.nvim_set_hl(0, "Comment", { italic = true })

-- What to save for views and sessions:
vim.opt.viewoptions = { "folds", "cursor", "curdir", "slash", "unix" }
vim.opt.sessionoptions = { "curdir", "help", "tabpages", "winsize" }

-- clipboard
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste "+",
      ["*"] = require("vim.ui.clipboard.osc52").paste "*",
    },
  }
end

-- Wildmenu
-- noice.nvim takes over the full cmdline popup, but wildmode/wildoptions still
-- power built-in `:find`, `:edit`, globbing, etc. fzf-lua / neo-tree / ripgrep
-- each manage their own ignore lists, so keep this block minimal.
if vim.fn.has "wildmenu" == 1 then
  vim.opt.wildmenu = true
  vim.opt.wildmode = { "longest:full", "full" }
  vim.opt.wildoptions = { "pum", "tagfile" }
  vim.opt.wildignorecase = true
  vim.opt.wildignore:append { ".git/*", "node_modules/*", "__pycache__/*", "*.pyc", "*.o", "*.out", "*.DS_Store" }
end

-- Vim Directories
vim.opt.undofile = true -- enable persistent undo

-- Tabs and Indents
vim.opt.textwidth = 80
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.shiftround = true

-- Timing
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 300 -- faster completion (4000ms default)

-- Searching
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- smart case
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.showfulltag = true

if vim.fn.exists "+inccommand" == 1 then vim.opt.inccommand = "nosplit" end

if vim.fn.executable "rg" == 1 then
  vim.opt.grepformat = "%f:%l:%m"
  vim.opt.grepprg = "rg --vimgrep" .. (vim.opt.smartcase and " --smart-case" or "")
elseif vim.fn.executable "ag" == 1 then
  vim.opt.grepformat = "%f:%l:%m"
  vim.opt.grepprg = "ag --vimgrep" .. (vim.opt.smartcase and " --smart-case" or "")
end

-- Behavior
vim.opt.wrap = false -- display lines as one long line
vim.opt.linebreak = true
vim.opt.whichwrap:append "<,>,[,],h,l" -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.switchbuf = "useopen,usetab,vsplit"
vim.opt.backspace = "indent,eol,start"

-- Completion and Diff
vim.opt.complete = ",.,w,b,k"
-- `noinsert` — don't auto-insert the first completion entry.
-- `popup`    — show docs in a popup next to the menu (Neovim 0.11+).
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "popup" }
-- `histogram` is faster/cleaner than `patience`; `linematch:60` dramatically
-- improves 3-way diff rendering (Neovim 0.9+).
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "iwhite",
  "indent-heuristic",
  "algorithm:histogram",
  "linematch:60",
}

-- Editor UI
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.ruler = false -- hide the line and column number of the cursor position
vim.opt.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
vim.opt.cmdwinheight = 5
vim.opt.laststatus = 3 -- only the last window will always have a status line
vim.opt.display = "lastline"
vim.opt.background = "dark"
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
vim.opt.relativenumber = true
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.cmdheight = 0 -- hide the cmdline when idle; noice.nvim restores it on demand
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.guifont = "monospace:h16" -- the font used in graphical neovim applications
-- vim.opt.colorcolumn = 120
vim.opt.shortmess:append { W = true, I = true, c = true }

-- Behavior improvements introduced in recent Neovim versions.
vim.opt.splitkeep = "screen" -- Keep window text stable when opening/closing splits (0.9+)
vim.opt.smoothscroll = true -- Scroll by screen line rather than logical line on wrapped text (0.10+)
vim.opt.jumpoptions = "stack,view" -- Browser-like jump history + restore view with <C-o>/<C-i> (0.11+)
vim.opt.winborder = "rounded" -- Default border for hover/signature/etc. floats (0.11+)
vim.opt.confirm = true -- Ask to save instead of erroring on :q with unsaved changes

-- Fold
vim.opt.foldenable = true -- Enable folding.
-- vim.opt.foldclose = "all"
vim.opt.foldlevel = 99
vim.o.foldlevelstart = 99

-- UI Symbols
vim.opt.list = true
vim.opt.showbreak = "↪"
vim.opt.listchars = {
  tab = "▏ ",
  extends = "⟫",
  precedes = "⟪",
  nbsp = "␣",
  trail = "·",
}
vim.opt.fillchars:append { eob = " " }
