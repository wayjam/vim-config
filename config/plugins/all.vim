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
	nnoremap <silent> <Leader>gF :diffget //2<CR>
	nnoremap <silent> <Leader>gJ :diffget //3<CR>
	" Mnemonic _i_nteractive
	nnoremap <silent> <leader>gi :git add -p %<cr>
endif

if dein#tap('vim-signify')
	let g:signify_sign_delete            = '-'
	let g:signify_sign_delete_first_line = '^^'
	let g:signify_sign_change            = '~'
	let g:signify_skip_filetype          = { 'defx': 1 }
endif

if dein#tap('vim-which-key')
	nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
	vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
	nnoremap <silent> <localleader> :<c-u>WhichKey ';'<CR>
	vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ';'<CR>
endif

if dein#tap('vim-clap')
	nnoremap <silent><Leader>ff :Clap files<CR>
	nnoremap <silent><Leader>bf :Clap buffers<CR>
	nnoremap <silent><Leader>bl :Clap blines<CR>
	nnoremap <silent><Leader>fl :Clap lines<CR>
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

if dein#tap('vim-sneak')
	let g:sneak#label = 1

	" case insensitive sneak
	let g:sneak#use_ic_scs = 1

	" remap so I can use , and ; with f and t
	map gS <Plug>Sneak_,
	map gs <Plug>Sneak_;

	" Change the colors
	hi link Sneak Search
	hi link SneakScope Search

	" I like quickscope better for this since it keeps me in the scope of a single line
	 map f <Plug>Sneak_f
	 map F <Plug>Sneak_F
	 map t <Plug>Sneak_t
	 map T <Plug>Sneak_T
endif
