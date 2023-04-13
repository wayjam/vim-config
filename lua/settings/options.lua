-- General
vim.opt.mouse = "nv"
vim.opt.modeline = true
vim.opt.report = 0
vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.signcolumn = "yes"
vim.opt.hidden = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.magic = true
vim.opt.path = { ".", "**" }
vim.opt.virtualedit = "block"
vim.opt.synmaxcol = 1000
vim.opt.formatoptions:remove "t"
vim.opt.formatoptions:append "1"
vim.opt.formatoptions:append "mM"
vim.opt.fileencoding = "utf-8"

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
if vim.fn.has "clipboard" == 1 then vim.opt.clipboard:append "unnamedplus" end

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
vim.opt.undofile = true

-- Tabs and Indents
vim.opt.textwidth = 80
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 1
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Timing
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 200
vim.opt.redrawtime = 2000

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
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
  vim.o.grepformat = "%f:%l:%m"
  vim.o.grepprg = "rg --vimgrep" .. (vim.o.smartcase and " --smart-case" or "")
elseif vim.fn.executable "ag" == 1 then
  vim.o.grepformat = "%f:%l:%m"
  vim.o.grepprg = "ag --vimgrep" .. (vim.o.smartcase and " --smart-case" or "")
end

-- Behavior
vim.o.wrap = false
vim.o.linebreak = true
vim.o.whichwrap = "h,l,<,>,[,],~"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.switchbuf = "useopen,usetab,vsplit"
vim.o.backspace = "indent,eol,start"

-- Completion and Diff
vim.o.complete = ",.,w,b,k"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.diffopt = "iwhite,indent-heuristic,algorithm:patience"

-- Editor UI
vim.o.showmode = false
vim.o.shortmess = "aoOTI"
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.ruler = false
vim.o.showtabline = 2
vim.o.showcmd = true
vim.o.cmdheight = 2
vim.o.cmdwinheight = 5
vim.o.equalalways = true
vim.o.laststatus = 2
vim.o.display = "lastline"
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldclose = "all"
-- vim.o.colorcolumn = 120

-- UI Symbols
vim.o.list = true
vim.o.showbreak = "↪"
vim.o.listchars = "tab:▏\\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·"

-- Do not show "match xx of xx" and other messages during auto-completion
vim.o.shortmess = vim.o.shortmess .. "c"
