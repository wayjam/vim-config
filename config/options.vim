" ===
" General
" ===
set mouse=nv                 " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set signcolumn=yes           " Always show signs column
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=1000           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions+=mM        " Correctly break multi-byte characters such as CJK, see https://stackoverflow.com/q/32669814/6064933

" Encoding
set encoding=utf-8
scriptencoding utf-8

" Enable syntax
syntax on
filetype plugin indent on

" Enables 24-bit RGB color in the TUI
if has('termguicolors')
  set termguicolors
endif

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

" italic support
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" Enable italics, Make sure this is immediately after colorscheme
" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
highlight Comment cterm=italic gui=italic

" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions=curdir,help,tabpages,winsize

if has('mac')
  let g:clipboard = {
    \   'name': 'macOS-clipboard',
    \   'copy': {
    \      '+': 'pbcopy',
    \      '*': 'pbcopy',
    \    },
    \   'paste': {
    \      '+': 'pbpaste',
    \      '*': 'pbpaste',
    \   },
    \   'cache_enabled': 0,
    \ }
endif

" clipboard
if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif

" Wildmenu
if has('wildmenu')
  set nowildmenu
  set wildmode=list:longest,full
  set wildoptions=tagfile
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
  set wildignore+=__pycache__,*.egg-info,.pytest_cache
endif

" Vim Directories
set undofile

" History saving
set history=2000
if ! has('win32') && ! has('win64')
  set shada='400,<20,@100,s10,f1,h,r/tmp,r/private/var
else
  set viminfo='400,<20,@50,f1,h,n$HOME/.cache/viminfo
endif

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
  \ && $HOME !=# expand('~'.$USER)
  \ && $HOME ==# expand('~'.$SUDO_USER)

  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  set shada="NONE"
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
  set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo/shada files in temp directories or shm
augroup user_secure
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
    \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END

" Tabs and Indents
set textwidth=80    " Text width maximum chars before wrapping
set noexpandtab     " Don't expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=1   " Automatically keeps in sync with shiftwidth
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

" Timing
set timeout ttimeout
set timeoutlen=500   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=200   " Idle time to write swap and trigger CursorHold
set redrawtime=2000  " Time in milliseconds for stopping display redraw

" Searching
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set showfulltag     " Show tag and tidy search in completion

if exists('+inccommand')
  set inccommand=nosplit
endif

if executable('rg')
  set grepformat=%f:%l:%m
  let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
elseif executable('ag')
  set grepformat=%f:%l:%m
  let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif

" Behavior
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
set switchbuf+=vsplit           " Switch buffer behavior to vsplit
set backspace=indent,eol,start  " Intuitive backspacing in insert mode

" Completion and Diff
set complete=.,w,b,k                                    " C-n completion: Scan buffers, windows and dictionary
set completeopt=menu,menuone,noselect                   " Always show menu, even for one item
set diffopt+=iwhite,indent-heuristic,algorithm:patience " Diff mode: ignore whitespace

" Editor UI
set noshowmode               " Don't show mode in cmd window
set shortmess=aoOTI          " Shorten messages and don't show intro
set scrolloff=2              " Keep at least 2 lines above/below
set sidescrolloff=5          " Keep at least 5 lines left/right
set noruler                  " Disable default status ruler
set showtabline=2            " Always show the tabs line
set showcmd                  " Show command in status line
set cmdheight=2              " Height of the command line
set cmdwinheight=5           " Command-line lines
set equalalways              " Resize windows on split or close
set laststatus=2             " Always show a status line
set display=lastline
set background=dark          " Assume dark background
set cursorline               " Highlight current line
set fileformats=unix,dos,mac " Use Unix as the standard file type
set number                   " Line numbers on
set relativenumber           " Relative numbers on
set foldenable
set foldlevel=99
set foldclose=all
" set colorcolumn=80      " Highlight the 80th character limit

" UI Symbols
set list                " Show hidden characters
set showbreak=↪
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·

" Do not show "match xx of xx" and other messages during auto-completion
set shortmess+=c

" For snippet_complete marker
set conceallevel=2 concealcursor=niv

if exists('&pumblend')
  " pseudo-transparency for completion menu
  set pumblend=5
endif

if exists('&winblend')
  " pseudo-transparency for floating window
  set winblend=5
endif
