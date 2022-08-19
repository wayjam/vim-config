function! plugins#source(name)
	
	call utils#source_file("/config/plugins/" . a:name . ".vim")

endfunction

function! plugins#config(name)

	if a:name ==# 'vim-fugitive'
		nnoremap <silent> <Leader>gs :Git status<CR>
		nnoremap <silent> <Leader>gd :Gdiff<CR>
		nnoremap <silent> <Leader>gc :Git commit<CR>
		nnoremap <silent> <Leader>gb :Git blame<CR>
		nnoremap <silent> <Leader>gl :Git log<CR>
		nnoremap <silent> <Leader>gp :Git push<CR>
		nnoremap <silent> <Leader>gr :Gread<CR>
		nnoremap <silent> <Leader>gw :Gwrite<CR>
		nnoremap <silent> <Leader>ge :Gedit<CR>
		nnoremap <silent> <Leader>gF :diffget //2<CR>
		nnoremap <silent> <Leader>gJ :diffget //3<CR>
		" Mnemonic _i_nteractive
		nnoremap <silent> <leader>gi :git add -p %<cr>
	endif

	if a:name ==# 'vim-easy-align'
		" Start interactive EasyAlign in visual mode (e.g. vipga)
		xmap ga <Plug>(EasyAlign)
		" Start interactive EasyAlign for a motion/text object (e.g. gaip)
		nmap ga <Plug>(EasyAlign)
	endif

	if a:name ==# 'sleuth'
		let g:sleuth_neighbor_limit = 5
		autocmd user_events FileType markdown,yaml,help
			\ let b:sleuth_automatic = 0
	end

endfunction
