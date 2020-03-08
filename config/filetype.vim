" ===
" FileType settings
" ===

augroup user_plugin_filetype " {{{
	autocmd!

	autocmd FileType gitcommit setlocal spell
	autocmd FileType gitcommit,qfreplace setlocal nofoldenable
	autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

	" https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write
	autocmd FileType css,javascript,javascriptreact setlocal backupcopy=yes

	autocmd FileType python
		\ setlocal foldmethod=indent expandtab smarttab nosmartindent
		\ | setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80

augroup END " }}}
