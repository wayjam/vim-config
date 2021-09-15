" ===
" Runtime Initialize
" ===

if &compatible
	" vint: -ProhibitSetNoCompatible
	set nocompatible
	" vint: +ProhibitSetNoCompatible
endif

let g:is_win = (has('win32') || has('win64')) ? v:true : v:false
let g:is_linux = (has('unix') && !has('macunix')) ? v:true : v:false
let g:is_mac = has('macunix') ? v:true : v:false

" Initialize Global util
call utils#init()

" Initialize startup settings
if has('vim_starting')
	" Use spacebar as leader and ; as secondary-leader
	" Required before loading plugins!
	let g:mapleader="\<Space>"
	let g:maplocalleader="\\"

	" Release keymappings prefixes, evict entirely for use of plug-ins.
	nnoremap <Space>  <Nop>
	xnoremap <Space>  <Nop>
	nnoremap \        <Nop>
	xnoremap \        <Nop>
endif

" load main config files
" Set custom augroup
augroup user_events
	autocmd!
augroup END

" Disable vim distribution plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_rrhelper = 1  " ?
let g:loaded_shada_plugin = 1  " ?
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" Set main configuration directory as parent directory
let g:VIM_PATH =
			\ get(g:, 'etc_vim_path',
			\   exists('*stdpath') ? stdpath('config') :
			\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
			\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
			\   ! empty(g:VIM_PATH) ? expand(g:VIM_PATH) :
			\   fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
			\ )

" Set data/cache directory
let g:DATA_PATH = exists('*stdpath') ? stdpath('data') :
			\ expand(($XDG_DATA_HOME ? $XDG_DATA_HOME : '~/.local/share') . '/nvim', 1)

function! s:main()
	if has('vim_starting')
		" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
		if &runtimepath !~# g:VIM_PATH
			set runtimepath^=g:VIM_PATH
			set runtimepath+=g:VIM_PATH/after
		endif

		" Ensure data directories
		for s:path in [
					\ g:DATA_PATH,
					\ g:DATA_PATH . '/backup',
					\ g:DATA_PATH . '/undo',
					\ g:DATA_PATH . '/backup',
					\ g:DATA_PATH . '/session',
					\ g:VIM_PATH . '/spell' ]
			if ! isdirectory(s:path)
				call mkdir(s:path, 'p', 0700)
			endif
		endfor

		" Try setting up the custom virtualenv created by ./venv.sh
		let l:virtualenv = g:DATA_PATH . '/venv/bin/python'
		if empty(l:virtualenv) || ! filereadable(l:virtualenv)
			" Fallback to old virtualenv location
			let l:virtualenv = g:DATA_PATH . '/venv/neovim3/bin/python'
		endif

		" Python interpreter settings
		if filereadable(l:virtualenv)
			if has('nvim')
				let g:python3_host_prog = l:virtualenv
			elseif has('pythonx')
				execute 'set pythonthreehome=' . fnamemodify(l:virtualenv, ':h:h')
				if has('python3')
					set pyxversion=3
				elseif has('python')
					set pyxversion=2
				endif
			endif
		endif

	endif

	" Initialize all my configurations
	IncludeScript config/general.vim
	IncludeScript config/filetype.vim
	IncludeScript config/mappings.vim

	lua require('setup')

	" Load customize config
	IncludeScript customize.vim

	set secure
endfunction

call s:main()
