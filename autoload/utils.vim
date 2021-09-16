" ===
" General utilities, mainly for dealing with user configuration parsing
" ===

" Set main configuration directory as parent directory
let g:CONFIG_PATH =
			\ get(g:, 'etc_vim_path',
			\   exists('*stdpath') ? stdpath('config') :
			\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
			\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
			\   ! empty(g:CONFIG_PATH) ? expand(g:CONFIG_PATH) :
			\   fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
			\ )

" Set data/cache directory
let g:DATA_PATH = exists('*stdpath') ? stdpath('data') :
			\ expand(($XDG_DATA_HOME ? $XDG_DATA_HOME : '~/.local/share') . '/nvim', 1)

function! utils#init()
	call s:define_command()
endfunction

function! s:define_command()
	command! -nargs=1 IncludeScript call utils#source_file('<args>')
endfunction

function! utils#source_file(path, ...)
	" Source user configuration files with set/global sensitivity
	let use_global = get(a:000, 0, ! has('vim_starting'))
	let abspath = resolve(g:CONFIG_PATH . '/' . a:path)

	if !filereadable(abspath)
		return
	endif

	if ! use_global
		execute 'source' fnameescape(abspath)
		return
	endif

	let tempfile = tempname()
	let content = map(readfile(abspath),
				\ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
	try
		call writefile(content, tempfile)
		execute printf('source %s', fnameescape(tempfile))
	finally
		if filereadable(tempfile)
			call delete(tempfile)
		endif
	endtry
endfunction

function! utils#echo(val)
	echo a:val
endfunction

function! utils#logError(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! utils#logDebug(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction
