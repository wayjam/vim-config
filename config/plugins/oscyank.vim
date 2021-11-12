function! s:add_to_register(str)
  if get(g:, 'loaded_oscyank')
    call OSCYankString(a:str)
  endif
  let @+=a:str
endfunction

vnoremap <leader>c :OSCYank<CR>

autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif

" Yank buffer's absolute path to clipboard
nnoremap <Leader>y :call <SID>add_to_register(expand("%:~:."))<CR>:echo 'Yanked relative path'<CR>
nnoremap <Leader>Y :call <SID>add_to_register(expand("%:p"))<CR>:echo 'Yanked absolute path'<CR>
