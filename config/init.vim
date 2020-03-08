" ===
" Runtime and Plugins
" ===

if &compatible
	" vint: -ProhibitSetNoCompatible
	set nocompatible
	" vint: +ProhibitSetNoCompatible
endif

" Initialize startup settings
if has('vim_starting')
	" Use spacebar as leader and ; as secondary-leader
	" Required before loading plugins!
	let g:mapleader="\<Space>"
	let g:maplocalleader=';'

	" Release keymappings prefixes, evict entirely for use of plug-ins.
	nnoremap <Space>  <Nop>
	xnoremap <Space>  <Nop>
	nnoremap ,        <Nop>
	xnoremap ,        <Nop>
	nnoremap ;        <Nop>
	xnoremap ;        <Nop>

	" Vim only, Linux terminal settings
	if ! has('nvim') && ! has('gui_running') && ! has('win32') && ! has('win64')
		call s:source_file('config/terminal.vim')
	endif
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
let $VIM_PATH =
			\ get(g:, 'etc_vim_path',
			\   exists('*stdpath') ? stdpath('config') :
			\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
			\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
			\   ! empty($VIM_PATH) ? expand($VIM_PATH) :
			\   fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
			\ )

" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH =
			\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')

" Collection of user plugin list config file-paths
let s:config_paths = get(g:, 'etc_config_paths', [
			\ $VIM_PATH . '/config/plugins.yaml',
			\ ])

" Filter non-existent config paths
call filter(s:config_paths, 'filereadable(v:val)')

function! s:main()
	if has('vim_starting')
		" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
		if &runtimepath !~# $VIM_PATH
			set runtimepath^=$VIM_PATH
		endif

		" Ensure data directories
		for s:path in [
					\ $DATA_PATH,
					\ $DATA_PATH . '/undo',
					\ $DATA_PATH . '/backup',
					\ $DATA_PATH . '/session',
					\ $VIM_PATH . '/spell' ]
			if ! isdirectory(s:path)
				call mkdir(s:path, 'p')
			endif
		endfor

		" Search and use environments specifically made for Neovim.
		if has('nvim') && isdirectory($DATA_PATH . '/venv/neovim2')
			let g:python_host_prog = $DATA_PATH . '/venv/neovim2/bin/python'
		endif

		if has('nvim') && isdirectory($DATA_PATH . '/venv/neovim3')
			let g:python3_host_prog = $DATA_PATH . '/venv/neovim3/bin/python'
		endif

		if ! has('nvim') && has('pythonx')
			if has('python3')
				set pyxversion=3
			elseif has('python')
				set pyxversion=2
			endif
		endif
	endif
	call my#init()
	" define custom command
	" call s:define_command()
	" Initializes package manager
	call s:load_dein()
endfunction


function! s:load_dein()
	let l:cache_path = $DATA_PATH . '/dein'

	if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = 1
		let g:dein#install_max_processes = 16
		let g:dein#install_progress_type = 'echo'
		let g:dein#enable_notification = 0
		let g:dein#install_log_filename = $DATA_PATH . '/dein.log'

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
			" Clone dein if first-time setup
			if ! isdirectory(s:dein_dir)
				execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
				if v:shell_error
					call utils#logError('dein installation has failed! is git installed?')
					finish
				endif
			endif

			execute 'set runtimepath+='.substitute(
						\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
		endif
	endif

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		let l:rc = utils#parse_config_files(s:config_paths)
		if empty(l:rc)
			call utils#logError('Empty plugin list')
			return
		endif

		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path, extend([expand('<sfile>')], s:config_paths))

		for plugin in l:rc
			call dein#add(plugin['repo'], extend(plugin, {}, 'keep'))
		endfor

		call dein#end()

		" Save cached state for faster startups
		if ! g:dein#_is_sudo
			call dein#save_state()
		endif

		" Update or install plugins if a change detected
		if dein#check_install()
			if ! has('nvim')
				set nomore
			endif
			call dein#install()
		endif
	endif

	filetype plugin indent on

	" Only enable syntax when vim is starting
	if has('vim_starting')
		syntax enable
	else
		" Trigger source events, only when vimrc is refreshing
		call dein#call_hook('source')
		call dein#call_hook('post_source')
	endif
endfunction

call s:main()

" Initialize all my configurations
IncludeScript config/general.vim
IncludeScript config/filetype.vim
IncludeScript config/mappings.vim

" Initialize plugins config
IncludeScript config/plugins/all.vim

set secure
