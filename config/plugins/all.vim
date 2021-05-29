if dein#tap('defx.nvim')
	nnoremap <silent> <LocalLeader>e
				\ :<C-u>Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>
	nnoremap <silent> <LocalLeader>a
				\ :<C-u>Defx -resume -buffer-name=tab`tabpagenr()` -search=`expand('%:p')`<CR>
endif

if dein#tap('vim-fugitive')
	nnoremap <silent> <Leader>gs :Gstatus<CR>
	nnoremap <silent> <Leader>gd :Gdiff<CR>
	nnoremap <silent> <Leader>gc :Gcommit<CR>
	nnoremap <silent> <Leader>gb :Gblame<CR>
	nnoremap <silent> <Leader>gl :Glog<CR>
	nnoremap <silent> <Leader>gp :Git push<CR>
	nnoremap <silent> <Leader>gr :Gread<CR>
	nnoremap <silent> <Leader>gw :Gwrite<CR>
	nnoremap <silent> <Leader>ge :Gedit<CR>
	" Mnemonic _i_nteractive
	nnoremap <silent> <Leader>gi :Git add -p %<CR>
	nnoremap <silent> <Leader>gg :call spacevim#plug#toggle#Git()<CR>
endif

if dein#tap('vim-gitgutter')
	" consistent with airline
	let g:gitgutter_sign_added = '+'
	let g:gitgutter_sign_modified = '~'
	let g:gitgutter_sign_removed = '-'
	let g:gitgutter_sign_removed_first_line = '^^'
	let g:gitgutter_sign_modified_removed = 'ww'
	let g:gitgutter_override_sign_column_highlight = 0
	nmap ]g <Plug>(GitGutterNextHunk)
	nmap [g <Plug>(GitGutterPrevHunk)
	nmap gS <Plug>(GitGutterStageHunk)
	xmap gS <Plug>(GitGutterStageHunk)
	nmap <Leader>gr <Plug>(GitGutterUndoHunk)
	nmap gs <Plug>(GitGutterPreviewHunk)
endif

if dein#tap('vim-signify')
	let g:signify_sign_delete            = '-'
	let g:signify_sign_delete_first_line = '^^'
	let g:signify_sign_change            = '~'
endif

if dein#tap('vim-which-key')
	nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
	vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
	nnoremap <silent> <localleader> :<c-u>WhichKey ';'<CR>
	vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ';'<CR>
endif

if dein#tap('vim-clap')
	nnoremap <silent><Leader>ff :Clap files<CR>
	nnoremap <silent><Leader>bb :Clap buffers<CR>
	nnoremap <silent><Leader>fl :Clap blines<CR>
	nnoremap <silent><Leader>fL :Clap lines<CR>
	nnoremap <silent><Leader>rg :Clap grep<CR>
	nnoremap <silent><Leader>wi :Clap windows<CR>
	cnoremap <C-R> :Clap hist:<CR>
	nnoremap <silent><Leader>? :Clap command<CR>

	autocmd user_events FileType clap_input call s:clap_mappings()

	function! s:clap_mappings()
		inoremap <silent> <buffer> <Tab>   <C-R>=clap#navigation#linewise('down')<CR>
		inoremap <silent> <buffer> <S-Tab> <C-R>=clap#navigation#linewise('up')<CR>
		nnoremap <silent> <buffer> <C-f> :<c-u>call clap#navigation#scroll('down')<CR>
		nnoremap <silent> <buffer> <C-b> :<c-u>call clap#navigation#scroll('up')<CR>
		nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
		inoremap <silent> <buffer> <Esc> <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
	endfunction
endif

if dein#tap('vim-go')
	autocmd user_events FileType go
				\   nmap <C-]> <Plug>(go-def)
				\ | nmap <Leader>god  <Plug>(go-describe)
				\ | nmap <Leader>goc  <Plug>(go-callees)
				\ | nmap <Leader>goC  <Plug>(go-callers)
				\ | nmap <Leader>goi  <Plug>(go-info)
				\ | nmap <Leader>gom  <Plug>(go-implements)
				\ | nmap <Leader>gos  <Plug>(go-callstack)
				\ | nmap <Leader>goe  <Plug>(go-referrers)
				\ | nmap <Leader>gor  <Plug>(go-run)
				\ | nmap <Leader>gov  <Plug>(go-vet)
endif

if dein#tap('goyo.vim')
	nnoremap <Leader>G :Goyo<CR>
endif

if dein#tap('python-mode')
	if dein#tap('ale')
		let g:pymode_lint = 0
	endif
endif

if dein#tap('vim-commentary')
	nmap <Leader>// gcc
	omap <Leader>// <Plug>Commentary
	vmap <Leader>// <Plug>Commentary
	autocmd FileType vue setlocal commentstring=//\ %s
endif

if dein#tap('coc.nvim')
	source $VIM_PATH/config/plugins/coc.vim
endif

if dein#tap('vim-oscyank')
	vnoremap <leader>c :OSCYank<CR>
	autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
endif
