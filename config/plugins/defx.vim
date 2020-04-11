call defx#custom#option('_', {
			\ 'winwidth': 25,
			\ 'split': 'vertical',
			\ 'direction': 'topleft',
			\ 'show_ignored_files': 0,
			\ 'columns': 'indent:git:icons:filename',
			\ 'root_marker': ' ',
			\ 'buffer_name': '',
			\ 'ignored_files':
			\     '.mypy_cache,.pytest_cache,.git,.hg,.svn,.stversions'
			\   . ',__pycache__,.sass-cache,*.egg-info,.DS_Store,*.pyc'
			\ })

call defx#custom#column('git', {
			\   'indicators': {
			\     'Modified'  : '✹',
			\     'Staged'    : '✚',
			\     'Untracked' : '✭',
			\     'Renamed'   : '➜',
			\     'Unmerged'  : '≠',
			\     'Ignored'   : '☒',
			\     'Deleted'   : '✖',
			\     'Unknown'   : '?'
			\   }
			\ })

call defx#custom#column('mark', { 'readonly_icon': '', 'selected_icon': '' })

" defx-icons plugin
let g:defx_icons_column_length = 2
let g:defx_icons_mark_icon = ''

" Internal use
let s:original_width = get(get(defx#custom#_get().option, '_'), 'winwidth')

" Events
" ---

augroup user_plugin_defx
	autocmd!

	" Delete defx if it's the only buffer left in the window
	autocmd WinEnter * if &filetype == 'defx' && winnr('$') == 1 | bdel | endif

	" Move focus to the next window if current buffer is defx
	autocmd TabLeave * if &filetype == 'defx' | wincmd w | endif

	" Disable lightline

	" Automatically refresh opened Defx windows when changing working-directory
	" autocmd DirChanged * call <SID>defx_handle_dirchanged(v:event)

	" setup defx
	autocmd FileType defx call <SID>defx_setup()

augroup END

" Internal functions
" ---
"
function! s:defx_handle_dirchanged(event)
	" Refresh opened Defx windows when changing working-directory
	let l:cwd = get(a:event, 'cwd', '')
	let l:scope = get(a:event, 'scope', '')   " global, tab, window
	let l:current_win = winnr()
	if &filetype ==# 'defx' || empty(l:cwd) || empty(l:scope)
		return
	endif

	" Find tab-page's defx window
	for l:nr in tabpagebuflist()
		if getbufvar(l:nr, '&filetype') ==# 'defx'
			let l:winnr = bufwinnr(l:nr)
			if l:winnr != -1
				" Change defx's window directory location
				if l:scope ==# 'window'
					execute 'noautocmd' l:winnr . 'windo' 'lcd' l:cwd
				else
					execute 'noautocmd' l:winnr . 'wincmd' 'w'
				endif
				call defx#call_action('cd', [ l:cwd ])
				execute 'noautocmd' l:current_win . 'wincmd' 'w'
				break
			endif
		endif
	endfor
endfunction

function! s:jump_dirty(dir) abort
	" Jump to the next position with defx-git dirty symbols
	let l:icons = get(g:, 'defx_git_indicators', {})
	let l:icons_pattern = join(values(l:icons), '\|')

	if ! empty(l:icons_pattern)
		let l:direction = a:dir > 0 ? 'w' : 'bw'
		return search(printf('\(%s\)', l:icons_pattern), l:direction)
	endif
endfunction

function! s:defx_setup() abort
	setlocal signcolumn=no expandtab
	setlocal nonumber norelativenumber
  setlocal listchars=
  setlocal nofoldenable foldmethod=manual

	" Defx window keyboard mappings
	nnoremap <silent><buffer><expr> <CR>
			\ defx#is_directory() ?
			\ defx#do_action('open_or_close_tree') : defx#do_action('drop')
	nnoremap <silent><buffer><expr> o defx#do_action('open')
	nnoremap <silent><buffer><expr> f     defx#do_action('open_or_close_tree')
	nnoremap <silent><buffer><expr> rt     defx#do_action('open_tree_recursive')
	nnoremap <silent><buffer><expr> t    defx#do_action('multi', [['drop', 'tabnew'], 'quit'])
	nnoremap <silent><buffer><expr> vsp    defx#do_action('open', 'vsplit')
	nnoremap <silent><buffer><expr> sp    defx#do_action('open', 'split')
	nnoremap <silent><buffer><expr> p     defx#do_action('open', 'pedit')
	nnoremap <silent><buffer><expr> yy     defx#do_action('yank_path')
	nnoremap <silent><buffer><expr> !    defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> .     defx#do_action('toggle_ignored_files')

	" Defx's buffer management
	nnoremap <silent><buffer><expr> q      defx#do_action('quit')
	nnoremap <silent><buffer><expr> se     defx#do_action('save_session')
	nnoremap <silent><buffer><expr> <C-r>  defx#do_action('redraw')
	nnoremap <silent><buffer><expr> <C-g>  defx#do_action('print')

	" File/dir management
	nnoremap <silent><buffer><expr><nowait> C  defx#do_action('copy')
	nnoremap <silent><buffer><expr><nowait> M  defx#do_action('move')
	nnoremap <silent><buffer><expr><nowait> P  defx#do_action('paste')
	nnoremap <silent><buffer><expr><nowait> R  defx#do_action('rename')
	nnoremap <silent><buffer><expr> dd defx#do_action('remove_trash')
	nnoremap <silent><buffer><expr> rm defx#do_action('remove')
	nnoremap <silent><buffer><expr> K  defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> N  defx#do_action('new_multiple_files')

	" Jump
	nnoremap <silent><buffer>  [g :<C-u>call <SID>jump_dirty(-1)<CR>
	nnoremap <silent><buffer>  ]g :<C-u>call <SID>jump_dirty(1)<CR>

	" Change directory
	nnoremap <silent><buffer><expr><nowait> \  defx#do_action('cd', getcwd())
	nnoremap <silent><buffer><expr> <BS>  defx#async_action('cd', ['..'])
	nnoremap <silent><buffer><expr> ~     defx#async_action('cd')
	nnoremap <silent><buffer><expr> u   defx#do_action('cd', ['..'])
	nnoremap <silent><buffer><expr> 2u  defx#do_action('cd', ['../..'])
	nnoremap <silent><buffer><expr> 3u  defx#do_action('cd', ['../../..'])
	nnoremap <silent><buffer><expr> 4u  defx#do_action('cd', ['../../../..'])
	nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')

	" Selection
	nnoremap <silent><buffer><expr> *  defx#do_action('toggle_select_all')
	nnoremap <silent><buffer><expr><nowait> '
				\ defx#do_action('toggle_select') . 'j'

	nnoremap <silent><buffer><expr> S  defx#do_action('toggle_sort', 'Time')
	nnoremap <silent><buffer><expr> C
				\ defx#do_action('toggle_columns', 'indent:mark:filename:type:size:time')
endfunction

" TOOLS
" ---

function! s:find_files(context) abort
	" Find files in parent directory with Denite
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	silent execute 'wincmd w'
	silent execute 'Denite file/rec:'.l:parent
endfunction

function! s:grep(context) abort
	" Grep in parent directory with Denite
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	silent execute 'wincmd w'
	silent execute 'Denite grep:'.l:parent
endfunction

function! s:toggle_width(context) abort
	" Toggle between defx window width and longest line
	let l:max = 0
	for l:line in range(1, line('$'))
		let l:len = len(getline(l:line))
		let l:max = max([l:len, l:max])
	endfor
	let l:new = l:max == winwidth(0) ? s:original_width : l:max
	call defx#call_action('resize', l:new)
endfunction

function! s:explorer(context) abort
	" Open file-explorer split with tmux
	let l:explorer = s:find_file_explorer()
	if empty('$TMUX') || empty(l:explorer)
		return
	endif
	let l:target = a:context['targets'][0]
	let l:parent = fnamemodify(l:target, ':h')
	let l:cmd = 'split-window -p 30 -c ' . l:parent . ' ' . l:explorer
	silent execute '!tmux ' . l:cmd
endfunction

function! s:find_file_explorer() abort
	" Detect terminal file-explorer
	let s:file_explorer = get(g:, 'terminal_file_explorer', '')
	if empty(s:file_explorer)
		for l:explorer in ['lf', 'hunter', 'ranger', 'vifm']
			if executable(l:explorer)
				let s:file_explorer = l:explorer
				break
			endif
		endfor
	endif
	return s:file_explorer
endfunction
