-- General
vim.opt.swapfile = false -- disable swapfile
vim.opt.backup = false -- disable backup file
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.mouse = "nv" -- allow the mouse to be used in neovim
vim.opt.modeline = true
vim.opt.report = 0
vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.hidden = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.magic = true
vim.opt.path = { ".", "**" }
vim.opt.virtualedit = "block"
vim.opt.synmaxcol = 1000
vim.opt.formatoptions:remove { "c", "r", "o" } -- This is a sequence of letters which describes how automatic formatting is to be done
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files

-- Enables 24-bit RGB color in the TUI
if vim.fn.has "termguicolors" == 1 then vim.opt.termguicolors = true end

-- italic support
vim.g.t_ZH = "e[3m"
vim.g.t_ZR = "e[23m"

-- Enable italics, Make sure this is immediately after colorscheme
-- https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
vim.cmd "highlight Comment cterm=italic gui=italic"

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
if vim.fn.has "wildmenu" == 1 then
  vim.opt.wildmenu = false
  vim.opt.wildmode = { "list:longest", "full" }
  vim.opt.wildoptions:append "tagfile"
  vim.opt.wildignorecase = true
  vim.opt.wildignore:append { ".git", ".hg", ".svn", ".stversions", "*.pyc", "*.spl", "*.o", "*.out", "*~", "%*" }
  vim.opt.wildignore:append { "*.jpg", "*.jpeg", "*.png", "*.gif", "*.zip", "**/tmp/**", "*.DS_Store" }
  vim.opt.wildignore:append { "**/node_modules/**", "**/bower_modules/**", "*/.sass-cache/*" }
  vim.opt.wildignore:append { "application/vendor/**", "**/vendor/ckeditor/**", "media/vendor/**" }
  vim.opt.wildignore:append { "__pycache__", "*.egg-info", ".pytest_cache" }
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
vim.opt.matchpairs:append "<:>"
vim.opt.matchtime = 1
vim.opt.cpoptions:remove "m"
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
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.diffopt = "iwhite,indent-heuristic,algorithm:patience"

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
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.guifont = "monospace:h16" -- the font used in graphical neovim applications
-- vim.opt.colorcolumn = 120
vim.opt.shortmess:append { W = true, I = true, c = true }
vim.opt.iskeyword:append "-" -- treats words with `-` as single words

-- Fold
vim.opt.foldenable = true -- Enable folding.
vim.opt.foldclose = "all"
vim.opt.foldlevel = 10

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
