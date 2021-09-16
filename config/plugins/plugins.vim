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

	if a:name ==# 'vim-which-key'
		nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
		vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
		nnoremap <silent> <localleader> :<c-u>WhichKey '\'<CR>
		vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\'<CR>
	endif

	if a:name ==# 'vim-go'
		let g:go_highlight_array_whitespace_error = 0
		let g:go_highlight_chan_whitespace_error = 0
		let g:go_highlight_space_tab_error = 0
		let g:go_highlight_trailing_whitespace_error = 0
		let g:go_highlight_extra_types = 1
		let g:go_highlight_build_constraints = 1
		let g:go_highlight_extra_types = 1
		let g:go_highlight_fields = 1
		let g:go_highlight_format_strings = 1
		let g:go_highlight_functions = 1
		let g:go_highlight_function_calls = 1
		let g:go_highlight_function_parameters = 1
		let g:go_highlight_types = 1
		let g:go_highlight_generate_tags = 1
		let g:go_highlight_operators = 1
		let g:go_highlight_string_spellcheck = 0
		let g:go_highlight_variable_declarations = 0
		let g:go_highlight_variable_assignments = 0
		let g:go_term_enabled = 0
		let g:go_def_mapping_enabled = 0
		let g:go_diagnostics_enabled = 0
		let g:go_doc_popup_window = 1
		let g:go_gopls_enabled = 0
		let g:go_code_completion_enabled = 0
		let g:go_doc_keywordprg_enabled = 0
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

	if a:name ==# 'vim-commentary'
		nmap <Leader>// gcc
		omap <Leader>// <Plug>Commentary
		vmap <Leader>// <Plug>Commentary
		autocmd FileType vue setlocal commentstring=//\ %s
	endif

	if a:name ==# 'vim-oscyank'
		vnoremap <leader>c :OSCYank<CR>
		autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
		autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg + | endif
	endif

	if a:name ==# 'vim-sneak'
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

	if a:name ==# 'vim-easy-align'
		" Start interactive EasyAlign in visual mode (e.g. vipga)
		xmap ga <Plug>(EasyAlign)
		" Start interactive EasyAlign for a motion/text object (e.g. gaip)
		nmap ga <Plug>(EasyAlign)
	endif

	if a:name ==# 'vim-editorconfig'
		let g:editorconfig_verbose = 1
		let g:editorconfig_blacklist = {
					\ 'filetype': [
						\   'git.*', 'fugitive', 'help', 'defx', 'denite.*', 'startify',
						\   'vista.*', 'tagbar', 'lsp-.*', 'clap_.*', 'any-jump', 'gina-.*',
						\   'lsp-*'
						\  ],
						\ 'pattern': ['\.un~$']
						\ }

	endif

	if a:name ==# 'vim-cursorword'
		let g:cursorword = 0
		augroup user_plugin_cursorword
			autocmd!
			autocmd FileType json,yaml,markdown,nginx,dosini,conf,text
						\ let b:cursorword = 1
			autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif
			autocmd InsertEnter * if get(b:, 'cursorword', 0) == 1
						\| let b:cursorword = 0
						\| endif
			autocmd InsertLeave * if get(b:, 'cursorword', 1) == 0
						\| let b:cursorword = 1
						\| endif
		augroup END
	endif

	if a:name ==# 'vim-markdown'
		let g:vim_markdown_frontmatter = 1
		let g:vim_markdown_strikethrough = 1
		let g:vim_markdown_conceal = 0
		let g:vim_markdown_conceal_code_blocks = 0
		let g:vim_markdown_new_list_item_indent = 0
		let g:vim_markdown_toc_autofit = 0
		let g:vim_markdown_follow_anchor = 0
		let g:vim_markdown_no_extensions_in_markdown = 1
		let g:vim_markdown_edit_url_in = 'vsplit'
		let g:vim_markdown_fenced_languages = [
					\ 'c++=cpp',
					\ 'viml=vim',
					\ 'bash=sh',
					\ 'ini=dosini',
					\ 'js=javascript',
					\ 'json=javascript',
					\ 'jsx=javascriptreact',
					\ 'tsx=typescriptreact',
					\ 'docker=Dockerfile',
					\ 'makefile=make',
					\ 'py=python'
					\ ]
	endif

	if a:name ==# 'emmet-vim'
		let g:user_emmet_mode = 'i'
		let g:user_emmet_install_global = 0
		let g:user_emmet_install_command = 0
		let g:user_emmet_complete_tag = 0
	endif


	if a:name ==# "vim-javascript"
		let g:javascript_plugin_jsdoc = 1
		let g:javascript_plugin_flow = 1
	endif

	if a:name ==# 'sleuth'
		let g:sleuth_neighbor_limit = 5
		autocmd user_events FileType markdown,yaml,help
					\ let b:sleuth_automatic = 0
	end

endfunction
