" ===
" Key bindings
" ===

" Non-standard
" ---

" Quick quit action
nnoremap <silent> <Leader>q  :q<CR>
nnoremap <silent> <Leader>w  :w<CR>

" Fix keybind name for Ctrl+Spacebar
map <Nul> <C-Space>
map! <Nul> <C-Space>

" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
	nnoremap <Up>    :resize +2<CR>
	nnoremap <Down>  :resize -2<CR>
	nnoremap <Left>  :vertical resize +2<CR>
	nnoremap <Right> :vertical resize -2<CR>
endif

" Double leader key for toggling visual-line mode
nmap <silent> <Leader><Leader> V
vmap <Leader><Leader> <Esc>
if has('nvim') || has('terminal')
	tnoremap <Esc> <C-\><C-n>
endif

" jump
nnoremap g- <C-O>
nnoremap g= <C-I>

" Insert mode shortcut
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-H> <Left>
" <C-t>: insert tab.
inoremap <C-t>  <C-v><TAB>
" Enable undo <C-u>.
inoremap <C-u>  <C-g>u<C-u>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-h> <Left>
inoremap <A-l> <Right>

" Command mode shortcut
cnoremap <C-a>          <Home>
cnoremap <C-e>          <End>
cnoremap <C-h>          <Left>
cnoremap <C-l>          <Right>
cnoremap <C-j>          <Up>
cnoremap <C-k>          <Down>
cnoremap <C-d>          <Del>
cnoremap <C-y>          <C-r>*

" Quit visual mode
vnoremap v <Esc>

" Macros
nnoremap Q q
nnoremap q <Nop>

" Toggle pastemode
nnoremap <silent> <Leader>tp :setlocal paste!<CR>

" Change current word in a repeatable manner
nnoremap <leader>cn *``cgn
nnoremap <leader>cN *``cgN

" Change selected word in a repeatable manner
vnoremap <expr> <leader>cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
vnoremap <expr> <leader>cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" Duplicate paragraph
nnoremap <leader>cp yap<S-}>p

" Cut & paste & change without pushing to register
xnoremap p  "0p
nnoremap x "_x
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc
xnoremap c "_c

" Toggle fold
nnoremap <CR> za

" Focus the current fold by closing all others
nnoremap <S-Return> zMzvzt

" Start new line from any cursor position in insert-mode
inoremap <S-Return> <C-o>o

" The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
" these mappings will move through display-lines in visual mode too.
vnoremap j gj
vnoremap k gk

" nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
" nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'k'

" Global niceties
" ---

" Start an external command with a single bang
nnoremap ! :!

" Allow misspellings
cnoreabbrev qw wq
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Qa qa
cnoreabbrev Bd bd
cnoreabbrev bD bd

nnoremap zl z5l
nnoremap zh z5h

" Improve scroll, credits: https://github.com/Shougo
noremap <expr> <C-f> max([winheight(0) - 2, 1])
			\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
			\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
			\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual/select mode
" xnoremap <Tab> >gv|
" xnoremap <S-Tab> <gv
" nmap >>  >>_
" nmap <<  <<_

" File operations
" ---------------

" Switch to the directory of the opened buffer in current window
map <Leader>cd :lcd %:p:h<CR>:pwd<CR>

" Fast saving from all modes
nnoremap <silent><Leader>w :write<CR>
vnoremap <silent><Leader>w <Esc>:write<CR>
nnoremap <silent><C-s> :<C-u>write<CR>
vnoremap <silent><C-s> :<C-u>write<CR>
cnoremap <silent><C-s> <C-u>write<CR>

" Editor UI
" ---------
nnoremap <silent> <leader>nh :nohl<CR>

" Show vim syntax highlight groups for character under cursor
nmap <silent> gh :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
			\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
			\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<CR>

" Toggle editor's visual effects
nmap <silent> <Leader>ts :setlocal spell!<cr>
nmap <silent> <Leader>tn :setlocal nonumber!<CR>
nmap <silent> <Leader>tl :setlocal nolist!<CR>
nmap <silent> <Leader>th :nohlsearch<CR>
nmap <silent> <Leader>tw :setlocal wrap! breakindent!<CR>

" Tabs
nnoremap <silent> g$ :<C-u>tabfirst<CR>
nnoremap <silent> g^ :<C-u>tablast<CR>
nnoremap <silent> <A-j> :<C-U>tabnext<CR>
nnoremap <silent> <A-k> :<C-U>tabprevious<CR>
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>
for s:i in range(1, 9)
	" <Leader>[1-9] move to window [1-9]
	execute 'nnoremap <Leader>'.s:i ' :'.s:i.'wincmd w<CR>'

	" <Leader><leader>[1-9] move to tab [1-9]
	execute 'nnoremap <Leader><Leader>'.s:i s:i.'gt'

	" <Leader>b[1-9] move to buffer [1-9]
	execute 'nnoremap <Leader>b'.s:i ':b'.s:i.'<CR>'
endfor
unlet s:i

" Windows and buffers
" ---
nnoremap <silent> [Window]v  :<C-u>split<CR>
nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
nnoremap <silent> [Window]t  :tabnew<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]b  :b#<CR>
nnoremap <silent> [Window]c  :close<CR>
nnoremap <silent> [Window]x  :<C-u>call <SID>window_empty_buffer()<CR>

" Split current buffer, go to previous window and previous buffer
nnoremap <silent> <Leader>sp :split<CR>:wincmd p<CR>:e#<CR>
nnoremap <silent> <Leader>vsp :vsplit<CR>:wincmd p<CR>:e#<CR>

" Buffer
nnoremap <silent> <Leader>bp :bprevious<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bf :bfirst<CR>
nnoremap <silent> <Leader>bl :blast<CR>
nnoremap <silent> <Leader>bd :bd<CR>
nnoremap <silent> <Leader>bk :bw<CR>
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Window control
nnoremap <C-q> <C-w>
nnoremap <C-x> <C-w>x<C-w>w
nnoremap <silent><C-w>z :vert resize<CR>:resize<CR>:normal! ze<CR>

" Window
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <Leader>ww <C-W>w
nnoremap <Leader>wr <C-W>r
nnoremap <Leader>wd <C-W>c
nnoremap <Leader>wq <C-W>q
nnoremap <Leader>wj <C-W>j
nnoremap <Leader>wk <C-W>k
nnoremap <Leader>wh <C-W>h
nnoremap <Leader>wl <C-W>l
if has('nvim') || has('terminal')
	tnoremap <Leader>wj <C-W>j
	tnoremap <Leader>wk <C-W>k
	tnoremap <Leader>wh <C-W>h
	tnoremap <Leader>wl <C-W>l
endif
nnoremap <Leader>wH <C-W>5<
nnoremap <Leader>wL <C-W>5>
nnoremap <Leader>wJ :resize +5<CR>
nnoremap <Leader>wK :resize -5<CR>
nnoremap <Leader>w= <C-W>=
nnoremap <Leader>ws <C-W>s
nnoremap <Leader>w- <C-W>s
nnoremap <Leader>wv <C-W>v
nnoremap <Leader>w\| <C-W>v
nnoremap <Leader>w2 <C-W>v

function! s:window_empty_buffer()
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete '.l:current
	endif
endfunction

" Remove spaces at the end of lines
nnoremap <silent> <Leader>cw :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Quick substitute within selected area
xnoremap sg :s//gc<Left><Left><Left>

" Returns visually selected text
function! s:get_selection(cmdtype)
	let temp = @s
	normal! gv"sy
	let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
	let @s = temp
endfunction

" Location/quickfix list movement
nmap ]c :lnext<CR>
nmap [c :lprev<CR>
nmap ]q :cnext<CR>
nmap [q :cprev<CR>

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" Duplicate lines
nnoremap <Leader>d m`YP``
vnoremap <Leader>d YPgv

function! s:add_to_register(str)
	if get(g:, 'loaded_oscyank')
		call YankOSC52(a:str)
	endif
	let @+=a:str
endfunction

" Yank buffer's absolute path to clipboard
nnoremap <Leader>y :call <SID>add_to_register(expand("%:~:."))<CR>:echo 'Yanked relative path'<CR>
nnoremap <Leader>Y :call <SID>add_to_register(expand("%:p"))<CR>:echo 'Yanked absolute path'<CR>

" Drag current line/s vertically and auto-indent
nnoremap <Leader>k :m .-2<CR>==
nnoremap <Leader>j :m +1<CR>==
vnoremap <Leader>k :m '<-2<CR>gv=gv
vnoremap <Leader>j :m '>+<CR>gv=gv

" Useful command
" --------------

" quick function for clap/denite command
command! -nargs=1 ColorColumn :set colorcolumn=<args>
command! -nargs=0 EditVIMConfig :tabe $MYVIMRC
command! -nargs=0 ReloadVIMConfig :source $MYVIMRC
