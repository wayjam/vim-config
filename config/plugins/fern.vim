let g:fern#disable_default_mappings = 1

let g:fern#drawer_width = 25
let g:fern#default_hidden = 1

let g:fern#keepalt_on_edit = 1
let g:fern#keepjumps_on_edit = 1

let g:fern#hide_cursor = 1
let g:fern#disable_viewer_auto_duplication = 1
let g:fern#disable_drawer_auto_resize = 0

let g:fern#default_exclude =
	\ '^\(\.git\|\.hg\|\.svn\|\.stversions\|\.mypy_cache\|\.pytest_cache'
	\ . '\|__pycache__\|\.DS_Store\)$'

let g:fern#mark_symbol = ''

let g:fern_git_status#disable_submodules = 1

" Private
" ---

let s:original_width = g:fern#drawer_width

nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>

hi link FernBranchText Directory
hi link FernLeafText Normal

function! s:init_fern()
	setlocal nonumber norelativenumber
	setlocal nofoldenable foldmethod=manual

	silent! nnoremap <buffer> f <Nop>
	silent! nnoremap <buffer> F <Nop>
	silent! nnoremap <buffer> t <Nop>
	silent! nnoremap <buffer> T <Nop>
	silent! xnoremap <buffer> f <Nop>
	silent! xnoremap <buffer> F <Nop>
	silent! xnoremap <buffer> t <Nop>
	silent! xnoremap <buffer> T <Nop>
	silent! onoremap <buffer> f <Nop>
	silent! onoremap <buffer> F <Nop>
	silent! onoremap <buffer> t <Nop>
	silent! onoremap <buffer> T <Nop>

	" Perform 'open' on leaf node and 'enter' on branch node
	nmap <buffer><silent> <Plug>(fern-action-open-and-close)
		\ <Plug>(fern-action-open)
		\<Plug>(fern-close-drawer)

	" Open file or expand
	nmap <buffer><expr>
		\ <Plug>(fern-my-open-or-expand)
		\ fern#smart#leaf(
		\   "\<Plug>(fern-action-open-and-close)",
		\   "\<Plug>(fern-action-expand:stay)",
		\   "\<Plug>(fern-action-collapse)",
		\ )

	" Always stay on current node when expading
	nmap <buffer> <Plug>(fern-action-expand) <Plug>(fern-action-expand:stay)

	" Mappings
	nmap <buffer><silent> <Esc>  <Plug>(fern-close-drawer)
	nmap <buffer><silent> q      <Plug>(fern-close-drawer)
	nmap <buffer><silent> <C-c>  <Plug>(fern-action-cancel)
	nmap <buffer><silent> a      <Plug>(fern-action-choice)
	nmap <buffer><silent> C      <Plug>(fern-action-clipboard-copy)
	nmap <buffer><silent> M      <Plug>(fern-action-clipboard-move)
	nmap <buffer><silent> P      <Plug>(fern-action-clipboard-paste)
	nmap <buffer><silent> h      <Plug>(fern-action-collapse)
	nmap <buffer><silent> c      <Plug>(fern-action-copy)
	nmap <buffer><silent> fe     <Plug>(fern-action-exclude)
	nmap <buffer><silent> fi     <Plug>(fern-action-include)
	nmap <buffer><silent> ?      <Plug>(fern-action-help)
	nmap <buffer><silent> .      <Plug>(fern-action-hidden)
	nmap <buffer><silent> <BS>   <Plug>(fern-action-leave)
	nmap <buffer><silent> m      <Plug>(fern-action-move)
	nmap <buffer><silent> K      <Plug>(fern-action-new-dir)
	" nmap <buffer><silent>        <Plug>(fern-action-new-file)
	nmap <buffer><silent> N      <Plug>(fern-action-new-path)
	nmap <buffer><sillnt> o      <Plug>(fern-action-open)
	nmap <buffer><silent> <CR>   <Plug>(fern-action-open-or-enter)
	nmap <buffer><silent> l      <Plug>(fern-my-open-or-expand)
	nmap <buffer><silent> <C-CR> <Plug>(fern-action-open:select)
	nmap <buffer><silent> x      <Plug>(fern-action-open:system)
	nmap <buffer><silent> sp     <Plug>(fern-action-open:split)
	nmap <buffer><silent> sv     <Plug>(fern-action-open:vsplit)
	nmap <buffer><silent> t     <Plug>(fern-action-open:tabedit)
	nmap <buffer><silent> <C-r>  <Plug>(fern-action-reload)
	nmap <buffer><silent> R      <Plug>(fern-action-rename)
	" nmap <buffer><silent> .      <Plug>(fern-action-repeat)
	" nmap <buffer><silent> i      <Plug>(fern-action-reveal)
	nmap <buffer><silent> rm     <Plug>(fern-action-remove)
	nmap <buffer><silent> yy     <Plug>(fern-action-yank)
	nmap <buffer><silent> w
		\ :<C-u>call fern#helper#call(funcref('<SID>toggle_width'))<CR>

	" Selection
	nmap <buffer><silent> u <Plug>(fern-action-mark:clear)
	nmap <buffer><silent> J <Plug>(fern-action-mark)j
	nmap <buffer><silent> K <Plug>(fern-action-mark)k
	nmap <buffer><silent><nowait> <Space> <Plug>(fern-action-mark)j

	" Find and enter project root
	nnoremap <buffer><silent>
		\ <Plug>(fern-user-enter-project-root)
		\ :<C-u>call fern#helper#call(funcref('<SID>enter_project_root'))<CR>
	nmap <buffer><expr><silent> ^
		\ fern#smart#scheme("^", {'file': "\<Plug>(fern-user-enter-project-root)"})
endfunction

augroup fern-custom
	autocmd! *
	autocmd FileType fern call s:init_fern()
augroup END

function! s:get_selected_nodes(helper) abort
	let nodes = a:helper.sync.get_selected_nodes()
	return empty(nodes) ? [a:helper.sync.get_cursor_node()] : nodes
endfunction

function! s:get_selected_paths(helper) abort
	let l:nodes = s:get_selected_nodes(a:helper)
	return map(l:nodes, {_, val ->
		\ val.status == g:fern#STATUS_NONE || val.status == g:fern#STATUS_COLLAPSED
		\ ? fnamemodify(val._path, ':h') : val._path})
endfunction

function! s:enter_project_root(helper) abort
	let root = a:helper.sync.get_root_node()
	let path = root._path
	let path = finddir('.git/..', path . ';')
	execute printf('Fern %s', fnameescape(path))
endfunction

" Toggle Fern drawer window width: original, half, max
function! s:toggle_width(helper) abort
	if ! a:helper.sync.is_drawer()
		return
	endif

	let l:max = 0
	for l:line in range(1, line('$'))
		let l:len = strdisplaywidth(substitute(getline(l:line), '\s\+$', '', ''))
		let l:max = max([l:len + 1, l:max])
	endfor

	let l:current = winwidth(0)
	let l:half = s:original_width + (l:max - s:original_width) / 2
	let g:fern#drawer_width =
		\ l:current == s:original_width ? l:half :
		\ l:current == l:half ? l:max : s:original_width

	execute printf('%d wincmd |', float2nr(g:fern#drawer_width))
endfunction
