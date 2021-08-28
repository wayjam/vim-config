if dein#tap('defx.nvim')
	nnoremap <silent> <LocalLeader>e
				\ :<C-u>Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>
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
	nnoremap <silent> <localleader> :<c-u>WhichKey '\'<CR>
	vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\'<CR>
endif

if dein#tap('vim-clap')
	nnoremap <silent><Leader>ff :Clap files<CR>
	nnoremap <silent><Leader>gf :Clap gfiles<CR>
	nnoremap <silent><Leader>bf :Clap buffers<CR>
	nnoremap <silent><Leader>bl :Clap blines<CR>
	nnoremap <silent><Leader>fl :Clap lines<CR>
	nnoremap <silent><Leader>rg :Clap grep<CR>
	nnoremap <silent><Leader>wi :Clap windows<CR>
	nnoremap <silent><Leader>? :Clap<CR>
	nnoremap <silent><localleader><localleader> :Clap command<CR>
	nnoremap <silent><leader>/ :Clap command<CR>

	autocmd user_events FileType clap_input call s:clap_mappings()

	function! s:clap_mappings()
		nnoremap <silent> <buffer> <C-j> :<C-u>call clap#navigation#linewise('down')<CR>
		nnoremap <silent> <buffer> <C-k> :<C-u>call clap#navigation#linewise('up')<CR>
		nnoremap <silent> <buffer> <C-f> :<c-u>call clap#navigation#scroll('down')<CR>
		nnoremap <silent> <buffer> <C-b> :<c-u>call clap#navigation#scroll('up')<CR>

		nnoremap <silent> <buffer> vsp  :<c-u>call clap#handler#try_open('ctrl-v')<CR>
		nnoremap <silent> <buffer> sp  :<c-u>call clap#handler#try_open('ctrl-x')<CR>
		nnoremap <silent> <buffer> t  :<c-u>call clap#handler#try_open('ctrl-t')<CR>

		nnoremap <silent> <buffer> q     :<c-u>call clap#handler#exit()<CR>
		nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
		inoremap <silent> <buffer> <Esc> <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
		inoremap <silent> <buffer> jj    <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>

	endfunction
endif

if dein#tap('vim-go')
	autocmd user_events FileType go
				\   nmap <C-]> <Plug>(go-def)
				\ | nmap <localleader>god  <Plug>(go-describe)
				\ | nmap <localleader>goc  <Plug>(go-callees)
				\ | nmap <localleader>goC  <Plug>(go-callers)
				\ | nmap <localleader>goi  <Plug>(go-info)
				\ | nmap <localleader>gom  <Plug>(go-implements)
				\ | nmap <localleader>gos  <Plug>(go-callstack)
				\ | nmap <localleader>goe  <Plug>(go-referrers)
				\ | nmap <localleader>gor  <Plug>(go-run)
				\ | nmap <localleader>gov  <Plug>(go-vet)
endif

if dein#tap('goyo.vim')
	nnoremap <localleader>G :Goyo<CR>
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
	autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg + | endif
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
	" map f <Plug>Sneak_f
	" map F <Plug>Sneak_F
	map t <Plug>Sneak_t
	map T <Plug>Sneak_T
endif

if dein#tap('vim-easy-align')
	" Start interactive EasyAlign in visual mode (e.g. vipga)
	xmap ga <Plug>(EasyAlign)
	" Start interactive EasyAlign for a motion/text object (e.g. gaip)
	nmap ga <Plug>(EasyAlign)
endif

if dein#tap('vim-floaterm')
	" let g:floaterm_autoclose = 1
	nnoremap <silent> <C-/> :FloatermNew<CR>
	tnoremap <silent> <C-/> <C-\><C-n>:FloatermNew<CR>
	nnoremap <silent> <C-[> :FloatermPrev<CR>
	tnoremap <silent> <C-[> <C-\><C-n>:FloatermPrev<CR>
	nnoremap <silent> <C-]> :FloatermNext<CR>
	tnoremap <silent> <C-]> <C-\><C-n>:FloatermNext<CR>
	nnoremap <silent> <localleader><tab> :FloatermToggle<CR>
	tnoremap <silent> <localleader><tab> <C-\><C-n>:FloatermToggle<CR>

	nnoremap <silent> <esc> :FloatermHide<CR>
	tnoremap <silent> <esc> <C-\><C-n>:FloatermHide<CR>
endif
